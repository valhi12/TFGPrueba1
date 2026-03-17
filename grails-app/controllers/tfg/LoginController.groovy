package tfg

class LoginController {
    
    // Pantalla de Login
    def index() { }

    // Pantalla de Registro
    def registro() { }

    // Lógica para crear la cuenta
    def guardarRegistro(String nombre, String email, String password, String tipoRegistro, String codigo) {
        Usuario.withTransaction {
            // 1. Crear el usuario
            def user = new Usuario(username: email, password: password, nombreCompleto: nombre).save()
            
            if (tipoRegistro == "CUIDADOR") {
                def rol = Rol.findByAuthority('ROLE_CUIDADOR')
                new UsuarioRol(usuario: user, rol: rol).save()
                // Aquí más adelante haremos que cree el perfil del Paciente
            } else {
                def rol = Rol.findByAuthority('ROLE_FAMILIAR')
                new UsuarioRol(usuario: user, rol: rol).save()
                // Aquí buscaremos el código en el futuro
            }
            
            flash.message = "Cuenta creada con éxito. ¡Ya puedes entrar!"
            redirect(action: 'index')
        }
    }

    def autenticar(String email, String password) {
        def user = Usuario.findByUsernameAndPassword(email, password)
        if (user) {
            session.usuario = user
            // Redirigir según el rol
            redirect(uri: '/') 
        } else {
            flash.error = "Datos incorrectos"
            redirect(action: 'index')
        }
    }
}