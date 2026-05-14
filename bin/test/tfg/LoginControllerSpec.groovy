package tfg

//Clase de tests unitarios para el LoginController usando el framework Spock

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

//Especificación de tests del LoginController. combina Spock con el entorno de controladores de Grails
class LoginControllerSpec extends Specification implements ControllerUnitTest<LoginController> {

    //Método que se ejecuta antes de cada test para preparar el entorno
    def setup() {
    }

    //Método que se ejecuta después de cada test para limpiar el entorno
    def cleanup() {
    }

    //Test de ejemplo generado automáticamente por Grails
    void "test something"() {
        //Bloque expect: define la condición que debe cumplirse para que el test pase
        expect:"fix me"
            true == false
    }
}
