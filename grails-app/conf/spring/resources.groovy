import org.springframework.mail.javamail.JavaMailSenderImpl
import java.util.Properties

beans = {
    mailSender(JavaMailSenderImpl) {
        host = 'smtp.gmail.com'
        port = 587
        username = 'valhi09@gmail.com'
        password = 'dzdgjqpnhxwtimau'
        javaMailProperties = {
            Properties props = new Properties()
            props.put('mail.smtp.auth', 'true')
            props.put('mail.smtp.starttls.enable', 'true')
            props.put('mail.smtp.starttls.required', 'true')
            return props
        }()
    }
}