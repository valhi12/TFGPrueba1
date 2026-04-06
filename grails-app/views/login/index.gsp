<!DOCTYPE html>
<html lang="es">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Mi Álbum de Recuerdos</title>
    <asset:stylesheet src="login.css"/>
</head>
<body>

    <nav class="navbar-login">
        <span class="marca">Mi Álbum de Recuerdos</span>
    </nav>

    <div class="login-wrapper">
        <div class="login-card">

           
            <h2>Bienvenido</h2>
            <p class="subtitulo">Introduzca sus datos para continuar</p>

            <g:if test="${flash.error}">
                <div class="alerta-error">${flash.error}</div>
            </g:if>

            <g:form action="autenticar" method="POST">
                <label>Email</label>
                <input type="email" name="email" placeholder="ejemplo@gmail.com" required/>

                <label>Contraseña</label>
                <input type="password" name="password" placeholder="••••••••" required/>

                <button type="submit" class="btn-verde">Continuar</button>
            </g:form>

            <div class="divisor">o</div>

            <p class="texto-registro">
                ¿Es nuevo aquí? <g:link action="registro">Crea una cuenta</g:link>
            </p>

        </div>
    </div>

    <footer class="footer-login">
        © 2026 · Mi Álbum de Recuerdos Familiares
    </footer>

</body>
</html>