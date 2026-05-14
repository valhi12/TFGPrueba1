package tfg

//Clase de dominio que representa a un paciente con Alzheimer en el sistema
class Paciente {
    String nombre
    String codigoUnico //El código que usará la familia
    String datosMedicos

    //Restricciones de validación que GORM aplica antes de guardar en base de datos
    static constraints = {
        //El nombre no puede estar vacío
        nombre blank: false
        //El código único no puede repetirse entre distintos pacientes
        codigoUnico unique: true
        //Los datos médicos son opcionales y tienen un límite de 1000 caracteres
        datosMedicos nullable: true, maxSize: 1000
    }
}