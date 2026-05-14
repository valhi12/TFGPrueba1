package tfg
//Clase principal de arranque de la aplicación Grails. punto de entrada del servidor

import grails.boot.GrailsApp 
import grails.boot.config.GrailsAutoConfiguration
import groovy.transform.CompileStatic

@CompileStatic
class Application extends GrailsAutoConfiguration {
    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}