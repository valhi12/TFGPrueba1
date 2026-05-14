// Controlador que gestiona la página de perfil del usuario: datos personales y contraseña
package tfg

class PerfilController {

    // Muestra la página de perfil
    def index() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        // Recarga desde BD para tener datos frescos en lugar de usar los de la sesión
        usuario = Usuario.get(usuario.id)
        // Pasa el usuario recargado a la vista views/perfil/index.gsp
        [usuario: usuario]
    }

    // Guarda cambios de datos personales (nombre + avatar)
    def guardarDatos() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        // Abre una transacción para guardar los cambios de forma segura
        Usuario.withTransaction {
            // Recarga el usuario desde BD para trabajar con datos actualizados
            def u = Usuario.get(usuario.id)
            // Actualiza el nombre completo solo si se recibió un valor del formulario
            if (params.nombreCompleto) u.nombreCompleto = params.nombreCompleto
            // Actualiza el avatar solo si se recibió un valor del formulario
            if (params.avatar)         u.avatar = params.avatar
            // Persiste los cambios en la base de datos
            u.save(flush: true)
            // Actualizar también la sesión para que los cambios se reflejen de inmediato
            session.usuario = u
        }

        // Notifica al usuario que sus datos se actualizaron correctamente
        flash.message = "Datos actualizados correctamente."
        redirect(action: 'index')
    }

    // Cambia la contraseña con verificación de la actual
    def cambiarPassword() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        // Obtiene los tres valores del formulario de cambio de contraseña
        def actual    = params.passwordActual    // Contraseña actual para verificar la identidad
        def nueva     = params.passwordNueva     // Nueva contraseña que se quiere establecer
        def confirmar = params.passwordConfirmar // Repetición de la nueva contraseña para confirmar

        // Crea un encoder BCrypt para verificar y cifrar contraseñas
        def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
        // Recarga el usuario desde BD para tener el hash de contraseña actualizado
        def u = Usuario.get(usuario.id)

        // Verifica que la contraseña actual introducida coincide con la almacenada en BD
        if (!encoder.matches(actual, u.password)) {
            flash.error = "La contraseña actual no es correcta."
            redirect(action: 'index')
            return
        }

        // Valida que la nueva contraseña tiene al menos 6 caracteres
        if (!nueva || nueva.length() < 6) {
            flash.error = "La nueva contraseña debe tener al menos 6 caracteres."
            redirect(action: 'index')
            return
        }

        // Valida que la nueva contraseña y su confirmación son idénticas
        if (nueva != confirmar) {
            flash.error = "Las contraseñas nuevas no coinciden."
            redirect(action: 'index')
            return
        }

        // Abre una transacción para guardar la nueva contraseña cifrada de forma segura
        Usuario.withTransaction {
            // Cifra la nueva contraseña con BCrypt antes de guardarla en BD
            u.password = encoder.encode(nueva)
            u.save(flush: true)
        }

        // Notifica al usuario que su contraseña se cambió correctamente
        flash.message = "Contraseña cambiada correctamente."
        redirect(action: 'index')
    }
}