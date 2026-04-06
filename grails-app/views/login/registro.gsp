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
                        <input type="password" name="password" id="password" placeholder="Mínimo 6 caracteres"/>
                    </div>
                    <div class="campo">
                        <label>Repite la contraseña</label>
                        <input type="password" id="password2" placeholder="Repite tu contraseña"/>
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