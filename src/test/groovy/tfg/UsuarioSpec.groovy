package tfg

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class UsuarioSpec extends Specification implements DomainUnitTest<Usuario> {

    def "usuario sin username no es válido"() {
        when:
        def usuario = new Usuario(password: 'hash', nombreCompleto: 'Test')

        then:
        !usuario.validate()
        usuario.errors['username']
    }

    def "usuario con todos los campos es válido"() {
        when:
        def usuario = new Usuario(
            username: 'test@gmail.com',
            password: 'hasheado',
            nombreCompleto: 'Test Usuario'
        )

        then:
        usuario.validate()
    }

    def "la contraseña se cifra correctamente con BCrypt"() {
        given:
        def encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
        def passwordPlano = '123456'

        when:
        def hash = encoder.encode(passwordPlano)

        then:
        hash != passwordPlano
        hash.startsWith('$2a$')
        encoder.matches(passwordPlano, hash)
    }
}