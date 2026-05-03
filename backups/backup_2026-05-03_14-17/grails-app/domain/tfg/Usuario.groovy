package tfg

class Usuario {
    String username
    String dni
    String password
    String nombreCompleto
    String avatar = '👤'
    boolean enabled = true

    static constraints = {
        username email: true, unique: true, blank: false
        password blank: false, minSize: 6
        nombreCompleto blank: false
        avatar nullable: true
        dni nullable: true
    }

    static mapping = {
        password column: '`password`'
    }
}