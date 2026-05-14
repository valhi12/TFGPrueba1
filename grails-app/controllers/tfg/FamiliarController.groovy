// Controlador que gestiona todas las operaciones del familiar: ver, crear, editar y eliminar el álbum del paciente
package tfg

class FamiliarController {

    // Carga la pantalla principal del familiar con el álbum y recuerdos de su paciente vinculado
    def bienvenida() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }
        // Busca el vínculo entre el usuario familiar y su paciente asignado
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        // Obtiene el paciente a partir del vínculo encontrado
        def paciente = vinculo?.paciente
        // Busca el álbum del paciente si existe, o null si no tiene paciente vinculado
        def album = paciente ? Album.findByPaciente(paciente) : null
        // Ordenar recuerdos cronológicamente desde la BD
        def recuerdos = album ? Recuerdo.findAllByAlbum(album, [sort: 'fecha', order: 'asc']) : []
        // Pasa todos los datos necesarios a la vista de bienvenida del familiar
        [usuario: usuario, paciente: paciente, album: album, recuerdos: recuerdos]
    }

    // Crea un nuevo álbum con portada y recuerdos iniciales para el paciente vinculado
    def crearAlbum() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Busca el vínculo entre el usuario familiar y su paciente asignado
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        // Obtiene el paciente a partir del vínculo encontrado
        def paciente = vinculo?.paciente

        // Si el familiar no tiene paciente vinculado, informa del error y vuelve al panel
        if (!paciente) {
            flash.error = "No tienes ningún paciente vinculado."
            redirect(action: 'bienvenida')
            return
        }

        // Abre una transacción para garantizar que álbum y recuerdos se crean juntos o ninguno
        Album.withTransaction {
            // Obtiene el fichero de portada enviado en el formulario
            def portadaFile = request.getFile('portada')
            def portadaBytes = null
            // Si se subió una portada, la comprime antes de guardarla en BD
            if (portadaFile && !portadaFile.empty) {
                portadaBytes = comprimirImagen(portadaFile.bytes, 800) // Comprime a 800px de ancho máximo
            }

            // Crea el álbum con el título, el paciente y la portada comprimida
            def album = new Album(
                titulo: params.titulo,     // Título del álbum introducido en el formulario
                paciente: paciente,        // Paciente al que pertenece el álbum
                portada: portadaBytes      // Bytes de la portada comprimida o null si no se subió
            ).save(flush: true)

            // Obtiene todos los ficheros de fotos enviados en el formulario
            def archivos = request.getFiles('fotos')
            // Procesa cada foto recibida junto con sus datos del formulario
            archivos.eachWithIndex { fotoFile, i ->
                // Solo procesa el fichero si no está vacío
                if (fotoFile && !fotoFile.empty) {
                    Date fecha = null
                    // Obtiene la fecha del recuerdo usando el índice para mapear con el campo del formulario
                    def fechaStr = params["fecha_${i}"]
                    // Si se proporcionó fecha, la parsea desde el formato del input HTML
                    if (fechaStr) {
                        fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaStr)
                    }
                    // Crea el recuerdo con la foto comprimida y los datos del formulario
                    new Recuerdo(
                        foto: comprimirImagen(fotoFile.bytes, 1200),        // Foto comprimida a 1200px de ancho máximo
                        texto: params["texto_${i}"] ?: '',                  // Descripción del recuerdo o cadena vacía
                        fecha: fecha ?: new Date(),                         // Fecha del recuerdo o fecha actual si no se indicó
                        etiqueta: params["etiqueta_${i}"] ?: 'Otros',       // Categoría del recuerdo o 'Otros' por defecto
                        album: album                                         // Álbum al que pertenece el recuerdo
                    ).save(flush: true)
                }
            }
        }

        // Notifica al familiar que el álbum se creó correctamente
        flash.message = "¡Álbum creado con éxito!"
        redirect(action: 'bienvenida')
    }

    // Método privado que comprime una imagen usando Thumbnailator antes de guardarla en BD
    private byte[] comprimirImagen(byte[] original, int maxAncho) {
        try {
            // Crea un stream de entrada con los bytes originales de la imagen
            def input = new java.io.ByteArrayInputStream(original)
            // Crea un stream de salida donde se escribirá la imagen comprimida
            def output = new java.io.ByteArrayOutputStream()
            // Usa Thumbnailator para redimensionar y comprimir la imagen
            net.coobird.thumbnailator.Thumbnails.of(input)
                .width(maxAncho)          // Limita el ancho máximo al valor recibido como parámetro
                .outputFormat("jpg")      // Convierte siempre a formato JPEG
                .outputQuality(0.75)      // Calidad del 75% para reducir el peso sin perder demasiada calidad
                .toOutputStream(output)
            // Devuelve los bytes de la imagen comprimida
            return output.toByteArray()
        } catch (Exception e) {
            // Si la compresión falla, devuelve la imagen original sin modificar
            return original
        }
    }

    // Guarda los cambios del álbum: actualiza portada, edita recuerdos existentes y añade nuevos
    def guardarCambios() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Busca el vínculo entre el usuario familiar y su paciente asignado
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        // Obtiene el paciente a partir del vínculo encontrado
        def paciente = vinculo?.paciente
        // Busca el álbum del paciente si existe
        def album = paciente ? Album.findByPaciente(paciente) : null

        // Si no existe álbum, informa del error y vuelve al panel
        if (!album) {
            flash.error = "No tienes ningún álbum."
            redirect(action: 'bienvenida')
            return
        }

        // Abre una transacción para guardar todos los cambios juntos o ninguno
        Album.withTransaction {
            // Si se subió una nueva portada, la comprime y actualiza en el álbum
            def portadaFile = request.getFile('portada')
            if (portadaFile && !portadaFile.empty) {
                album.portada = comprimirImagen(portadaFile.bytes, 800) // Comprime a 800px de ancho máximo
                album.save(flush: true) // Guarda el álbum con la nueva portada
            }

            // Itera sobre cada recuerdo existente del álbum para actualizar sus datos
            album.recuerdos?.each { recuerdo ->
                // Obtiene los nuevos valores del formulario usando el id del recuerdo como clave
                def textoParam = params["texto_recuerdo_${recuerdo.id}"]
                def fechaParam = params["fecha_recuerdo_${recuerdo.id}"]
                def etiquetaParam = params["etiqueta_recuerdo_${recuerdo.id}"]
                // Actualiza el texto solo si se recibió un valor del formulario
                if (textoParam != null) recuerdo.texto = textoParam
                // Actualiza la fecha parseándola desde el formato del input HTML
                if (fechaParam) recuerdo.fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaParam)
                // Actualiza la etiqueta solo si se recibió un valor del formulario
                if (etiquetaParam) recuerdo.etiqueta = etiquetaParam
                // Obtiene el fichero de foto usando el id del recuerdo como clave del campo
                def fotoFile = request.getFile("foto_recuerdo_${recuerdo.id}")
                // Si se subió una nueva foto para este recuerdo, la comprime y reemplaza la anterior
                if (fotoFile && !fotoFile.empty) {
                    recuerdo.foto = comprimirImagen(fotoFile.bytes, 1200) // Comprime a 1200px de ancho máximo
                }
                // Guarda el recuerdo con todos sus cambios aplicados
                recuerdo.save(flush: true)
            }

            // Obtiene los nuevos ficheros de fotos adicionales enviados en el formulario
            def archivos = request.getFiles('fotos_nuevas')
            // Procesa cada nueva foto recibida junto con sus datos del formulario
            archivos.eachWithIndex { fotoFile, i ->
                // Solo procesa el fichero si no está vacío
                if (fotoFile && !fotoFile.empty) {
                    Date fecha = null
                    // Obtiene la fecha del nuevo recuerdo usando el índice como clave
                    def fechaStr = params["fecha_nueva_${i}"]
                    // Si se proporcionó fecha, la parsea desde el formato del input HTML
                    if (fechaStr) fecha = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(fechaStr)
                    // Crea el nuevo recuerdo con la foto comprimida y los datos del formulario
                    new Recuerdo(
                        foto: comprimirImagen(fotoFile.bytes, 1200),            // Foto comprimida a 1200px de ancho máximo
                        texto: params["texto_nueva_${i}"] ?: '',                // Descripción del recuerdo o cadena vacía
                        fecha: fecha ?: new Date(),                             // Fecha del recuerdo o fecha actual si no se indicó
                        etiqueta: params["etiqueta_nueva_${i}"] ?: 'Otros',     // Categoría del recuerdo o 'Otros' por defecto
                        album: album                                             // Álbum al que pertenece el nuevo recuerdo
                    ).save(flush: true)
                }
            }
        }

        // Notifica al familiar que los cambios se guardaron correctamente
        flash.message = "¡Cambios guardados con éxito!"
        redirect(action: 'bienvenida')
    }

    // Elimina un recuerdo individual del álbum por su id
    def eliminarRecuerdo() {
        // Busca el recuerdo en BD por el id recibido como parámetro
        def recuerdo = Recuerdo.get(params.id)
        // Si el recuerdo existe, lo elimina dentro de una transacción
        if (recuerdo) {
            Recuerdo.withTransaction { recuerdo.delete(flush: true) }
        }
        // Vuelve al panel del familiar tras la eliminación
        redirect(action: 'bienvenida')
    }

    // Elimina el álbum completo del paciente junto con todos sus recuerdos
    def eliminarAlbum() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Busca el vínculo entre el usuario familiar y su paciente asignado
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        // Obtiene el paciente a partir del vínculo encontrado
        def paciente = vinculo?.paciente
        // Busca el álbum del paciente si existe
        def album = paciente ? Album.findByPaciente(paciente) : null

        // Si el álbum existe, elimina primero sus recuerdos y luego el álbum
        if (album) {
            Album.withTransaction {
                // Obtiene todos los recuerdos del álbum para eliminarlos uno a uno
                def recuerdos = Recuerdo.findAllByAlbum(album)
                recuerdos.each { it.delete(flush: true) } // Elimina cada recuerdo del álbum
                album.recuerdos?.clear() // Limpia la colección en memoria antes de borrar el álbum
                album.delete(flush: true) // Elimina el álbum una vez vaciado de recuerdos
            }
            // Notifica al familiar que el álbum fue eliminado correctamente
            flash.message = "Álbum eliminado correctamente."
        }
        redirect(action: 'bienvenida')
    }

    // Sirve la imagen de portada del álbum directamente desde la base de datos
    def portada() {
        // Busca el álbum en BD por el id recibido como parámetro
        def album = Album.get(params.id)
        // Si el álbum existe y tiene portada, la escribe en la respuesta HTTP como imagen JPEG
        if (album?.portada) {
            response.contentType = 'image/jpeg'                  // Indica al navegador que es una imagen JPEG
            response.outputStream << album.portada               // Escribe los bytes de la portada en el stream de respuesta
            response.outputStream.flush()                        // Vacía el buffer para asegurar el envío completo
        }
    }

    // Sirve la imagen de un recuerdo directamente desde la base de datos
    def foto() {
        // Busca el recuerdo en BD por el id recibido como parámetro
        def recuerdo = Recuerdo.get(params.id)
        // Si el recuerdo existe y tiene foto, la escribe en la respuesta HTTP como imagen JPEG
        if (recuerdo?.foto) {
            response.contentType = 'image/jpeg'                  // Indica al navegador que es una imagen JPEG
            response.outputStream << recuerdo.foto               // Escribe los bytes de la foto en el stream de respuesta
            response.outputStream.flush()                        // Vacía el buffer para asegurar el envío completo
        }
    }
}