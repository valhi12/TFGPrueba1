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
                        <div style="position:relative; width:100%; display:block; margin-bottom:0;">
                            <input type="password" name="passwordActual" id="passwordActual" required
                                   style="width:100%; padding:11px 44px 11px 16px; box-sizing:border-box;"/>
                            <button type="button" onclick="toggleOjo('passwordActual','svgOjoActual')" tabindex="-1"
                                    style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                <svg id="svgOjoActual" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                    <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="perfil-campo">
                        <label for="passwordNueva">Nueva contraseña</label>
                        <div style="position:relative; width:100%; display:block; margin-bottom:0;">
                            <input type="password" name="passwordNueva" id="passwordNueva" required minlength="6"
                                   style="width:100%; padding:11px 44px 11px 16px; box-sizing:border-box;"/>
                            <button type="button" onclick="toggleOjo('passwordNueva','svgOjoNueva')" tabindex="-1"
                                    style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                <svg id="svgOjoNueva" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                    <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="perfil-campo">
                        <label for="passwordConfirmar">Confirmar nueva contraseña</label>
                        <div style="position:relative; width:100%; display:block; margin-bottom:0;">
                            <input type="password" name="passwordConfirmar" id="passwordConfirmar" required minlength="6"
                                   style="width:100%; padding:11px 44px 11px 16px; box-sizing:border-box;"/>
                            <button type="button" onclick="toggleOjo('passwordConfirmar','svgOjoConfirmar')" tabindex="-1"
                                    style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                <svg id="svgOjoConfirmar" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                    <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                </svg>
                            </button>
                        </div>
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

        // ===== OJO CONTRASEÑA =====
        var SVG_ABIERTO = '<path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>';
        var SVG_CERRADO = '<path d="M53.92,34.62A8,8,0,1,0,42.08,45.38L61.32,66.55C25,88.84,9.38,123.2,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208a127.11,127.11,0,0,0,52.07-10.83l22,24.21a8,8,0,1,0,11.84-10.76Zm47.33,75.84,41.67,45.85a32,32,0,0,1-41.67-45.85ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.16,133.16,0,0,1,25,128c4.69-8.79,19.66-33.39,47.35-49.38l18,19.75a48,48,0,0,0,63.66,70l14.73,16.2A112,112,0,0,1,128,192Zm6-95.43a8,8,0,0,1,3-15.72,48.16,48.16,0,0,1,38.77,42.64,8,8,0,0,1-7.22,8.71,6.39,6.39,0,0,1-.75,0,8,8,0,0,1-8-7.26A32.09,32.09,0,0,0,134,96.57Zm113.28,34.69c-.42.94-10.55,23.37-33.36,43.8a8,8,0,1,1-10.67-11.92A132.77,132.77,0,0,0,231.05,128a133.15,133.15,0,0,0-23.12-30.77C185.67,75.19,158.78,64,128,64a118.37,118.37,0,0,0-19.36,1.57A8,8,0,1,1,106,49.79,134,134,0,0,1,128,48c34.88,0,66.57,13.26,91.66,38.35,18.83,18.83,27.3,37.62,27.65,38.41A8,8,0,0,1,247.31,131.26Z"/>';

        function toggleOjo(inputId, svgId) {
            var input = document.getElementById(inputId);
            var svg = document.getElementById(svgId);
            if (input.type === 'password') {
                input.type = 'text';
                svg.innerHTML = SVG_CERRADO;
            } else {
                input.type = 'password';
                svg.innerHTML = SVG_ABIERTO;
            }
        }
    </script>

</body>
</html>