<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><g:layoutTitle default="Mi Álbum de Recuerdos"/></title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="login.css"/>
    <asset:stylesheet src="cuidador.css"/>
</head>
<body>

    <nav class="navbar-app">
        <span class="marca">Mi Álbum de Recuerdos</span>
        <g:if test="${session.usuario}">
            <div class="avatar-wrapper">
                <button class="avatar-btn" onclick="toggleDropdown()">
                    ${session.usuario?.avatar ?: '👤'}
                </button>
                <div class="avatar-dropdown" id="avatarDropdown">
                    <div class="nombre-usuario">${session.usuario?.nombreCompleto}</div>
                    <g:link controller="inicio" action="logout">Cerrar sesión</g:link>
                </div>
            </div>
        </g:if>
    </nav>

    <g:layoutBody/>

    <footer class="footer-app">
        © 2026 · Mi Álbum de Recuerdos Familiares
    </footer>

    <asset:javascript src="application.js"/>
    <script>
        function toggleDropdown() {
            document.getElementById('avatarDropdown').classList.toggle('abierto');
        }
        document.addEventListener('click', function(e) {
            const wrapper = document.querySelector('.avatar-wrapper');
            if (wrapper && !wrapper.contains(e.target)) {
                document.getElementById('avatarDropdown')?.classList.remove('abierto');
            }
        });
    </script>
</body>
</html>