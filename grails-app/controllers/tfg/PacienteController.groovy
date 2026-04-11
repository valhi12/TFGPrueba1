package tfg

class PacienteController {

    def bienvenida() {
        def usuario = session.usuario
        if (!usuario) {
            redirect(controller: 'login', action: 'index')
            return
        }

        def vinculo = UsuarioPaciente.findByUsuario(usuario)
        def paciente = vinculo?.paciente
        def album = paciente ? Album.findByPaciente(paciente) : null

        def etiquetas = []
        def recuerdos = []

        if (album) {
            recuerdos = Recuerdo.findAllByAlbum(album).sort { it.fecha }
            etiquetas = recuerdos.collect { it.etiqueta }.findAll { it }.unique().sort()
        }

        def etiquetaSeleccionada = params.etiqueta ?: null
        def recuerdosFiltrados = etiquetaSeleccionada ?
            recuerdos.findAll { it.etiqueta == etiquetaSeleccionada } :
            recuerdos

        [
            usuario: usuario,
            album: album,
            recuerdos: recuerdosFiltrados,
            etiquetas: etiquetas,
            etiquetaSeleccionada: etiquetaSeleccionada
        ]
    }

    def foto() {
        def recuerdo = Recuerdo.get(params.id)
        if (recuerdo?.foto) {
            response.contentType = 'image/jpeg'
            response.outputStream << recuerdo.foto
            response.outputStream.flush()
        }
    }

    def portada() {
        def album = Album.get(params.id)
        if (album?.portada) {
            response.contentType = 'image/jpeg'
            response.outputStream << album.portada
            response.outputStream.flush()
        }
    }
}