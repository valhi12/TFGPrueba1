package tfg

class Usuario {
    String username
    String password
    String nombreCompleto
    
    // Campo temporal para el código (No se crea columna en la DB)
    String codigoFamiliar 

    static transients = ['codigoFamiliar']

    static constraints = {
        username email: true, unique: true, blank: false
        password size: 5..100, blank: false
        nombreCompleto blank: false
        
        // Esta es la clave: el validador "pro"
        codigoFamiliar nullable: true, validator: { val, obj ->
            // Si el código llega aquí, podemos hacer comprobaciones extra luego
            return true 
        }
    }
}