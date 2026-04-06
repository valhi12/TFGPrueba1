package tfg

class InicioController {

    def bienvenida() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        def usuarioRol = UsuarioRol.findByUsuario(usuario)
        def rol = usuarioRol?.rol?.authority ?: 'Sin rol'
        [usuario: usuario, rol: rol]
    }

    def logout() {
        session.invalidate()
        redirect(controller: 'login', action: 'index')
    }
}