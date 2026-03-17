package tfg

class BootStrap {

    def init = { servletContext ->
        // Envolvemos todo en una transacción para que Hibernate no se queje
        Usuario.withTransaction { status ->
            
            // 1. Crear los 3 Roles si no existen
            def cuidadorRol = Rol.findByAuthority('ROLE_CUIDADOR') ?: new Rol(authority: 'ROLE_CUIDADOR').save(flush: true)
            def familiarRol = Rol.findByAuthority('ROLE_FAMILIAR') ?: new Rol(authority: 'ROLE_FAMILIAR').save(flush: true)
            def pacienteRol = Rol.findByAuthority('ROLE_PACIENTE') ?: new Rol(authority: 'ROLE_PACIENTE').save(flush: true)

            // 2. Crear el Usuario de prueba
            if (Usuario.count() == 0) {
                def valeria = new Usuario(
                    username: 'valeria@tfg.com',
                    password: 'password123',
                    nombreCompleto: 'Valeria Administradora'
                ).save(flush: true, failOnError: true)

                // 3. Asignar el rol
                new UsuarioRol(usuario: valeria, rol: cuidadorRol).save(flush: true)

                println "--------------------------------------------"
                println "¡Base de datos lista con roles y usuario!"
                println "Login: valeria@tfg.com / Clave: password123"
                println "--------------------------------------------"
            }
        }
    }

    def destroy = {
    }
}