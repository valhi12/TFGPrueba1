// Controlador que gestiona la redirección post-login según el rol y el cierre de sesión
package tfg

class InicioController {

    // Redirige al usuario a su panel correspondiente según su rol tras iniciar sesión
    def bienvenida() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        // Busca el rol asignado al usuario en la tabla UsuarioRol
        def usuarioRol = UsuarioRol.findByUsuario(usuario)
        // Obtiene el nombre del rol o 'Sin rol' si no tiene ninguno asignado
        def rol = usuarioRol?.rol?.authority ?: 'Sin rol'

        // Si el usuario es familiar, lo redirige directamente a su panel
        if (rol == 'ROLE_FAMILIAR') {
            redirect(controller: 'familiar', action: 'bienvenida')
            return
        }

        // Si el usuario es paciente, lo redirige directamente a su visor de recuerdos
        if (rol == 'ROLE_PACIENTE') {
            redirect(controller: 'paciente', action: 'bienvenida')
            return
        }

        // Si el usuario es cuidador, pasa sus datos a la vista views/inicio/bienvenida.gsp
        [usuario: usuario, rol: rol]
    }

    // Cierra la sesión del usuario y lo redirige a la pantalla de login
    def logout() {
        // Invalida la sesión HTTP eliminando todos los datos almacenados en ella
        session.invalidate()
        // Redirige al login para que el usuario pueda volver a identificarse
        redirect(controller: 'login', action: 'index')
    }
}