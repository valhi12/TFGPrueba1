package tfg

class PerfilController {

   // Muestra la página de perfil
    def index() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        // Recarga desde BD para tener datos frescos
        usuario = Usuario.get(usuario.id)
        [usuario: usuario]
    }

    // Guarda cambios de datos personales (nombre + avatar)
    def guardarDatos() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        Usuario.withTransaction {
            def u = Usuario.get(usuario.id)
            if (params.nombreCompleto) u.nombreCompleto = params.nombreCompleto
            if (params.avatar)         u.avatar = params.avatar
            u.save(flush: true)
            // Actualizar también la sesión
            session.usuario = u
        }

        flash.message = "Datos actualizados correctamente."
        redirect(action: 'index')
    }

    // Cambia la contraseña con verificación de la actual
    def cambiarPassword() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        def actual    = params.passwordActual
        def nueva     = params.passwordNueva
        def confirmar = params.passwordConfirmar

        def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
        def u = Usuario.get(usuario.id)

        if (!encoder.matches(actual, u.password)) {
            flash.error = "La contraseña actual no es correcta."
            redirect(action: 'index')
            return
        }

        if (!nueva || nueva.length() < 6) {
            flash.error = "La nueva contraseña debe tener al menos 6 caracteres."
            redirect(action: 'index')
            return
        }

        if (nueva != confirmar) {
            flash.error = "Las contraseñas nuevas no coinciden."
            redirect(action: 'index')
            return
        }

        Usuario.withTransaction {
            u.password = encoder.encode(nueva)
            u.save(flush: true)
        }

        flash.message = "Contraseña cambiada correctamente."
        redirect(action: 'index')
    }
}