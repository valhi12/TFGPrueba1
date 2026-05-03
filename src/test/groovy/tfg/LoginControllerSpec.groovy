package tfg

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class LoginControllerSpec extends Specification implements ControllerUnitTest<LoginController> {

    def "guardarRegistro sin codigo siendo familiar muestra error"() {
        when:
        params.tipoRegistro = 'FAMILIAR'
        params.codigo = ''
        controller.guardarRegistro()

        then:
        flash.message == 'El código es obligatorio para familiares.'
        response.redirectedUrl.contains('registro')
    }

    def "index devuelve status 200"() {
        when:
        controller.index()

        then:
        response.status == 200
    }

    def "registro devuelve status 200"() {
        when:
        controller.registro()

        then:
        response.status == 200
    }
}