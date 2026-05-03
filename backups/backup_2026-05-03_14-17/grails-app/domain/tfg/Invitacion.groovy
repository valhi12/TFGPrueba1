package tfg

class Invitacion {
    String codigo
    String emailFamiliar
    boolean usada = false
    Date fechaCreacion = new Date()

    static belongsTo = [paciente: Paciente]

    static constraints = {
        codigo blank: false, unique: true
        emailFamiliar blank: false, email: true
        paciente nullable: false
    }
}