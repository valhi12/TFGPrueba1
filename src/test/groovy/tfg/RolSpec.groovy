package tfg

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class RolSpec extends Specification implements DomainUnitTest<Rol> {

    def "rol sin authority no es válido"() {
        when:
        def rol = new Rol()

        then:
        !rol.validate()
        rol.errors['authority']
    }

    def "rol con authority es válido"() {
        when:
        def rol = new Rol(authority: 'ROLE_CUIDADOR')

        then:
        rol.validate()
    }
}