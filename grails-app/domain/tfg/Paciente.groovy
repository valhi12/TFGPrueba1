package tfg
class Paciente {
    String nombre
    String codigoUnico // El código que usará la familia
    String datosMedicos

    static constraints = {
        nombre blank: false
        codigoUnico unique: true
        datosMedicos nullable: true, maxSize: 1000
    }
}