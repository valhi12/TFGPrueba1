// Controlador que gestiona el visor de recuerdos del paciente con filtro por etiquetas
package tfg

class PacienteController {

    // Carga la pantalla principal del paciente con su álbum, recuerdos y filtro de etiquetas
    def bienvenida() {
        // Obtiene el usuario actual de la sesión
        def usuario = session.usuario
        // Si no hay sesión activa, redirige al login
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        // Busca el rol asignado al usuario en la tabla UsuarioRol
        def usuarioRol = UsuarioRol.findByUsuario(usuario)
        // Obtiene el nombre del rol del usuario actual
        def rol = usuarioRol?.rol?.authority
        // Determina si quien accede es un familiar para mostrar el botón Volver a su panel
        def esFamiliar = (rol == 'ROLE_FAMILIAR')

        // Busca el vínculo entre el usuario y su paciente asignado
        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        // Obtiene el paciente a partir del vínculo encontrado
        def paciente = vinculo?.paciente
        // Busca el álbum del paciente si existe, o null si no tiene paciente vinculado
        def album = paciente ? Album.findByPaciente(paciente) : null

        // Inicializa las listas vacías por si el paciente no tiene álbum todavía
        def etiquetas = []
        def recuerdos = []

        // Si el paciente tiene álbum, carga sus recuerdos y extrae las etiquetas disponibles
        if (album) {
            // Obtiene todos los recuerdos del álbum ordenados cronológicamente por fecha
            recuerdos = Recuerdo.findAllByAlbum(album).sort { it.fecha }
            // Extrae las etiquetas únicas y ordenadas alfabéticamente para el menú lateral
            etiquetas = recuerdos.collect { it.etiqueta }.findAll { it }.unique().sort()
        }

        // Obtiene la etiqueta seleccionada del parámetro de la URL o null si no hay filtro
        def etiquetaSeleccionada = params.etiqueta ?: null
        // Filtra los recuerdos por la etiqueta seleccionada o muestra todos si no hay filtro
        def recuerdosFiltrados = etiquetaSeleccionada ?
            recuerdos.findAll { it.etiqueta == etiquetaSeleccionada } :
            recuerdos

        // Pasa todos los datos necesarios a la vista del paciente
        [
            usuario: usuario,                           // Usuario en sesión
            album: album,                               // Álbum del paciente
            recuerdos: recuerdosFiltrados,              // Recuerdos filtrados por etiqueta o todos
            etiquetas: etiquetas,                       // Lista de etiquetas para el menú lateral
            etiquetaSeleccionada: etiquetaSeleccionada, // Etiqueta activa para marcarla en el menú
            esFamiliar: esFamiliar                      // Flag para mostrar el botón Volver si es familiar
        ]
    }

    // Sirve la imagen de un recuerdo directamente desde la base de datos
    def foto() {
        // Busca el recuerdo en BD por el id recibido como parámetro
        def recuerdo = Recuerdo.get(params.id)
        // Si el recuerdo existe y tiene foto, la escribe en la respuesta HTTP como imagen JPEG
        if (recuerdo?.foto) {
            response.contentType = 'image/jpeg'             // Indica al navegador que es una imagen JPEG
            response.outputStream << recuerdo.foto          // Escribe los bytes de la foto en el stream de respuesta
            response.outputStream.flush()                   // Vacía el buffer para asegurar el envío completo
        }
    }

    // Sirve la imagen de portada del álbum directamente desde la base de datos
    def portada() {
        // Busca el álbum en BD por el id recibido como parámetro
        def album = Album.get(params.id)
        // Si el álbum existe y tiene portada, la escribe en la respuesta HTTP como imagen JPEG
        if (album?.portada) {
            response.contentType = 'image/jpeg'             // Indica al navegador que es una imagen JPEG
            response.outputStream << album.portada          // Escribe los bytes de la portada en el stream de respuesta
            response.outputStream.flush()                   // Vacía el buffer para asegurar el envío completo
        }
    }
}