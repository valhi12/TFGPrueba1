package tfg

import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper

class CorreoService {

    JavaMailSender mailSender

    void enviarCodigoInvitacion(String emailDestino, String nombreFamiliar, String codigo) {
        def mensaje = mailSender.createMimeMessage()
        def helper = new MimeMessageHelper(mensaje, true, "UTF-8")

        helper.setTo(emailDestino)
        helper.setSubject("Tu código de invitación - Mi Álbum de Recuerdos")

        String cuerpo = construirCuerpoCorreo(nombreFamiliar, codigo)
        helper.setText(cuerpo, true)
        mailSender.send(mensaje)
    }

    private String construirCuerpoCorreo(String nombreFamiliar, String codigo) {
        return """
            <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto;">
                <h2 style="color: #0d6efd;">Mi Álbum de Recuerdos</h2>
                <p>Hola <strong>${nombreFamiliar}</strong>,</p>
                <p>Tu cuidador te ha invitado a unirte al Álbum de Recuerdos familiar.</p>
                <p>Tu código de invitación es:</p>
                <div style="background:#f0f7ff; border:2px solid #0d6efd; border-radius:8px;
                            padding:20px; text-align:center; font-size:2em;
                            letter-spacing:5px; font-weight:bold; color:#0d6efd;">
                    ${codigo}
                </div>
                <p style="margin-top:20px;">
                    Usa este código al registrarte en la aplicación.
                    <strong>Solo puede usarse una vez.</strong>
                </p>
            </div>
        """
    }
}