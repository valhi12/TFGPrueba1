// Controlador que gestiona el acceso a la aplicación: login, registro y autenticación
package tfg

class LoginController {

    // Pantalla de login — renderiza la vista views/login/index.gsp
    def index() { }
    // Pantalla de registro — renderiza la vista views/login/registro.gsp
    def registro() { }

    // Lógica principal de registro que valida los datos y delega según el tipo de usuario
    def guardarRegistro() {

        // Si el tipo de registro es FAMILIAR y no se proporcionó código, bloquea el registro
        if (params.tipoRegistro == "FAMILIAR" && !params.codigo) {
            flash.message = "El código es obligatorio para familiares."
            // Devuelve al formulario de registro para que introduzca el código
            redirect(action: 'registro')
            return
        }

        // Comprueba si el email introducido ya existe en la base de datos para evitar duplicados
        if (Usuario.findByUsername(params.email)) {
            flash.message = "Este email ya está registrado."
            // Devuelve al formulario de registro para que use un email diferente
            redirect(action: 'registro')
            return
        }

        // Delega el registro al método privado correspondiente según el tipo de usuario
        if (params.tipoRegistro == "FAMILIAR") {
            registrarFamiliar() // El familiar necesita código de invitación válido
        } else {
            registrarCuidador() // El cuidador se registra directamente sin código
        }
    }

    // Registra un familiar validando su código de invitación y vinculándolo al paciente
    private void registrarFamiliar() {
        // Busca una invitación activa que coincida con el código introducido
        def invitacion = Invitacion.findByCodigoAndUsada(params.codigo, false)
        // Si no existe la invitación o ya fue usada, informa del error y detiene el registro
        if (!invitacion) {
            flash.message = "El código no es válido o ya ha sido utilizado."
            redirect(action: 'registro')
            return
        }

        // Validación: el email del formulario debe coincidir con el emailFamiliar de la invitación
        // Compara ambos emails en minúsculas y sin espacios para evitar fallos por formato
        if (params.email?.toLowerCase()?.trim() != invitacion.emailFamiliar?.toLowerCase()?.trim()) {
            flash.message = "Error. El email debe ser el mismo que ha recibido el código."
            // Devuelve al formulario de registro si el email no coincide con la invitación
            redirect(action: 'registro')
            return
        }

        // Crea el objeto usuario familiar con los datos del formulario
        def user = new Usuario(
            username: params.email,  // Email como nombre de usuario único
            password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password), // Contraseña cifrada con BCrypt
            nombreCompleto: params.nombre, // Nombre completo del familiar
            avatar: params.avatar ?: '👤' // Avatar elegido o uno por defecto si no se elige
        )

        // Abre una transacción para guardar usuario, rol, vínculo e invitación juntos o ninguno
        Usuario.withTransaction {
            user.save(flush: true) // Persiste el usuario en la base de datos
            // Si el usuario tuvo errores al guardarse, informa y detiene la transacción
            if (user.hasErrors()) {
                flash.message = "Error al crear la cuenta: datos incorrectos."
                redirect(action: 'registro')
                return
            }
            // Busca el rol ROLE_FAMILIAR en BD y se lo asigna al usuario recién creado
            def rolFamiliar = Rol.findByAuthority('ROLE_FAMILIAR')
            new UsuarioRol(usuario: user, rol: rolFamiliar).save(flush: true)
            // Vincula el familiar con el paciente asociado a la invitación
            new UsuarioPaciente(usuario: user, paciente: invitacion.paciente).save(flush: true)
            // Marca la invitación como usada para que no pueda reutilizarse
            invitacion.usada = true
            invitacion.save(flush: true)
        }

        // Si el usuario se guardó sin errores, redirige al login con mensaje de éxito
        if (!user.hasErrors()) {
            flash.message = "¡Cuenta creada con éxito! Ya puedes iniciar sesión."
            redirect(action: 'index')
        }
    }

    // Registra un cuidador directamente sin necesidad de código de invitación
    private void registrarCuidador() {
        // Crea el objeto usuario cuidador con los datos del formulario
        def user = new Usuario(
            username: params.email,  // Email como nombre de usuario único
            password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password), // Contraseña cifrada con BCrypt
            nombreCompleto: params.nombre, // Nombre completo del cuidador
            avatar: params.avatar ?: '👤' // Avatar elegido o uno por defecto si no se elige
        )

        // Abre una transacción para guardar usuario y rol juntos o ninguno
        Usuario.withTransaction {
            user.save(flush: true) // Persiste el usuario en la base de datos
            // Solo asigna el rol si el usuario se guardó correctamente
            if (!user.hasErrors()) {
                // Busca el rol ROLE_CUIDADOR en BD y se lo asigna al usuario recién creado
                def rolCuidador = Rol.findByAuthority('ROLE_CUIDADOR')
                new UsuarioRol(usuario: user, rol: rolCuidador).save(flush: true)
            }
        }

        // Si el usuario se guardó sin errores, redirige al login con mensaje de éxito
        if (!user.hasErrors()) {
            flash.message = "¡Cuenta creada con éxito! Ya puedes iniciar sesión."
            redirect(action: 'index')
        } else {
            // Si el usuario tuvo errores, informa y devuelve al formulario de registro
            flash.message = "Error al crear la cuenta: datos incorrectos."
            redirect(action: 'registro')
        }
    }

    // Verifica las credenciales del usuario con BCrypt y abre su sesión si son correctas
    def autenticar(String email, String password) {
        // Busca en BD un usuario que coincida con el email introducido
        def user = Usuario.findByUsername(email)
        // Si existe el usuario, verifica la contraseña con BCrypt
        if (user) {
            def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
            // Compara la contraseña introducida con el hash almacenado en BD
            if (encoder.matches(password, user.password)) {
                // Guarda el usuario en sesión para identificarlo en el resto de la aplicación
                session.usuario = user
                // Guardar rol en sesión para uso en layout
                session.rol = UsuarioRol.findByUsuario(user)?.rol?.authority
                // Redirige al controlador de inicio para que gestione la redirección según el rol
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }
        }
        // Si el email no existe o la contraseña no coincide, informa del error
        flash.error = "Datos incorrectos"
        // Devuelve a la pantalla de login para que vuelva a intentarlo
        redirect(action: 'index')
    }
}