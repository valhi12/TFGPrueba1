package tfg

class LoginController {

    def index() { }
    def registro() { }

    def guardarRegistro() {

        if (params.tipoRegistro == "FAMILIAR" && !params.codigo) {
            flash.message = "El código es obligatorio para familiares."
            redirect(action: 'registro')
            return
        }

        if (Usuario.findByUsername(params.email)) {
            flash.message = "Este email ya está registrado."
            redirect(action: 'registro')
            return
        }

        if (params.tipoRegistro == "FAMILIAR") {
            registrarFamiliar()
        } else {
            registrarCuidador()
        }
    }

    private void registrarFamiliar() {
        def invitacion = Invitacion.findByCodigoAndUsada(params.codigo, false)
        if (!invitacion) {
            flash.message = "El código no es válido o ya ha sido utilizado."
            redirect(action: 'registro')
            return
        }

        def user = new Usuario(
            username: params.email,
            password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password),
            nombreCompleto: params.nombre,
            avatar: params.avatar ?: '👤'
        )

        Usuario.withTransaction {
            user.save(flush: true)
            if (user.hasErrors()) {
                flash.message = "Error al crear la cuenta: datos incorrectos."
                redirect(action: 'registro')
                return
            }
            def rolFamiliar = Rol.findByAuthority('ROLE_FAMILIAR')
            new UsuarioRol(usuario: user, rol: rolFamiliar).save(flush: true)
            new UsuarioPaciente(usuario: user, paciente: invitacion.paciente).save(flush: true)
            invitacion.usada = true
            invitacion.save(flush: true)
        }

        if (!user.hasErrors()) {
            flash.message = "¡Cuenta creada con éxito! Ya puedes iniciar sesión."
            redirect(action: 'index')
        }
    }

    private void registrarCuidador() {
        def user = new Usuario(
            username: params.email,
            password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password),
            nombreCompleto: params.nombre,
            avatar: params.avatar ?: '👤'
        )

        Usuario.withTransaction {
            user.save(flush: true)
            if (!user.hasErrors()) {
                def rolCuidador = Rol.findByAuthority('ROLE_CUIDADOR')
                new UsuarioRol(usuario: user, rol: rolCuidador).save(flush: true)
            }
        }

        if (!user.hasErrors()) {
            flash.message = "¡Cuenta creada con éxito! Ya puedes iniciar sesión."
            redirect(action: 'index')
        } else {
            flash.message = "Error al crear la cuenta: datos incorrectos."
            redirect(action: 'registro')
        }
    }

    def autenticar(String email, String password) {
        def user = Usuario.findByUsername(email)
        if (user) {
            def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
            if (encoder.matches(password, user.password)) {
                session.usuario = user
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }
        }
        flash.error = "Datos incorrectos"
        redirect(action: 'index')
    }
}