package tfg

//Clase de dominio que representa la relación muchos a muchos entre usuarios y pacientes

class UsuarioPaciente implements Serializable {
    //Usuario vinculado al paciente (cuidador o familiar)
    Usuario usuario
    //Paciente al que está vinculado el usuario
    Paciente paciente
    //Define la clave primaria compuesta por los dos campos en lugar de un id autogenerado
    static mapping = { id composite: ['usuario', 'paciente'] }
}