package tfg

class Album {
    String titulo
    Date fechaCreacion = new Date()
    byte[] portada

    static belongsTo = [paciente: Paciente]
    static hasMany = [recuerdos: Recuerdo]

    static constraints = {
        titulo blank: false
        portada nullable: true
    }

    static mapping = {
        portada sqlType: 'mediumblob'
    }
}