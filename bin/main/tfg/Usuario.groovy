package tfg

//Clase de dominio que representa a un usuario registrado en el sistema (cuidador, familiar o paciente)

class Usuario {
    //Email del usuario que actúa como nombre de usuario único para el login
    String username
    String password
    String nombreCompleto
    
    //Campo temporal para el código (No se crea columna en la DB)
    String codigoFamiliar 

    //Declara codigoFamiliar como transitorio para que GORM no lo mapee a ninguna columna de la base de datos
    static transients = ['codigoFamiliar']

    //Restricciones de validación que GORM aplica antes de guardar en base de datos
    static constraints = {
        //El username debe tener formato de email, ser único en la BD y no puede estar vacío
        username email: true, unique: true, blank: false
        //La contraseña debe tener entre 5 y 100 caracteres y no puede estar vacía
        password size: 5..100, blank: false
        //El nombre completo no puede estar vacío
        nombreCompleto blank: false
        
        //Esta es la clave: el validador "pro"
        codigoFamiliar nullable: true, validator: { val, obj ->
            //Si el código llega aquí, podemos hacer comprobaciones extra luego
            return true 
        }
    }
}