package tfg

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class PacienteSpec extends Specification implements DomainUnitTest<Paciente> {

    def "paciente sin nombre no es válido"() {
        when:
        def paciente = new Paciente(dni: '12345678A')

        then:
        !paciente.validate()
        paciente.errors['nombre']
    }

    def "paciente con nombre y dni es válido"() {
        when:
        def paciente = new Paciente(nombre: 'Juan García', dni: '12345678A')

        then:
        paciente.validate()
    }
}