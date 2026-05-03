package tfg
class UsuarioPaciente implements Serializable {
    Usuario usuario
    Paciente paciente
    static mapping = { id composite: ['usuario', 'paciente'] }
}