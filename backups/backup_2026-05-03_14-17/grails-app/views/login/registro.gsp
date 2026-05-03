<!DOCTYPE html>
<html lang="es">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Registro - Mi Álbum de Recuerdos</title>
    <asset:stylesheet src="login.css"/>
</head>
<body>

    <nav class="navbar-login">
        <span class="marca">Mi Álbum de Recuerdos</span>
    </nav>

    <div class="registro-wrapper">
        <div class="card-registro-wide">

            <div class="registro-header">
                <h2>Crea tu cuenta</h2>
                <p class="subtitulo">Únete al círculo de cuidado</p>
            </div>

            <g:if test="${flash.message}">
                <div class="alerta-error">${flash.message}</div>
            </g:if>

            <g:form action="guardarRegistro" id="formRegistro">

                <div class="registro-grid">
                    <div class="campo">
                        <label>Nombre Completo</label>
                        <input type="text" name="nombre" id="nombre" placeholder="Tu nombre y apellidos"/>
                        <div id="errorNombre" class="error-campo">El nombre es obligatorio.</div>
                    </div>
                    <div class="campo">
                        <label>Email</label>
                        <input type="text" name="email" id="email" placeholder="ejemplo@gmail.com"/>
                        <div id="errorEmail" class="error-campo"></div>
                    </div>
                    <div class="campo">
                        <label>Contraseña</label>
                        <div class="campo-password">
                            <input type="password" name="password" id="password" placeholder="Mínimo 6 caracteres"/>
                            <button type="button" class="btn-ojo" onclick="togglePassword(this)" tabindex="-1">
                                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="#000000" viewBox="0 0 256 256"><path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"></path></svg>
                            </button>
                        </div>
                    </div>
                    <div class="campo">
                        <label>Repite la contraseña</label>
                        <div class="campo-password">
                            <input type="password" id="password2" placeholder="Repite tu contraseña"/>
                            <button type="button" class="btn-ojo" onclick="togglePassword(this)" tabindex="-1">
                                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="#000000" viewBox="0 0 256 256"><path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"></path></svg>
                            </button>
                        </div>
                        <div id="errorPassword" class="error-campo"></div>
                    </div>
                </div>

                <div class="registro-seccion">
                    <p class="seccion-titulo">¿Cómo vas a usar la app?</p>
                    <div class="opciones-grid">
                        <div class="opcion-registro">
                            <label style="cursor:pointer; width:100%; margin:0; display:block;">
                                <input type="radio" id="radioCuidador" name="tipoRegistro" value="CUIDADOR" checked
                                       onclick="document.getElementById('divCodigo').classList.add('hidden')">
                                <strong style="margin-left:10px;">Soy Cuidador</strong>
                                <p style="margin-left:25px; font-size:0.85em; color:#9b9088; margin-top:4px;">Crearé un nuevo círculo para un paciente.</p>
                            </label>
                        </div>
                        <div class="opcion-registro">
                            <label style="cursor:pointer; width:100%; margin:0; display:block;">
                                <input type="radio" id="radioFamiliar" name="tipoRegistro" value="FAMILIAR"
                                       onclick="document.getElementById('divCodigo').classList.remove('hidden')">
                                <strong style="margin-left:10px;">Soy Familiar</strong>
                                <p style="margin-left:25px; font-size:0.85em; color:#9b9088; margin-top:4px;">Tengo un código para unirme a un grupo existente.</p>
                            </label>
                        </div>
                    </div>

                    <div id="divCodigo" class="div-codigo hidden">
                        <label>Introduce el Código Familiar</label>
                        <input type="text" id="inputCodigo" name="codigo" placeholder="Ej: ABC-1234"/>
                    </div>
                </div>

                <div class="registro-seccion">
                    <p class="seccion-titulo">Elige tu aspecto</p>
                    <div class="avatar-selector">
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👴🏻" class="avatar-radio"/>
                            <span class="avatar-circulo">👴🏻</span>
                        </label>
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👵🏻" class="avatar-radio"/>
                            <span class="avatar-circulo">👵🏻</span>
                        </label>
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👦🏻" class="avatar-radio"/>
                            <span class="avatar-circulo">👦🏻</span>
                        </label>
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👧🏻" class="avatar-radio"/>
                            <span class="avatar-circulo">👧🏻</span>
                        </label>
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👩🏻" class="avatar-radio" checked/>
                            <span class="avatar-circulo">👩🏻</span>
                        </label>
                        <label class="avatar-opcion">
                            <input type="radio" name="avatar" value="👨🏻" class="avatar-radio"/>
                            <span class="avatar-circulo">👨🏻</span>
                        </label>
                    </div>
                </div>

                <div class="registro-footer">
                    <div class="terminos">
                        <label style="cursor:pointer; display:flex; align-items:center; gap:8px;">
                            <input type="checkbox" id="terminos">
                            <span>Acepto los términos y la política de privacidad</span>
                        </label>
                    </div>
                    <div class="acciones">
                        <g:link action="index" class="btn-secundario">← Volver</g:link>
                        <button type="button" onclick="validarYEnviar()" class="btn-primario">
                            Finalizar Registro
                        </button>
                    </div>
                </div>

            </g:form>
        </div>
    </div>

    <footer class="footer-login">
        © 2026 · Mi Álbum de Recuerdos Familiares
    </footer>

    <script type="text/javascript">
        // ===== OJO CONTRASEÑA =====
        var SVG_OJO_ABIERTO = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="#000000" viewBox="0 0 256 256"><path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"></path></svg>';
        var SVG_OJO_CERRADO = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="#000000" viewBox="0 0 256 256"><path d="M53.92,34.62A8,8,0,1,0,42.08,45.38L61.32,66.55C25,88.84,9.38,123.2,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208a127.11,127.11,0,0,0,52.07-10.83l22,24.21a8,8,0,1,0,11.84-10.76Zm47.33,75.84,41.67,45.85a32,32,0,0,1-41.67-45.85ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.16,133.16,0,0,1,25,128c4.69-8.79,19.66-33.39,47.35-49.38l18,19.75a48,48,0,0,0,63.66,70l14.73,16.2A112,112,0,0,1,128,192Zm6-95.43a8,8,0,0,1,3-15.72,48.16,48.16,0,0,1,38.77,42.64,8,8,0,0,1-7.22,8.71,6.39,6.39,0,0,1-.75,0,8,8,0,0,1-8-7.26A32.09,32.09,0,0,0,134,96.57Zm113.28,34.69c-.42.94-10.55,23.37-33.36,43.8a8,8,0,1,1-10.67-11.92A132.77,132.77,0,0,0,231.05,128a133.15,133.15,0,0,0-23.12-30.77C185.67,75.19,158.78,64,128,64a118.37,118.37,0,0,0-19.36,1.57A8,8,0,1,1,106,49.79,134,134,0,0,1,128,48c34.88,0,66.57,13.26,91.66,38.35,18.83,18.83,27.3,37.62,27.65,38.41A8,8,0,0,1,247.31,131.26Z"></path></svg>';

        function togglePassword(btn) {
            var input = btn.parentElement.querySelector('input');
            if (input.type === 'password') {
                input.type = 'text';
                btn.innerHTML = SVG_OJO_CERRADO;
            } else {
                input.type = 'password';
                btn.innerHTML = SVG_OJO_ABIERTO;
            }
        }

        function validarYEnviar() {
            let valido = true;

            const nombre = document.getElementById('nombre').value.trim();
            const errorNombre = document.getElementById('errorNombre');
            if (nombre === '') {
                errorNombre.style.display = 'block';
                valido = false;
            } else {
                errorNombre.style.display = 'none';
            }

            const email = document.getElementById('email').value.trim().toLowerCase();
            const errorEmail = document.getElementById('errorEmail');
            const regexEmail = /^[a-zA-Z0-9._%+\-]+@gmail\.com$/;
            if (email === '') {
                errorEmail.textContent = 'El email es obligatorio.';
                errorEmail.style.display = 'block';
                valido = false;
            } else if (!regexEmail.test(email)) {
                errorEmail.textContent = 'El email debe tener formato @gmail.com.';
                errorEmail.style.display = 'block';
                valido = false;
            } else {
                errorEmail.style.display = 'none';
            }

            const pass1 = document.getElementById('password').value;
            const pass2 = document.getElementById('password2').value;
            const errorPassword = document.getElementById('errorPassword');
            if (pass1 === '' || pass2 === '') {
                errorPassword.textContent = 'Debes rellenar las dos contraseñas.';
                errorPassword.style.display = 'block';
                valido = false;
            } else if (pass1 !== pass2) {
                errorPassword.textContent = 'Las contraseñas no coinciden.';
                errorPassword.style.display = 'block';
                valido = false;
            } else if (pass1.length < 6) {
                errorPassword.textContent = 'La contraseña debe tener mínimo 6 caracteres.';
                errorPassword.style.display = 'block';
                valido = false;
            } else {
                errorPassword.style.display = 'none';
            }

            const esFamiliar = document.getElementById('radioFamiliar').checked;
            const codigo = document.getElementById('inputCodigo').value.trim();
            if (esFamiliar && codigo === '') {
                alert('No puedes registrarte como Familiar sin introducir el código.');
                document.getElementById('inputCodigo').focus();
                valido = false;
            }

            const terminos = document.getElementById('terminos').checked;
            if (!terminos) {
                alert('Debes aceptar los términos y condiciones.');
                valido = false;
            }

            if (valido) {
                document.querySelector('form').submit();
            }
        }
    </script>

</body>
</html>