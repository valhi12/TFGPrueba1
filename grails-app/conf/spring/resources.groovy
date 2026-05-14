import org.springframework.mail.javamail.JavaMailSenderImpl
import java.util.Properties

beans = {
    mailSender(JavaMailSenderImpl) {
        host = 'smtp-relay.brevo.com'        //Servidor Brevo
        port = 587
        username = 'TU_EMAIL_DE_BREVO'       //El email con el que te registraste en Brevo
        password = 'TU_CLAVE_SMTP_BREVO'     //La clave larga generada en el Paso 1
        javaMailProperties = {
            Properties props = new Properties()
            props.put('mail.smtp.auth', 'true')
            props.put('mail.smtp.starttls.enable', 'true')
            props.put('mail.smtp.starttls.required', 'true')
            return props
        }()
    }
}