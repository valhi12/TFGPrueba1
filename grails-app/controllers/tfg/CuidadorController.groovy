package tfg

class CuidadorController {

    CorreoService correoService

    def crearPaciente() {
        Usuario.withTransaction { status ->

            def usuarioPaciente = new Usuario(
                username: params.email,
                password: params.password,
                nombreCompleto: params.nombre
            ).save(flush: true)

            if (!usuarioPaciente || usuarioPaciente.hasErrors()) {
                flash.error = "Error: el email ya existe o los datos son incorrectos."
                status.setRollbackOnly()
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            def rolPaciente = Rol.findByAuthority('ROLE_PACIENTE')
            new UsuarioRol(usuario: usuarioPaciente, rol: rolPaciente).save(flush: true)

            Date fechaNac = null
            if (params.fechaNacimiento) {
                fechaNac = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(params.fechaNacimiento)
            }

            def paciente = new Paciente(
                nombre: params.nombre,
                dni: params.dni,
                fechaNacimiento: fechaNac
            ).save(flush: true)

            if (!paciente || paciente.hasErrors()) {
                flash.error = "Error al crear el perfil del paciente."
                status.setRollbackOnly()
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            new UsuarioPaciente(usuario: usuarioPaciente, paciente: paciente).save(flush: true)
            new UsuarioPaciente(usuario: session.usuario, paciente: paciente).save(flush: true)

            flash.message = "Paciente '${params.nombre}' creado con éxito."
            redirect(controller: 'inicio', action: 'bienvenida')
        }
    }

    def generarCodigo() {
        Invitacion.withTransaction {
            def paciente = Paciente.findByNombreAndDni(params.nombrePaciente, params.dniPaciente)
            if (!paciente) {
                flash.error = "No se encontró ningún paciente con ese nombre y DNI."
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            // Genera código aleatorio tipo: AB3-X7K2
            def chars = ('A'..'Z') + ('0'..'9')
            Collections.shuffle(chars)
            def codigo = (chars.take(3).join('') + '-' + chars.drop(3).take(4).join('')).toUpperCase()

            def invitacion = new Invitacion(
                codigo: codigo,
                emailFamiliar: params.emailFamiliar,
                paciente: paciente
            ).save(flush: true)

            if (!invitacion || invitacion.hasErrors()) {
                flash.error = "Error al generar el código."
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            flash.codigoGenerado = codigo
            flash.emailFamiliar = params.emailFamiliar
            flash.nombreFamiliar = params.nombreFamiliar
            redirect(controller: 'inicio', action: 'bienvenida')
        }
    }

    def enviarCodigo() {
        try {
            correoService.enviarCodigoInvitacion(params.email, params.nombre, params.codigo)
            flash.message = "Código enviado correctamente a ${params.email}."
        } catch (Exception e) {
            flash.error = "Error: ${e.class.name} - ${e.message} - Causa: ${e.cause?.message}"
        }
        redirect(controller: 'inicio', action: 'bienvenida')
    }
}