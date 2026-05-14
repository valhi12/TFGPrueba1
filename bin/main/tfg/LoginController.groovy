package tfg


//Controlador que gestiona el acceso a la aplicación: login, registro y autenticación
package tfg
class LoginController {
    
    //Pantalla de Login. renderiza la vista views/login/index.gsp
    def index() { }

    //Pantalla de Registro. renderiza la vista views/login/registro.gsp
    def registro() { }

    //Lógica para crear la cuenta
    def guardarRegistro() {
        //Si por algún motivo el JS falla y llega aquí un familiar sin código, lo echamos
        if (params.tipoRegistro == "FAMILIAR" && !params.codigo) {
            flash.message = "El código es obligatorio para familiares."
            redirect(action: 'registro')
            return
        }

        //Abre una transacción para garantizar que usuario y rol se crean juntos o ninguno
        Usuario.withTransaction { status ->
            //Intentamos crear el usuario con los datos del formulario
            def user = new Usuario(
                //El email actúa como nombre de usuario único
                username: params.email, 
                //Cifra la contraseña con BCrypt antes de guardarla
                password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password), 
                //Nombre visible del usuario en la aplicación
                nombreCompleto: params.nombre
            ).save(flush: true)

            // Solo si el usuario se ha guardado bien, creamos el rol
            if (user && !user.hasErrors()) {
                //Determina el rol según el tipo de registro recibido del formulario
                def rolNombre = (params.tipoRegistro == "CUIDADOR") ? 'ROLE_CUIDADOR' : 'ROLE_FAMILIAR'
                //Busca el rol correspondiente en la base de datos
                def rol = Rol.findByAuthority(rolNombre)
                
                //Crea la relación entre el usuario y su rol en la tabla intermedia UsuarioRol
                new UsuarioRol(usuario: user, rol: rol).save(flush: true)
                
                flash.message = "Cuenta creada con éxito."
                redirect(action: 'index')
            } else {
                //Si el usuario no se guardó (ej: email repetido) avisa
                flash.message = "Error: El email ya existe o los datos son incorrectos."
                redirect(action: 'registro')
            }
        }
    }

    //Método que verifica las credenciales del usuario y abre su sesión si son correctas
    def autenticar(String email, String password) {
        //Busca en BD un usuario que coincida exactamente con email y contraseña
        def user = Usuario.findByUsernameAndPassword(email, password)
        if (user) {
            session.usuario = user
            flash.message = "¡Has accedido correctamente! Bienvenida, ${user.nombreCompleto}. El resto de la aplicación está en producción."
            //Redirigir según el rol
            redirect(uri: '/') 
        } else {
            flash.error = "Datos incorrectos"
            redirect(action: 'index')
        }
    }
}