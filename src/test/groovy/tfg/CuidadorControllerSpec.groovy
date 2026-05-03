package tfg

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class UsuarioControllerSpec extends Specification implements ControllerUnitTest<CuidadorController> {

    def "crearPaciente sin sesión redirige al login"() {
        given:
        session.usuario = null

        when:
        controller.crearPaciente()

        then:
        response.redirectedUrl.contains('login')
    }

    def "buscarAlbum sin sesión redirige al login"() {
        given:
        session.usuario = null

        when:
        controller.buscarAlbum()

        then:
        response.redirectedUrl.contains('login')
    }
}