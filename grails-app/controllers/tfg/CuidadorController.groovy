package tfg

class CuidadorController {

    CorreoService correoService

    def crearPaciente() {
        Usuario.withTransaction { status ->
            def usuarioPaciente = new Usuario(
                username: params.email,
                password: params.password,
                nombreCompleto: params.nombre,
                avatar: params.avatar ?: '👴🏻',
                dni: params.dni // Asegúrate de que tu clase Usuario tenga el campo dni
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

    def buscarAlbum() {
        def dni = params.dni?.trim()

        if (!dni) {
            flash.errorZip = "Debes introducir el DNI del paciente."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Buscamos SOLO por DNI para evitar el error de "nombre"
        def paciente = Paciente.findByDni(dni)
        
        if (!paciente) {
            flash.errorZip = "No se encontró ningún paciente con el DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        def album = Album.findByPaciente(paciente)
        if (!album) {
            flash.errorZip = "Este paciente aún no tiene álbum disponible."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        redirect(controller: 'inicio', action: 'bienvenida',
            params: [mostrarZip: true, albumId: album.id])
    }

    def descargarZip() {
        def album = Album.get(params.albumId)
        if (!album) {
            flash.errorZip = "Álbum no encontrado."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        def recuerdos = Recuerdo.findAllByAlbum(album).sort { it.fecha }
        response.contentType = 'application/zip'
        response.setHeader('Content-Disposition', "attachment; filename=\"album_${album.titulo.replaceAll(' ', '_')}.zip\"")

        def zipOut = new java.util.zip.ZipOutputStream(response.outputStream)

        if (album.portada) {
            def entry = new java.util.zip.ZipEntry("portada.jpg")
            zipOut.putNextEntry(entry)
            zipOut.write(album.portada)
            zipOut.closeEntry()
        }

        recuerdos.eachWithIndex { recuerdo, i ->
            def nombreArchivo = "${String.format('%02d', i+1)}_${recuerdo.etiqueta ?: 'recuerdo'}.jpg"
            def entry = new java.util.zip.ZipEntry(nombreArchivo)
            zipOut.putNextEntry(entry)
            zipOut.write(recuerdo.foto)
            zipOut.closeEntry()
        }

        def textoEntry = new java.util.zip.ZipEntry("descripciones.txt")
        zipOut.putNextEntry(textoEntry)
        def sb = new StringBuilder()
        sb.append("ÁLBUM: ${album.titulo}\nPaciente: ${album.paciente.nombre}\n\n")
        recuerdos.eachWithIndex { recuerdo, i ->
            sb.append("--- Foto ${i+1} ---\nEtiqueta: ${recuerdo.etiqueta}\nDescripción: ${recuerdo.texto ?: ''}\n\n")
        }
        zipOut.write(sb.toString().bytes)
        zipOut.closeEntry()

        zipOut.finish()
        zipOut.flush()
    }

    def eliminarCuentaPaciente() {
        def dni = params.dni?.trim()
        def paciente = Paciente.findByDni(dni)

        if (!paciente) {
            flash.errorEliminar = "No se encontró ningún paciente con el DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        Usuario.withTransaction {
            def vinculos = UsuarioPaciente.findAllByPaciente(paciente)
            def usuarioPaciente = vinculos.find { vp -> 
                UsuarioRol.findByUsuario(vp.usuario)?.rol?.authority == 'ROLE_PACIENTE' 
            }?.usuario

            def album = Album.findByPaciente(paciente)
            if (album) {
                Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) }
                album.delete(flush: true)
            }

            Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }
            vinculos.each { it.delete(flush: true) }
            
            if (usuarioPaciente) {
                UsuarioPaciente.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) }
            }

            paciente.delete(flush: true)

            if (usuarioPaciente) {
                UsuarioRol.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) }
                usuarioPaciente.delete(flush: true)
            }
        }

        flash.message = "Cuenta del paciente eliminada correctamente."
        redirect(controller: 'inicio', action: 'bienvenida')
    }

    def eliminarCuentaFamiliar() {
        def dni = params.dni?.trim()
        def usuario = Usuario.findByDni(dni)

        if (!usuario) {
            flash.errorEliminar = "No se encontró ningún usuario con DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        Usuario.withTransaction {
            UsuarioPaciente.findAllByUsuario(usuario).each { it.delete(flush: true) }
            UsuarioRol.findAllByUsuario(usuario).each { it.delete(flush: true) }
            usuario.delete(flush: true)
        }

        flash.message = "Cuenta del familiar eliminada correctamente."
        redirect(controller: 'inicio', action: 'bienvenida')
    }

    def eliminarCuentaPropia() {
        def cuidador = session.usuario
        def password = params.password

        if (cuidador.password != password) {
            flash.errorEliminar = "La contraseña introducida no es correcta."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        Usuario.withTransaction {
            def pacientes = UsuarioPaciente.findAllByUsuario(cuidador).collect { it.paciente }
            pacientes.each { paciente ->
                def album = Album.findByPaciente(paciente)
                if (album) {
                    Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) }
                    album.delete(flush: true)
                }
                UsuarioPaciente.findAllByPaciente(paciente).each { it.delete(flush: true) }
                paciente.delete(flush: true)
            }
            UsuarioRol.findAllByUsuario(cuidador).each { it.delete(flush: true) }
            cuidador.delete(flush: true)
        }
        session.invalidate()
        redirect(controller: 'login', action: 'index')
    }

    def generarCodigo() {
        Invitacion.withTransaction {
            def paciente = Paciente.findByDni(params.dniPaciente)
            if (!paciente) {
                flash.error = "No se encontró el paciente con ese DNI."
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }
            def chars = ('A'..'Z') + ('0'..'9')
            Collections.shuffle(chars)
            def codigo = (chars.take(3).join('') + '-' + chars.drop(3).take(4).join('')).toUpperCase()

            new Invitacion(codigo: codigo, emailFamiliar: params.emailFamiliar, paciente: paciente).save(flush: true)
            flash.codigoGenerado = codigo
            flash.emailFamiliar = params.emailFamiliar
            flash.nombreFamiliar = params.nombreFamiliar
            redirect(controller: 'inicio', action: 'bienvenida')
        }
    }

    def enviarCodigo() {
        try {
            correoService.enviarCodigoInvitacion(params.email, params.nombre, params.codigo)
            flash.message = "Código enviado correctamente."
        } catch (Exception e) {
            flash.error = "Error al enviar el correo."
        }
        redirect(controller: 'inicio', action: 'bienvenida')
    }
}