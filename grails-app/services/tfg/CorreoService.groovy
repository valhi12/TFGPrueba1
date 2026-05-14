package tfg

import groovy.json.JsonOutput
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.HttpClients
import org.apache.http.util.EntityUtils

class CorreoService {

    // Desactiva las transacciones en este servicio ya que no interactúa con la base de datos
    static transactional = false

    // Inyección del config de Grails para leer la API key desde application.yml o variable de entorno
    def grailsApplication

    // Envía el código de invitación al email del familiar usando la API REST de Brevo
    void enviarCodigoInvitacion(String emailDestino, String nombreFamiliar, String codigo) {

        // Lee la API key: primero variable de entorno (Railway), luego application.yml (local)
        String apiKey = System.getenv('BREVO_API_KEY') ?: grailsApplication.config.brevo.apiKey as String

        // Construir el cuerpo JSON de la petición a Brevo
        def body = [
            sender : [name: 'Mi Álbum de Recuerdos', email: 'valhi09@gmail.com'], // Remitente que aparecerá en el correo
            to : [[email: emailDestino, name: nombreFamiliar]],  // Destinatario del correo
            subject : 'Código de invitación — Mi Álbum de Recuerdos', // Asunto del correo
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
        // Crea un cliente HTTP estándar para ejecutar la petición
        def client = HttpClients.createDefault()
        // Construye la petición POST al endpoint de envío de emails de Brevo
        def post = new HttpPost('https://api.brevo.com/v3/smtp/email')

        try {
            // Cabecera que indica que se acepta respuesta en formato JSON
            post.setHeader('accept', 'application/json')
            // Cabecera con la API key de Brevo para autenticar la petición
            post.setHeader('api-key', apiKey)
            // Cabecera que indica que el cuerpo de la petición es JSON
            post.setHeader('content-type', 'application/json')
            // Serializa el cuerpo a JSON y lo adjunta a la petición con codificación UTF-8
            post.setEntity(new StringEntity(JsonOutput.toJson(body), 'UTF-8'))

            // Ejecuta la petición HTTP y obtiene la respuesta de Brevo
            def response = client.execute(post)
            // Extrae el código de estado HTTP de la respuesta (201 = éxito, 4xx = error)
            def statusCode = response.getStatusLine().getStatusCode()
            // Extrae el cuerpo de la respuesta como texto para mostrarlo en los logs si hay error
            def responseBody = EntityUtils.toString(response.getEntity())

            // 201 Created = correo enviado correctamente por Brevo
            // Si el código de estado es 400 o superior, la petición falló
            if (statusCode >= 400) {
                log.error("Error al enviar correo a ${emailDestino}: [${statusCode}] ${responseBody}")
                // Lanza una excepción para que el controlador pueda capturarla y mostrar el error
                throw new RuntimeException("Error al enviar correo: ${statusCode}")
            }

            // Registra en el log que el correo se envió correctamente con el email y el código
            log.info("Correo de invitación enviado a ${emailDestino} — Código: ${codigo}")

        } catch (IOException e) {
            // Captura errores de red o de conexión con la API de Brevo y los registra en el log
            log.error("Excepción al llamar a la API de Brevo: ${e.message}", e)
            // Relanza la excepción para que el controlador pueda informar del error al usuario
            throw e
        } finally {
            // Cierra el cliente HTTP siempre, tanto si hubo éxito como si hubo error
            client.close()
        }
    }
}