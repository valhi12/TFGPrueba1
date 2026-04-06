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

        Usuario.withTransaction { status ->

            if (params.tipoRegistro == "FAMILIAR") {
                def invitacion = Invitacion.findByCodigoAndUsada(params.codigo, false)
                if (!invitacion) {
                    flash.message = "El código no es válido o ya ha sido utilizado."
                    status.setRollbackOnly()
                    redirect(action: 'registro')
                    return
                }

                def user = new Usuario(
                    username: params.email,
                    password: params.password,
                    nombreCompleto: params.nombre
                ).save(flush: true)

                if (!user || user.hasErrors()) {
                    flash.message = "Error: el email ya existe o los datos son incorrectos."
                    status.setRollbackOnly()
                    redirect(action: 'registro')
                    return
                }

                def rolFamiliar = Rol.findByAuthority('ROLE_FAMILIAR')
                new UsuarioRol(usuario: user, rol: rolFamiliar).save(flush: true)
                new UsuarioPaciente(usuario: user, paciente: invitacion.paciente).save(flush: true)

                invitacion.usada = true
                invitacion.save(flush: true)

                flash.message = "Cuenta creada con éxito. ¡Bienvenido!"
                redirect(action: 'index')

            } else {
                def user = new Usuario(
                    username: params.email,
                    password: params.password,
                    nombreCompleto: params.nombre
                ).save(flush: true)

                if (user && !user.hasErrors()) {
                    def rolCuidador = Rol.findByAuthority('ROLE_CUIDADOR')
                    new UsuarioRol(usuario: user, rol: rolCuidador).save(flush: true)
                    flash.message = "Cuenta creada con éxito."
                    redirect(action: 'index')
                } else {
                    flash.message = "Error: el email ya existe o los datos son incorrectos."
                    redirect(action: 'registro')
                }
            }
        }
    }

    def autenticar(String email, String password) {
        def user = Usuario.findByUsernameAndPassword(email, password)
        if (user) {
            session.usuario = user
            redirect(controller: 'inicio', action: 'bienvenida')
        } else {
            flash.error = "Datos incorrectos"
            redirect(action: 'index')
        }
    }
}