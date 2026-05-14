package tfg

//Clase de dominio que representa la relación entre un usuario y su rol en el sistema

import groovy.transform.ToString

//Genera un toString() cacheado que muestra los nombres de los campos pero no el paquete
@ToString(cache=true, includeNames=true, includePackage=false)
//Implementa Serializable para que la clave compuesta pueda ser gestionada correctamente por GORM
class UsuarioRol implements Serializable {
    //Usuario al que se le asigna el rol
    Usuario usuario
    //Rol que se le asigna al usuario
    Rol rol

    //Restricciones de validación que GORM aplica antes de guardar en base de datos
    static constraints = {
        //Este validador evita que asignes el mismo rol al mismo usuario dos veces
        rol validator: { Rol r, UsuarioRol ur ->
            //Comprueba que tanto el usuario como el rol ya existen en la base de datos antes de validar
            if (ur.usuario?.id && r?.id) {
                //Si ya existe una entrada con ese mismo usuario y rol, devuelve un error
                if (UsuarioRol.countByUsuarioAndRol(ur.usuario, r)) {
                    //Devuelve el código de error localizado que indica que la combinación ya existe
                    return ['userRole.exists']
                }
            }
        }
    }

    static mapping = {
        id composite: ['usuario', 'rol']
        version false
    }
}