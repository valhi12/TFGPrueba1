package tfg

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class UsuarioRolSpec extends Specification implements DomainUnitTest<UsuarioRol> {

    def "usuarioRol se puede instanciar"() {
        when:
        def ur = new UsuarioRol()

        then:
        ur != null
    }
}