package tfg

import groovy.transform.ToString

@ToString(cache=true, includeNames=true, includePackage=false)
class UsuarioRol implements Serializable {
    Usuario usuario
    Rol rol

    static constraints = {
        // Este validador evita que asignes el mismo rol al mismo usuario dos veces
        rol validator: { Rol r, UsuarioRol ur ->
            if (ur.usuario?.id && r?.id) {
                if (UsuarioRol.countByUsuarioAndRol(ur.usuario, r)) {
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