<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Login - TFG</title>
</head>
<body>
    <div class="card-registro">
        <h2 style="text-align: center;">Bienvenida al TFG</h2>
        <p style="text-align: center; color: #666;">Por favor, introduce tus datos</p>

        <g:if test="${flash.error}">
            <div style="background: #ffe6e6; color: #cc0000; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                ${flash.error}
            </div>
        </g:if>

        <g:form action="autenticar" method="POST">
            <label>Email:</label>
            <input type="email" name="email" required="" class="form-control" placeholder="ejemplo@correo.com" />
            
            <label>Contraseña:</label>
            <input type="password" name="password" required="" class="form-control" placeholder="******" />
            
            <button type="submit" class="btn btn-primary btn-block" style="margin-top: 10px;">Continuar</button>
        </g:form>

        <hr style="margin: 20px 0;">

        <div style="text-align: center;">
            <p>¿Eres nuevo? <g:link action="registro">Crea una cuenta aquí</g:link></p>
        </div>
    </div>
</body>
</html>