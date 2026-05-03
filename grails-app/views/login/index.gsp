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
                <div id="wrapperPassword" style="position:relative; width:100%; display:block; margin-bottom:20px;">
                    <input type="password" name="password" id="inputPassword" placeholder="••••••••" required
                           style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; color:#4a4a4a; background:#e8f2e6; outline:none; box-sizing:border-box; margin-bottom:0;"/>
                    <button type="button" id="btnOjoPassword"
                            style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                        <svg id="svgOjoPassword" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                            <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                        </svg>
                    </button>
                </div>

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

    <script type="text/javascript">
        var SVG_ABIERTO = '<path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>';
        var SVG_CERRADO = '<path d="M53.92,34.62A8,8,0,1,0,42.08,45.38L61.32,66.55C25,88.84,9.38,123.2,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208a127.11,127.11,0,0,0,52.07-10.83l22,24.21a8,8,0,1,0,11.84-10.76Zm47.33,75.84,41.67,45.85a32,32,0,0,1-41.67-45.85ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.16,133.16,0,0,1,25,128c4.69-8.79,19.66-33.39,47.35-49.38l18,19.75a48,48,0,0,0,63.66,70l14.73,16.2A112,112,0,0,1,128,192Zm6-95.43a8,8,0,0,1,3-15.72,48.16,48.16,0,0,1,38.77,42.64,8,8,0,0,1-7.22,8.71,6.39,6.39,0,0,1-.75,0,8,8,0,0,1-8-7.26A32.09,32.09,0,0,0,134,96.57Zm113.28,34.69c-.42.94-10.55,23.37-33.36,43.8a8,8,0,1,1-10.67-11.92A132.77,132.77,0,0,0,231.05,128a133.15,133.15,0,0,0-23.12-30.77C185.67,75.19,158.78,64,128,64a118.37,118.37,0,0,0-19.36,1.57A8,8,0,1,1,106,49.79,134,134,0,0,1,128,48c34.88,0,66.57,13.26,91.66,38.35,18.83,18.83,27.3,37.62,27.65,38.41A8,8,0,0,1,247.31,131.26Z"/>';

        document.getElementById('btnOjoPassword').addEventListener('click', function() {
            var input = document.getElementById('inputPassword');
            var svg = document.getElementById('svgOjoPassword');
            if (input.type === 'password') {
                input.type = 'text';
                svg.innerHTML = SVG_CERRADO;
            } else {
                input.type = 'password';
                svg.innerHTML = SVG_ABIERTO;
            }
        });
    </script>

</body>
</html>