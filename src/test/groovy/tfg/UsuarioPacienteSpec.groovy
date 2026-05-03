package tfg

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class UsuarioPacienteSpec extends Specification implements DomainUnitTest<UsuarioPaciente> {

    def "usuarioPaciente se puede instanciar"() {
        when:
        def up = new UsuarioPaciente()

        then:
        up != null
    }
}