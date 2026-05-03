package tfg

class Paciente {
    String nombre
    String dni
    Date fechaNacimiento
    String codigoUnico

    static constraints = {
        nombre blank: false
        dni blank: false, unique: true
        fechaNacimiento nullable: true
        codigoUnico nullable: true, unique: true
    }

    static mapping = {
        codigoUnico column: 'codigo_unico'
    }
}