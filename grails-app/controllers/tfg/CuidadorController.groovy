package tfg

class CuidadorController {

    CorreoService correoService

    def crearPaciente() {
        Usuario.withTransaction { status ->

            def usuarioPaciente = new Usuario(
                username: params.email,
                password: params.password,
                nombreCompleto: params.nombre,
                avatar: params.avatar ?: '👴🏻'
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

    def buscarAlbum() {
        def dni = params.dni?.trim()
        def paciente = Paciente.findByDni(dni)

        if (!nombre || !dni) {
            flash.errorZip = "Debes introducir el nombre y el DNI del paciente."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        def paciente = Paciente.findByNombreAndDni(nombre, dni)
        if (!paciente) {
            flash.errorZip = "No se encontró ningún paciente con ese nombre y DNI."
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
        sb.append("ÁLBUM: ${album.titulo}\n")
        sb.append("Paciente: ${album.paciente.nombre}\n")
        sb.append("Creado el: ${new java.text.SimpleDateFormat('dd/MM/yyyy').format(album.fechaCreacion)}\n\n")
        recuerdos.eachWithIndex { recuerdo, i ->
            sb.append("--- Foto ${i+1} ---\n")
            sb.append("Etiqueta: ${recuerdo.etiqueta ?: 'Sin etiqueta'}\n")
            sb.append("Fecha: ${recuerdo.fecha ? new java.text.SimpleDateFormat('dd/MM/yyyy').format(recuerdo.fecha) : 'Sin fecha'}\n")
            sb.append("Descripción: ${recuerdo.texto ?: 'Sin descripción'}\n\n")
        }
        zipOut.write(sb.toString().bytes)
        zipOut.closeEntry()

        zipOut.finish()
        zipOut.flush()
    }

    def eliminarCuentaPaciente() {
        def dni = params.dni?.trim()

        // Buscamos solo por DNI
        def paciente = Paciente.findByDni(dni)
        
        if (!paciente) {
            flash.errorEliminar = "No se encontró ningún paciente con el DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        Usuario.withTransaction {
            // 1. Identificamos al Usuario que tiene el rol de paciente para este perfil
            def vinculos = UsuarioPaciente.findAllByPaciente(paciente)
            def usuarioPaciente = vinculos.find { vp -> 
                UsuarioRol.findByUsuario(vp.usuario)?.rol?.authority == 'ROLE_PACIENTE' 
            }?.usuario

            // 2. Borramos recuerdos y álbum
            def album = Album.findByPaciente(paciente)
            if (album) {
                Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) }
                album.delete(flush: true)
            }

            // 3. Borramos invitaciones
            Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }

            // 4. Borramos vínculos en la tabla de unión
            vinculos.each { it.delete(flush: true) }
            
            if (usuarioPaciente) {
                UsuarioPaciente.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) }
            }

            // 5. Borramos el perfil del Paciente
            paciente.delete(flush: true)

            // 6. Borramos el Usuario y su Rol
            if (usuarioPaciente) {
                UsuarioRol.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) }
                usuarioPaciente.delete(flush: true)
            }
        }

        flash.message = "Cuenta del paciente con DNI ${dni} eliminada correctamente."
        redirect(controller: 'inicio', action: 'bienvenida')
    }

    def eliminarCuentaFamiliar() {
        def dni = params.dni?.trim()

        // Nota: Asegúrate de que tu clase Usuario tenga el campo 'dni'
        def usuario = Usuario.findByDni(dni)
        
        if (!usuario) {
            flash.errorEliminar = "No se encontró ningún usuario con DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        def roles = UsuarioRol.findAllByUsuario(usuario)
        if (!roles.any { it.rol.authority == 'ROLE_FAMILIAR' }) {
            flash.errorEliminar = "El usuario con DNI ${dni} no es un familiar."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        Usuario.withTransaction {
            UsuarioPaciente.findAllByUsuario(usuario).each { it.delete(flush: true) }
            UsuarioRol.findAllByUsuario(usuario).each { it.delete(flush: true) }
            usuario.delete(flush: true)
        }

        flash.message = "Cuenta del familiar con DNI ${dni} eliminada correctamente."
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
            def vinculosCuidador = UsuarioPaciente.findAllByUsuario(cuidador)
            def pacientes = vinculosCuidador.collect { it.paciente }
            
            pacientes.each { paciente ->
                def album = Album.findByPaciente(paciente)
                if (album) {
                    Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) }
                    album.delete(flush: true)
                }
                Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }
                UsuarioPaciente.findAllByPaciente(paciente).each { it.delete(flush: true) }
                paciente.delete(flush: true)
            }
            
            UsuarioRol.findAllByUsuario(cuidador).each { it.delete(flush: true) }
            cuidador.delete(flush: true)
        }

        session.invalidate()
        redirect(controller: 'login', action: 'index')
    }
}