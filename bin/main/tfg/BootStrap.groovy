package tfg

class BootStrap {

    def init = { servletContext ->
        // Envolvemos todo en una transacción
        Usuario.withTransaction { status ->
            
            //Crear los 3 Roles si no existen
            def cuidadorRol = Rol.findByAuthority('ROLE_CUIDADOR') ?: new Rol(authority: 'ROLE_CUIDADOR').save(flush: true)
            def familiarRol = Rol.findByAuthority('ROLE_FAMILIAR') ?: new Rol(authority: 'ROLE_FAMILIAR').save(flush: true)
            def pacienteRol = Rol.findByAuthority('ROLE_PACIENTE') ?: new Rol(authority: 'ROLE_PACIENTE').save(flush: true)

            //Crear el Usuario de prueba
            if (Usuario.count() == 0) {
                def valeria = new Usuario(
                    username: 'valeria@tfg.com',
                    password: 'password123',
                    nombreCompleto: 'Valeria Administradora'
                ).save(flush: true, failOnError: true)

                //Asignar el rol
                new UsuarioRol(usuario: valeria, rol: cuidadorRol).save(flush: true)

                println "¡Base de datos lista con roles y usuario!"
                println "Login: valeria@tfg.com / Clave: password123"
            }
        }
    }

    def destroy = {
    }
}