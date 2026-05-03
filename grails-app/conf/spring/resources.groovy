import org.springframework.mail.javamail.JavaMailSenderImpl
import java.util.Properties

beans = {

    // mailSender desactivado — Railway bloquea puertos SMTP (587/465/25)
    // Ahora se usa Brevo HTTP API desde CorreoService.groovy
    // Descomenta si ejecutas en un entorno que permita SMTP:
    /*
    mailSender(JavaMailSenderImpl) {
        host = 'smtp.gmail.com'
        port = 587
        username = 'valhi09@gmail.com'
        password = 'CLAVE_DE_APP_16_CHARS'
        javaMailProperties = {
            Properties props = new Properties()
            props.put('mail.smtp.auth', 'true')
            props.put('mail.smtp.starttls.enable', 'true')
            props.put('mail.smtp.starttls.required', 'true')
            return props
        }()
    }
    */
}