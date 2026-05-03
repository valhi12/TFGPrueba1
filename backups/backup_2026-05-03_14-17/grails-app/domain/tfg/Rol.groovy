package tfg

class Rol {
    String authority // Aquí irá ROLE_CUIDADOR, ROLE_FAMILIAR, etc.

    static constraints = {
        authority blank: false, unique: true
    }
}