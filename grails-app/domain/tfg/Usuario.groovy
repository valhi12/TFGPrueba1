package tfg

class Usuario {
    String username // Será el email para el login
    String password
    String nombreCompleto
    boolean enabled = true

    static constraints = {
        username email: true, unique: true, blank: false
        password blank: false, minSize: 6
        nombreCompleto blank: false
    }

    static mapping = {
        password column: '`password`' 
    }
}