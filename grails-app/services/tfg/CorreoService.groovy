package tfg

import groovy.json.JsonOutput
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.HttpClients
import org.apache.http.util.EntityUtils

class CorreoService {

    static transactional = false

    // Inyección del config de Grails para leer la API key desde application.yml o variable de entorno
    def grailsApplication

    void enviarCodigoInvitacion(String emailDestino, String nombreFamiliar, String codigo) {

        // Lee la API key: primero variable de entorno (Railway), luego application.yml (local)
        String apiKey = System.getenv('BREVO_API_KEY') ?:
                grailsApplication.config.brevo.apiKey as String

        // Construir el cuerpo JSON de la petición a Brevo
        def body = [
            sender     : [name: 'Mi Álbum de Recuerdos', email: 'valhi09@gmail.com'],
            to         : [[email: emailDestino, name: nombreFamiliar]],
            subject    : 'Código de invitación — Mi Álbum de Recuerdos',
            textContent: """\
Hola ${nombreFamiliar},

Has sido invitado/a a unirte a Mi Álbum de Recuerdos.

Tu código de invitación es: ${codigo}

Úsalo al registrarte en la aplicación para vincularte al paciente.

Un saludo,
El equipo de Mi Álbum de Recuerdos
"""
        ]

        // Llamada HTTP a la API de Brevo (no usa SMTP, compatible con Railway)
        def client = HttpClients.createDefault()
        def post = new HttpPost('https://api.brevo.com/v3/smtp/email')

        try {
            post.setHeader('accept', 'application/json')
            post.setHeader('api-key', apiKey)
            post.setHeader('content-type', 'application/json')
            post.setEntity(new StringEntity(JsonOutput.toJson(body), 'UTF-8'))

            def response = client.execute(post)
            def statusCode = response.getStatusLine().getStatusCode()
            def responseBody = EntityUtils.toString(response.getEntity())

            // 201 Created = correo enviado correctamente por Brevo
            if (statusCode >= 400) {
                log.error("Error al enviar correo a ${emailDestino}: [${statusCode}] ${responseBody}")
                throw new RuntimeException("Error al enviar correo: ${statusCode}")
            }

            log.info("Correo de invitación enviado a ${emailDestino} — Código: ${codigo}")

        } catch (IOException e) {
            log.error("Excepción al llamar a la API de Brevo: ${e.message}", e)
            throw e
        } finally {
            client.close()
        }
    }
}