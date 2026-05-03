package tfg

class FamiliarController {

    def bienvenida() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        def paciente = vinculo?.paciente
        def album = paciente ? Album.findByPaciente(paciente) : null
        [usuario: usuario, paciente: paciente, album: album]
    }

    def crearAlbum() {
        def usuario = session.usuario
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        def paciente = vinculo?.paciente

        if (!paciente) {
            flash.error = "No tienes ningún paciente vinculado."
            redirect(action: 'bienvenida')
            return
        }

        Album.withTransaction {
            def portadaFile = request.getFile('portada')
            def portadaBytes = null
            if (portadaFile && !portadaFile.empty) {
                portadaBytes = comprimirImagen(portadaFile.bytes, 800)
            }

            def album = new Album(
                titulo: params.titulo,
                paciente: paciente,
                portada: portadaBytes
            ).save(flush: true)

            def archivos = request.getFiles('fotos')
            archivos.eachWithIndex { fotoFile, i ->
                if (fotoFile && !fotoFile.empty) {
                    Date fecha = null
                    def fechaStr = params["fecha_${i}"]
                    if (fechaStr) {
                        fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaStr)
                    }
                    new Recuerdo(
                        foto: comprimirImagen(fotoFile.bytes, 1200),
                        texto: params["texto_${i}"] ?: '',
                        fecha: fecha ?: new Date(),
                        etiqueta: params["etiqueta_${i}"] ?: 'Otros',
                        album: album
                    ).save(flush: true)
                }
            }
        }

        flash.message = "¡Álbum creado con éxito!"
        redirect(action: 'bienvenida')
    }

    private byte[] comprimirImagen(byte[] original, int maxAncho) {
        try {
            def input = new java.io.ByteArrayInputStream(original)
            def output = new java.io.ByteArrayOutputStream()
            net.coobird.thumbnailator.Thumbnails.of(input)
                .width(maxAncho)
                .outputFormat("jpg")
                .outputQuality(0.75)
                .toOutputStream(output)
            return output.toByteArray()
        } catch (Exception e) {
            return original
        }
    }

    def guardarCambios() {
        def usuario = session.usuario
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        def paciente = vinculo?.paciente
        def album = paciente ? Album.findByPaciente(paciente) : null

        if (!album) {
            flash.error = "No tienes ningún álbum."
            redirect(action: 'bienvenida')
            return
        }

        Album.withTransaction {
            def portadaFile = request.getFile('portada')
            if (portadaFile && !portadaFile.empty) {
                album.portada = comprimirImagen(portadaFile.bytes, 800)
                album.save(flush: true)
            }

            album.recuerdos?.each { recuerdo ->
                def textoParam = params["texto_recuerdo_${recuerdo.id}"]
                def fechaParam = params["fecha_recuerdo_${recuerdo.id}"]
                def etiquetaParam = params["etiqueta_recuerdo_${recuerdo.id}"]
                if (textoParam != null) recuerdo.texto = textoParam
                if (fechaParam) recuerdo.fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaParam)
                if (etiquetaParam) recuerdo.etiqueta = etiquetaParam
                def fotoFile = request.getFile("foto_recuerdo_${recuerdo.id}")
                if (fotoFile && !fotoFile.empty) {
                    recuerdo.foto = comprimirImagen(fotoFile.bytes, 1200)
                }
                recuerdo.save(flush: true)
            }

            def archivos = request.getFiles('fotos_nuevas')
            archivos.eachWithIndex { fotoFile, i ->
                if (fotoFile && !fotoFile.empty) {
                    Date fecha = null
                    def fechaStr = params["fecha_nueva_${i}"]
                    if (fechaStr) fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaStr)
                    new Recuerdo(
                        foto: comprimirImagen(fotoFile.bytes, 1200),
                        texto: params["texto_nueva_${i}"] ?: '',
                        fecha: fecha ?: new Date(),
                        etiqueta: params["etiqueta_nueva_${i}"] ?: 'Otros',
                        album: album
                    ).save(flush: true)
                }
            }
        }

        flash.message = "¡Cambios guardados con éxito!"
        redirect(action: 'bienvenida')
    }

    def eliminarRecuerdo() {
        def recuerdo = Recuerdo.get(params.id)
        if (recuerdo) {
            Recuerdo.withTransaction { recuerdo.delete(flush: true) }
        }
        redirect(action: 'bienvenida')
    }

    def eliminarAlbum() {
        def usuario = session.usuario
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        def paciente = vinculo?.paciente
        def album = paciente ? Album.findByPaciente(paciente) : null

        if (album) {
            Album.withTransaction {
                def recuerdos = Recuerdo.findAllByAlbum(album)
                recuerdos.each { it.delete(flush: true) }
                album.recuerdos?.clear()
                album.delete(flush: true)
            }
            flash.message = "Álbum eliminado correctamente."
        }
        redirect(action: 'bienvenida')
    }

    def portada() {
        def album = Album.get(params.id)
        if (album?.portada) {
            response.contentType = 'image/jpeg'
            response.outputStream << album.portada
            response.outputStream.flush()
        }
    }

    def foto() {
        def recuerdo = Recuerdo.get(params.id)
        if (recuerdo?.foto) {
            response.contentType = 'image/jpeg'
            response.outputStream << recuerdo.foto
            response.outputStream.flush()
        }
    }
}