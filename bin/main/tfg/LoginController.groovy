package tfg

class LoginController {
    
    // Pantalla de Login
    def index() { }

    // Pantalla de Registro
    def registro() { }

    // Lógica para crear la cuenta
    def guardarRegistro() {
        // Si por algún motivo el JS falla y llega aquí un familiar sin código, lo echamos
        if (params.tipoRegistro == "FAMILIAR" && !params.codigo) {
            flash.message = "El código es obligatorio para familiares."
            redirect(action: 'registro')
            return
        }

        Usuario.withTransaction { status ->
            // Intentamos crear el usuario
            def user = new Usuario(
                username: params.email, 
                password: params.password, 
                nombreCompleto: params.nombre
            ).save(flush: true)

            // Solo si el usuario se ha guardado bien, creamos el rol
            if (user && !user.hasErrors()) {
                def rolNombre = (params.tipoRegistro == "CUIDADOR") ? 'ROLE_CUIDADOR' : 'ROLE_FAMILIAR'
                def rol = Rol.findByAuthority(rolNombre)
                
                new UsuarioRol(usuario: user, rol: rol).save(flush: true)
                
                flash.message = "Cuenta creada con éxito."
                redirect(action: 'index')
            } else {
                // Si el usuario no se guardó (ej: email repetido) avisa
                flash.message = "Error: El email ya existe o los datos son incorrectos."
                redirect(action: 'registro')
            }
        }
    }

    def autenticar(String email, String password) {
        def user = Usuario.findByUsernameAndPassword(email, password)
        if (user) {
            session.usuario = user
            flash.message = "¡Has accedido correctamente! Bienvenida, ${user.nombreCompleto}. El resto de la aplicación está en producción."
            // Redirigir según el rol
            redirect(uri: '/') 
        } else {
            flash.error = "Datos incorrectos"
            redirect(action: 'index')
        }
    }
}