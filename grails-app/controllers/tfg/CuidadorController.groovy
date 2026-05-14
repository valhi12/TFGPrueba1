// Controlador que gestiona todas las operaciones del cuidador: pacientes, álbumes, invitaciones y cuentas
package tfg

class CuidadorController {

    // Inyección del servicio de correo para enviar códigos de invitación a familiares
    CorreoService correoService

    // Método privado de seguridad que verifica que el usuario en sesión tiene rol de cuidador
    private boolean verificarCuidador() {
        // Si no hay usuario en sesión, redirige al login
        if (!session.usuario) {
            redirect(controller: 'login', action: 'index')
            return false
        }
        // Obtiene el rol del usuario en sesión desde la tabla UsuarioRol
        def rol = UsuarioRol.findByUsuario(session.usuario)?.rol?.authority
        // Si el rol no es ROLE_CUIDADOR, devuelve un error 403 Forbidden
        if (rol != 'ROLE_CUIDADOR') {
            response.sendError(403)
            return false
        }
        // Si pasa las dos comprobaciones, el acceso es válido
        return true
    }

    // Crea un nuevo paciente con su usuario, rol y vínculos con el cuidador
    def crearPaciente() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Abre una transacción para garantizar que todos los datos se crean juntos o ninguno
        Usuario.withTransaction { status ->
            // Crea el usuario del paciente con los datos del formulario
            def usuarioPaciente = new Usuario(
                username: params.email,           // Email del paciente como nombre de usuario
                password: new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode(params.password), // Contraseña cifrada con BCrypt
                nombreCompleto: params.nombre,    // Nombre completo del paciente
                avatar: params.avatar ?: '👴🏻',  // Avatar elegido o uno por defecto si no se elige
                dni: params.dni                   // DNI del paciente
            ).save(flush: true)

            // Si el usuario no se guardó correctamente, cancela la transacción e informa del error
            if (!usuarioPaciente || usuarioPaciente.hasErrors()) {
                flash.error = "Error: el email ya existe o los datos son incorrectos."
                status.setRollbackOnly() // Marca la transacción para que se deshaga todo
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            // Busca el rol ROLE_PACIENTE en BD y se lo asigna al usuario recién creado
            def rolPaciente = Rol.findByAuthority('ROLE_PACIENTE')
            new UsuarioRol(usuario: usuarioPaciente, rol: rolPaciente).save(flush: true)

            // Inicializa la fecha de nacimiento como nula por si no se introduce
            Date fechaNac = null
            // Si se proporcionó fecha de nacimiento, la parsea desde el formato del input HTML
            if (params.fechaNacimiento) {
                fechaNac = new java.text.SimpleDateFormat('yyyy-MM-dd').parse(params.fechaNacimiento)
                // Valida que la fecha de nacimiento no sea posterior a hoy
                if (fechaNac.after(new Date())) {
                    flash.error = "La fecha de nacimiento no puede ser posterior a la fecha actual."
                    status.setRollbackOnly() // Deshace la transacción si la fecha es inválida
                    redirect(controller: 'inicio', action: 'bienvenida')
                    return
                }
            }

            // Crea el registro Paciente con sus datos médicos y personales
            def paciente = new Paciente(
                nombre: params.nombre,           // Nombre del paciente
                dni: params.dni,                 // DNI del paciente
                fechaNacimiento: fechaNac        // Fecha de nacimiento ya validada
            ).save(flush: true)

            // Si el paciente no se guardó correctamente, cancela la transacción e informa del error
            if (!paciente || paciente.hasErrors()) {
                flash.error = "Error al crear el perfil del paciente."
                status.setRollbackOnly() // Deshace la transacción si falla la creación del paciente
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }

            // Vincula el usuario paciente con su registro Paciente mediante la tabla intermedia
            new UsuarioPaciente(usuario: usuarioPaciente, paciente: paciente).save(flush: true)
            // Vincula también al cuidador en sesión con el paciente para que pueda gestionarlo
            new UsuarioPaciente(usuario: session.usuario, paciente: paciente).save(flush: true)

            // Notifica al cuidador que el paciente se creó correctamente
            flash.message = "Paciente '${params.nombre}' creado con éxito."
            redirect(controller: 'inicio', action: 'bienvenida')
        }
    }

    // Busca el álbum de un paciente por su DNI para preparar la descarga en ZIP
    def buscarAlbum() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Obtiene el DNI del formulario eliminando espacios en blanco
        def dni = params.dni?.trim()

        // Si no se introdujo DNI, avisa y vuelve al panel
        if (!dni) {
            flash.errorZip = "Debes introducir el DNI del paciente."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Busca el paciente en BD por su DNI
        def paciente = Paciente.findByDni(dni)

        // Si no existe ningún paciente con ese DNI, informa del error
        if (!paciente) {
            flash.errorZip = "No se encontró ningún paciente con el DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Busca el álbum asociado al paciente encontrado
        def album = Album.findByPaciente(paciente)
        // Si el paciente existe pero aún no tiene álbum, informa del error
        if (!album) {
            flash.errorZip = "Este paciente aún no tiene álbum disponible."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Redirige al panel pasando el id del álbum para mostrar el botón de descarga ZIP
        redirect(controller: 'inicio', action: 'bienvenida',
            params: [mostrarZip: true, albumId: album.id])
    }

    // Genera y descarga un fichero ZIP con la portada, fotos y descripciones del álbum
    def descargarZip() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Busca el álbum en BD por el id recibido como parámetro
        def album = Album.get(params.albumId)
        // Si no se encontró el álbum, informa del error y vuelve al panel
        if (!album) {
            flash.errorZip = "Álbum no encontrado."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Obtiene todos los recuerdos del álbum ordenados por fecha
        def recuerdos = Recuerdo.findAllByAlbum(album).sort { it.fecha }
        // Indica al navegador que la respuesta es un fichero ZIP para forzar la descarga
        response.contentType = 'application/zip'
        // Nombre del fichero ZIP usando el título del álbum con guiones bajos en lugar de espacios
        response.setHeader('Content-Disposition', "attachment; filename=\"album_${album.titulo.replaceAll(' ', '_')}.zip\"")

        // Crea el flujo de salida ZIP directamente sobre el stream de la respuesta HTTP
        def zipOut = new java.util.zip.ZipOutputStream(response.outputStream)

        // Si el álbum tiene portada, la añade al ZIP como primer fichero
        if (album.portada) {
            def entry = new java.util.zip.ZipEntry("portada.jpg")
            zipOut.putNextEntry(entry)
            zipOut.write(album.portada) // Escribe los bytes de la portada en el ZIP
            zipOut.closeEntry()
        }

        // Añade cada foto de recuerdo al ZIP con nombre numerado y etiqueta
        recuerdos.eachWithIndex { recuerdo, i ->
            // Genera el nombre del fichero con número de dos dígitos y la etiqueta del recuerdo
            def nombreArchivo = "${String.format('%02d', i+1)}_${recuerdo.etiqueta ?: 'recuerdo'}.jpg"
            def entry = new java.util.zip.ZipEntry(nombreArchivo)
            zipOut.putNextEntry(entry)
            zipOut.write(recuerdo.foto) // Escribe los bytes de la foto en el ZIP
            zipOut.closeEntry()
        }

        // Crea una entrada de texto en el ZIP con las descripciones de todos los recuerdos
        def textoEntry = new java.util.zip.ZipEntry("descripciones.txt")
        zipOut.putNextEntry(textoEntry)
        // Construye el contenido del fichero de texto con el título y los datos de cada recuerdo
        def sb = new StringBuilder()
        sb.append("ÁLBUM: ${album.titulo}\nPaciente: ${album.paciente.nombre}\n\n")
        recuerdos.eachWithIndex { recuerdo, i ->
            // Añade los datos de cada recuerdo: número, etiqueta y descripción
            sb.append("--- Foto ${i+1} ---\nEtiqueta: ${recuerdo.etiqueta}\nDescripción: ${recuerdo.texto ?: ''}\n\n")
        }
        zipOut.write(sb.toString().bytes) // Escribe el texto como bytes en el ZIP
        zipOut.closeEntry()

        // Finaliza y vacía el ZIP para asegurar que se envía completo al navegador
        zipOut.finish()
        zipOut.flush()
    }

    // Elimina completamente la cuenta de un paciente y todos sus datos asociados
    def eliminarCuentaPaciente() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Obtiene el DNI del formulario eliminando espacios en blanco
        def dni = params.dni?.trim()
        // Busca el paciente en BD por su DNI
        def paciente = Paciente.findByDni(dni)

        // Si no existe ningún paciente con ese DNI, informa del error y vuelve al panel
        if (!paciente) {
            flash.errorEliminar = "No se encontró ningún paciente con el DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Abre una transacción para garantizar que todos los datos se eliminan juntos
        Usuario.withTransaction {
            // Obtiene todos los vínculos usuario-paciente para encontrar el usuario con rol paciente
            def vinculos = UsuarioPaciente.findAllByPaciente(paciente)
            // Encuentra el usuario que tiene el rol ROLE_PACIENTE entre todos los vinculados
            def usuarioPaciente = vinculos.find { vp ->
                UsuarioRol.findByUsuario(vp.usuario)?.rol?.authority == 'ROLE_PACIENTE'
            }?.usuario

            // Si el paciente tiene álbum, elimina primero sus recuerdos y luego el álbum
            def album = Album.findByPaciente(paciente)
            if (album) {
                Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) } // Borra todos los recuerdos del álbum
                album.delete(flush: true) // Borra el álbum una vez vaciado
            }

            // Elimina todas las invitaciones asociadas al paciente
            Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }
            // Elimina todos los vínculos usuario-paciente
            vinculos.each { it.delete(flush: true) }

            // Si existe el usuario paciente, elimina también sus vínculos adicionales
            if (usuarioPaciente) {
                UsuarioPaciente.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) }
            }

            // Elimina el registro del paciente de la base de datos
            paciente.delete(flush: true)

            // Si existe el usuario paciente, elimina su rol y su cuenta de usuario
            if (usuarioPaciente) {
                UsuarioRol.findAllByUsuario(usuarioPaciente).each { it.delete(flush: true) } // Borra el rol del usuario
                usuarioPaciente.delete(flush: true) // Borra el usuario del paciente
            }
        }

        // Notifica al cuidador que la cuenta fue eliminada correctamente
        flash.message = "Cuenta del paciente eliminada correctamente."
        redirect(controller: 'inicio', action: 'bienvenida')
    }

    // Elimina la cuenta de un familiar y todos sus vínculos con pacientes
    def eliminarCuentaFamiliar() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Obtiene el DNI del formulario eliminando espacios en blanco
        def dni = params.dni?.trim()
        // Busca el usuario familiar en BD por su DNI
        def usuario = Usuario.findByDni(dni)

        // Si no existe ningún usuario con ese DNI, informa del error y vuelve al panel
        if (!usuario) {
            flash.errorEliminar = "No se encontró ningún usuario con DNI: ${dni}"
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Abre una transacción para garantizar que todos los datos se eliminan juntos
        Usuario.withTransaction {
            // Elimina todos los vínculos del familiar con pacientes
            UsuarioPaciente.findAllByUsuario(usuario).each { it.delete(flush: true) }
            // Elimina el rol asignado al familiar
            UsuarioRol.findAllByUsuario(usuario).each { it.delete(flush: true) }
            // Elimina la cuenta del usuario familiar
            usuario.delete(flush: true)
        }

        // Notifica al cuidador que la cuenta fue eliminada correctamente
        flash.message = "Cuenta del familiar eliminada correctamente."
        redirect(controller: 'inicio', action: 'bienvenida')
    }

    // Elimina la propia cuenta del cuidador junto con todos los pacientes y datos que gestiona
    def eliminarCuentaPropia() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Obtiene el usuario cuidador de la sesión actual
        def cuidador = session.usuario
        // Obtiene la contraseña introducida en el formulario de confirmación
        def password = params.password

        // Crea un encoder BCrypt para verificar la contraseña introducida
        def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
        // Si la contraseña no coincide con la almacenada, informa del error y detiene el proceso
        if (!encoder.matches(password, cuidador.password)) {
            flash.errorEliminar = "La contraseña introducida no es correcta."
            redirect(controller: 'inicio', action: 'bienvenida')
            return
        }

        // Abre una transacción para eliminar todos los datos del cuidador y sus pacientes
        Usuario.withTransaction {
            // Obtiene la lista de todos los pacientes vinculados al cuidador
            def pacientes = UsuarioPaciente.findAllByUsuario(cuidador).collect { it.paciente }
            // Para cada paciente vinculado, elimina todos sus datos en cascada
            pacientes.each { paciente ->
                // Si el paciente tiene álbum, elimina sus recuerdos y luego el álbum
                def album = Album.findByPaciente(paciente)
                if (album) {
                    Recuerdo.findAllByAlbum(album).each { it.delete(flush: true) } // Borra todos los recuerdos
                    album.delete(flush: true) // Borra el álbum
                }
                // Elimina todas las invitaciones del paciente
                Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }
                // Elimina todos los vínculos usuario-paciente del paciente
                UsuarioPaciente.findAllByPaciente(paciente).each { it.delete(flush: true) }
                // Elimina el registro del paciente
                paciente.delete(flush: true)
            }
            // Elimina el rol del cuidador
            UsuarioRol.findByUsuario(cuidador)?.delete(flush: true)
            // Elimina la cuenta del propio cuidador
            cuidador.delete(flush: true)
        }

        // Invalida la sesión actual para cerrar la sesión del cuidador eliminado
        session.invalidate()
        // Redirige al login ya que la cuenta ya no existe
        redirect(controller: 'login', action: 'index')
    }

    // Genera un código de invitación aleatorio y lo asocia a un paciente y un email de familiar
    def generarCodigo() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        // Abre una transacción para guardar la invitación de forma segura
        Invitacion.withTransaction {
            // Busca el paciente en BD por el DNI introducido en el formulario
            def paciente = Paciente.findByDni(params.dniPaciente)
            // Si no existe el paciente con ese DNI, informa del error y vuelve al panel
            if (!paciente) {
                flash.error = "No se encontró el paciente con ese DNI."
                redirect(controller: 'inicio', action: 'bienvenida')
                return
            }
            // Crea una lista mezclada de letras y números para generar el código
            def chars = ('A'..'Z') + ('0'..'9')
            Collections.shuffle(chars) // Mezcla aleatoriamente los caracteres disponibles
            // Genera el código con formato XXX-XXXX tomando 3 y 4 caracteres de la lista mezclada
            def codigo = (chars.take(3).join('') + '-' + chars.drop(3).take(4).join('')).toUpperCase()

            // Guarda la invitación con el código generado, el email del familiar y el paciente
            new Invitacion(codigo: codigo, emailFamiliar: params.emailFamiliar, paciente: paciente).save(flush: true)
            // Almacena el código y los datos del familiar en flash para mostrarlos en el panel
            flash.codigoGenerado = codigo
            flash.emailFamiliar = params.emailFamiliar
            flash.nombreFamiliar = params.nombreFamiliar
            redirect(controller: 'inicio', action: 'bienvenida')
        }
    }

    // Envía por correo electrónico el código de invitación al familiar usando el CorreoService
    def enviarCodigo() {
        // Verifica que quien llama tiene rol de cuidador antes de continuar
        if (!verificarCuidador()) return

        try {
            // Llama al servicio de correo para enviar el código al email del familiar
            correoService.enviarCodigoInvitacion(params.email, params.nombre, params.codigo)
            // Notifica al cuidador que el correo se envió correctamente
            flash.message = "Código enviado correctamente."
        } catch (Exception e) {
            // Si el envío falla por cualquier motivo, informa del error al cuidador
            flash.error = "Error al enviar el correo."
        }
        redirect(controller: 'inicio', action: 'bienvenida')
    }
}