package tfg

//Clase de dominio que representa un rol de usuario dentro del sistema

class Rol {
    //Nombre del rol que define los permisos del usuario (ROLE_CUIDADOR, ROLE_FAMILIAR, ROLE_PACIENTE)
    String authority //Aquí irá ROLE_CUIDADOR, ROLE_FAMILIAR, etc.

    //Restricciones de validación que GORM aplica antes de guardar en base de datos
    static constraints = {
        //El nombre del rol no puede estar vacío y debe ser único en la base de datos
        authority blank: false, unique: true
    }
}