<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Mi Perfil — Mi Álbum de Recuerdos</title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="login.css"/>
    <asset:stylesheet src="cuidador.css"/>
    <asset:stylesheet src="familiar.css"/>
    <asset:stylesheet src="paciente.css"/>
    <asset:stylesheet src="perfil.css"/>
</head>
<body>

    <%-- Navbar --%>
    <nav class="navbar-app">
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

    <main class="perfil-main">

        <%-- Mensajes flash --%>
        <g:if test="${flash.message}">
            <div class="perfil-flash perfil-flash--ok">${flash.message}</div>
        </g:if>
        <g:if test="${flash.error}">
            <div class="perfil-flash perfil-flash--error">${flash.error}</div>
        </g:if>

        <h1 class="perfil-titulo">Mi perfil</h1>

        <div class="perfil-columnas">

            <section class="perfil-seccion">
                <h2 class="perfil-subtitulo">Mis datos</h2>

                <g:form controller="perfil" action="guardarDatos" method="post">

                    <%-- Avatar --%>
                    <div class="perfil-avatar-bloque">
                        <div class="perfil-avatar-actual" id="avatarMuestra">
                            ${usuario.avatar ?: '👤'}
                        </div>
                        <p class="perfil-avatar-label">Elige tu avatar</p>
                        <div class="avatar-grid" id="avatarGrid">
                            <g:each in="${['👴🏻','👵🏻','👦🏻','👧🏻','👩🏻','👨🏻','🐶','🐻','🌸','🌟']}">
                                <span class="avatar-opcion ${it == usuario.avatar ? 'seleccionado' : ''}"
                                      onclick="seleccionarAvatar('${it}')">
                                    ${it}
                                </span>
                            </g:each>
                        </div>
                        <input type="hidden" name="avatar" id="avatarInput" value="${usuario.avatar ?: '👤'}"/>
                    </div>

                    <%-- Nombre --%>
                    <div class="perfil-campo">
                        <label for="nombreCompleto">Nombre completo</label>
                        <input type="text"
                               id="nombreCompleto"
                               name="nombreCompleto"
                               value="${usuario.nombreCompleto}"
                               required/>
                    </div>

                    <%-- Email (solo lectura) --%>
                    <div class="perfil-campo">
                        <label for="emailUsuario">Correo electrónico</label>
                        <input type="email"
                               id="emailUsuario"
                               value="${usuario.username}"
                               readonly
                               class="perfil-readonly"/>
                        <span class="perfil-hint">El correo no se puede modificar.</span>
                    </div>

                    <button type="submit" class="perfil-btn">Guardar cambios</button>

                </g:form>
            </section>

            <%-- Seguridad centrada verticalmente --%>
            <section class="perfil-seccion perfil-seccion--seguridad">
                <h2 class="perfil-subtitulo">Seguridad</h2>

                <g:form controller="perfil" action="cambiarPassword" method="post">

                    <div class="perfil-campo">
                        <label for="passwordActual">Contraseña actual</label>
                        <input type="password" id="passwordActual" name="passwordActual" required/>
                    </div>

                    <div class="perfil-campo">
                        <label for="passwordNueva">Nueva contraseña</label>
                        <input type="password" id="passwordNueva" name="passwordNueva" required minlength="6"/>
                    </div>

                    <div class="perfil-campo">
                        <label for="passwordConfirmar">Confirmar nueva contraseña</label>
                        <input type="password" id="passwordConfirmar" name="passwordConfirmar" required minlength="6"/>
                    </div>

                    <button type="submit" class="perfil-btn">Cambiar contraseña</button>

                </g:form>
            </section>

        </div><%-- fin perfil-columnas --%>

    </main>

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

        // Selección de avatar en perfil
        function seleccionarAvatar(emoji) {
            document.getElementById('avatarInput').value = emoji;
            document.getElementById('avatarMuestra').textContent = emoji;
            document.querySelectorAll('#avatarGrid .avatar-opcion').forEach(function(el) {
                el.classList.remove('seleccionado');
                if (el.textContent.trim() === emoji) el.classList.add('seleccionado');
            });
        }
    </script>

</body>
</html>