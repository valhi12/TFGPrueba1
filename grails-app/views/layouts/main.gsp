<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><g:layoutTitle default="Mi Álbum de Recuerdos"/></title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="login.css"/>
    <asset:stylesheet src="cuidador.css"/>
    <asset:stylesheet src="familiar.css"/>
    <asset:stylesheet src="paciente.css"/>
</head>
<body>

    <nav class="navbar-app">
        <%-- Marca: enlace a inicio si hay sesión (inicio/bienvenida redirige por rol automáticamente) --%>
        <g:if test="${session.usuario}">
           <a href="${g.createLink(controller:'inicio', action:'bienvenida')}"
                class="marca"
                style="text-decoration:none; color:var(--verde-pastel); cursor:pointer; font-family:inherit; font-size:inherit; font-weight:inherit; background:none; border:none; padding:0;">
                Mi Álbum de Recuerdos
            </a>
        </g:if>
        <g:else>
            <span class="marca">Mi Álbum de Recuerdos</span>
        </g:else>

        <div style="display:flex; align-items:center; gap:12px; margin-left:auto;">
            <g:if test="${esFamiliar}">
                <a href="${g.createLink(controller:'familiar', action:'bienvenida')}#album"
                   style="font-family:'Nunito',sans-serif; font-size:0.88rem; font-weight:600; color:var(--marron-suave, #6b5e52); text-decoration:none; border:1.5px solid rgba(168,197,160,0.4); padding:7px 16px; border-radius:8px; background:var(--verde-suave, #e8f2e6); transition:background 0.2s;"
                   onmouseover="this.style.background='#c8dfc4'"
                   onmouseout="this.style.background='var(--verde-suave, #e8f2e6)'">
                    ← Volver
                </a>
            </g:if>
            <g:if test="${session.usuario}">
                <div class="avatar-wrapper">
                    <button class="avatar-btn" onclick="toggleDropdown()">
                        ${session.usuario?.avatar ?: '👤'}
                    </button>
                    <div class="avatar-dropdown" id="avatarDropdown">
                        <div class="nombre-usuario">${session.usuario?.nombreCompleto}</div>
                        <g:link controller="perfil" action="index">Mi perfil</g:link>
                        <g:link controller="inicio" action="logout">Cerrar sesión</g:link>
                    </div>
                </div>
            </g:if>
        </div>
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