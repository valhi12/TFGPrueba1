package tfg

class Usuario {
    String username
    String password
    String nombreCompleto
    String avatar = '👤'
    boolean enabled = true

    static constraints = {
        username email: true, unique: true, blank: false
        password blank: false, minSize: 6
        nombreCompleto blank: false
        avatar nullable: true
    }

    static mapping = {
        password column: '`password`'
    }
}