<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Inicio</title>
</head>
<body>
<div class="app-wrapper">

    <h1 class="bienvenida-titulo">Hola, ${usuario.nombreCompleto}</h1>

    <g:if test="${flash.message}">
        <div class="alerta-success">${flash.message}</div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alerta-error">${flash.error}</div>
    </g:if>

    <!-- TABS -->
    <div class="tabs-nav">
        <button class="tab-btn activo" onclick="cambiarTab('inicio', this)">Inicio</button>
        <g:if test="${rol == 'ROLE_CUIDADOR'}">
            <button class="tab-btn" onclick="cambiarTab('crearPaciente', this)">Crear Paciente</button>
            <button class="tab-btn ${flash.codigoGenerado ? 'activo' : ''}" onclick="cambiarTab('vincularFamiliar', this)">Vincular Familiar</button>
        </g:if>
    </div>

    <div class="tab-contenido">

        <!-- TAB INICIO -->
        <div id="tab-inicio" class="tab-pane activo">
            <div class="inicio-banner">
                <div class="banner-icono">📖</div>
                <div>
                    <h3>Bienvenido al Álbum de Recuerdos</h3>
                    <p>Este es el espacio donde la familia cuida la memoria. Desde aquí puedes crear el perfil del paciente, invitar a familiares y gestionar los recuerdos que harán que cada día sea un poco más especial.</p>
                </div>
            </div>

            <div class="inicio-grid" style="margin-top:24px;">
                <div class="inicio-card">
                    <div class="card-icono">👴🏻</div>
                    <h4>Crear Paciente</h4>
                    <p>Registra el perfil del paciente para que pueda acceder a su álbum personal de recuerdos.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">💌</div>
                    <h4>Invitar Familiares</h4>
                    <p>Genera un código único y envíaselo a un familiar para que se una al círculo de cuidado.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">🖼️</div>
                    <h4>Gestionar Recuerdos</h4>
                    <p>Añade fotos y descripciones al álbum para que el paciente pueda revivir sus mejores momentos.</p>
                </div>
            </div>
        </div>

        <!-- TAB CREAR PACIENTE -->
        <g:if test="${rol == 'ROLE_CUIDADOR'}">
            <div id="tab-crearPaciente" class="tab-pane">
                <div class="form-seccion">
                    <h4>Crear nuevo paciente</h4>
                    <g:form controller="cuidador" action="crearPaciente" id="formCrearPaciente">
                        <div class="form-grid">
                            <div class="campo">
                                <label>Nombre completo</label>
                                <input type="text" name="nombre" id="nombrePaciente" placeholder="Nombre y apellidos"/>
                                <div id="errorNombrePaciente" class="error-campo">El nombre es obligatorio.</div>
                            </div>
                            <div class="campo">
                                <label>DNI</label>
                                <input type="text" name="dni" id="dniPaciente" placeholder="Ej: 12345678A"/>
                                <div id="errorDniPaciente" class="error-campo"></div>
                            </div>
                            <div class="campo">
                                <label>Fecha de nacimiento</label>
                                <input type="date" name="fechaNacimiento"/>
                            </div>
                            <div class="campo">
                                <label>Email</label>
                                <input type="text" name="email" id="emailPaciente" placeholder="ejemplo@gmail.com"/>
                                <div id="errorEmailPaciente" class="error-campo"></div>
                            </div>
                            <div class="campo">
                                <label>Contraseña</label>
                                <input type="password" name="password" id="passwordPaciente" placeholder="Mínimo 6 caracteres"/>
                            </div>
                            <div class="campo">
                                <label>Repite la contraseña</label>
                                <input type="password" id="password2Paciente" placeholder="Repite la contraseña"/>
                                <div id="errorPasswordPaciente" class="error-campo"></div>
                            </div>
                        </div>
                        <div class="form-acciones">
                            <button type="button" onclick="validarCrearPaciente()" class="btn-primario">Crear Paciente</button>
                        </div>
                    </g:form>
                </div>
            </div>

            <!-- TAB VINCULAR FAMILIAR -->
                
                <div id="tab-vincularFamiliar" class="tab-pane">
                    <div class="form-seccion">
                        <h4>Vincular nuevo familiar</h4>

                        <g:if test="${flash.codigoGenerado}">
                            <div class="codigo-generado-box">
                                <h5>Código generado correctamente</h5>
                                <div class="codigo-badge">${flash.codigoGenerado}</div>
                                <p style="font-size:0.88rem; color:#9b9088; margin-bottom:16px;">
                                    Se enviará a: <strong>${flash.emailFamiliar}</strong>
                                </p>
                                <div style="display:flex; gap:12px; margin-top:8px;">
                                    <button type="button" class="btn-secundario" onclick="mostrarFormulario()">← Volver</button>
                                    <button type="button" class="btn-primario" onclick="document.getElementById('modalEnviar').classList.add('abierto')">
                                        Enviar código por correo
                                    </button>
                                </div>
                            </div>

                            <div class="modal-overlay" id="modalEnviar">
                                <div class="modal-box">
                                    <h5>Confirmar envío</h5>
                                    <p>¿Estás segura de enviar el código <strong>${flash.codigoGenerado}</strong> al correo <strong>${flash.emailFamiliar}</strong>?</p>
                                    <div class="modal-acciones">
                                        <button type="button" class="btn-secundario" onclick="document.getElementById('modalEnviar').classList.remove('abierto')">Cancelar</button>
                                        <g:form controller="cuidador" action="enviarCodigo" id="formEnviarCodigo" style="display:inline;">
                                            <input type="hidden" name="codigo" value="${flash.codigoGenerado}"/>
                                            <input type="hidden" name="email" value="${flash.emailFamiliar}"/>
                                            <input type="hidden" name="nombre" value="${flash.nombreFamiliar}"/>
                                            <button type="submit" class="btn-primario">Sí, enviar</button>
                                        </g:form>
                                    </div>
                                </div>
                            </div>
                        </g:if>

                        <div id="formularioVincular" style="${flash.codigoGenerado ? 'display:none;' : ''}">
                            <g:form controller="cuidador" action="generarCodigo">
                                <p class="form-subtitulo">Datos del familiar</p>
                                <div class="form-grid">
                                    <div class="campo">
                                        <label>Nombre completo</label>
                                        <input type="text" name="nombreFamiliar" placeholder="Nombre y apellidos" required/>
                                    </div>
                                    <div class="campo">
                                        <label>DNI</label>
                                        <input type="text" name="dniFamiliar" placeholder="Ej: 12345678A" required/>
                                    </div>
                                    <div class="campo">
                                        <label>Email</label>
                                        <input type="text" name="emailFamiliar" placeholder="ejemplo@gmail.com" required/>
                                    </div>
                                    <div class="campo">
                                        <label>Contraseña</label>
                                        <input type="password" name="passwordFamiliar" placeholder="Mínimo 6 caracteres" required/>
                                    </div>
                                    <div class="campo">
                                        <label>Repite la contraseña</label>
                                        <input type="password" name="passwordFamiliar2" placeholder="Repite la contraseña" required/>
                                    </div>
                                </div>

                                <hr class="form-separador"/>
                                <p class="form-subtitulo">Paciente a vincular</p>
                                <div class="form-grid">
                                    <div class="campo">
                                        <label>Nombre completo del paciente</label>
                                        <input type="text" name="nombrePaciente" placeholder="Nombre y apellidos" required/>
                                    </div>
                                    <div class="campo">
                                        <label>DNI del paciente</label>
                                        <input type="text" name="dniPaciente" placeholder="Ej: 12345678A" required/>
                                    </div>
                                </div>

                                <div class="form-acciones">
                                    <button type="submit" class="btn-primario">Generar Código</button>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
        </g:if>
    </div>
</div>

<script>
    function cambiarTab(nombre, btn) {
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('activo'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('activo'));
        document.getElementById('tab-' + nombre).classList.add('activo');
        btn.classList.add('activo');
    }

    function mostrarFormulario() {
        document.getElementById('formularioVincular').style.display = 'block';
        document.querySelector('.codigo-generado-box')?.style.setProperty('display', 'none');
    }

    window.addEventListener('DOMContentLoaded', function() {
        const tieneCodigoGenerado = ${flash.codigoGenerado ? 'true' : 'false'};
        if (tieneCodigoGenerado) {
            document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('activo'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('activo'));
            document.getElementById('tab-vincularFamiliar').classList.add('activo');
            document.querySelectorAll('.tab-btn').forEach(b => {
                if (b.textContent.includes('Vincular')) b.classList.add('activo');
            });
        }
    });

    function validarCrearPaciente() {
        let valido = true;
        const regexDni = /^[0-9]{8}[A-Z]$/;
        const regexEmail = /^[a-zA-Z0-9._%+\-]+@gmail\.com$/;

        const nombre = document.getElementById('nombrePaciente').value.trim();
        const errorNombre = document.getElementById('errorNombrePaciente');
        if (nombre === '') { errorNombre.style.display = 'block'; valido = false; }
        else errorNombre.style.display = 'none';

        const dni = document.getElementById('dniPaciente').value.trim().toUpperCase();
        const errorDni = document.getElementById('errorDniPaciente');
        if (!regexDni.test(dni)) { errorDni.textContent = 'DNI inválido. Ej: 12345678A'; errorDni.style.display = 'block'; valido = false; }
        else errorDni.style.display = 'none';

        const email = document.getElementById('emailPaciente').value.trim().toLowerCase();
        const errorEmail = document.getElementById('errorEmailPaciente');
        if (!regexEmail.test(email)) { errorEmail.textContent = 'El email debe ser @gmail.com'; errorEmail.style.display = 'block'; valido = false; }
        else errorEmail.style.display = 'none';

        const pass1 = document.getElementById('passwordPaciente').value;
        const pass2 = document.getElementById('password2Paciente').value;
        const errorPass = document.getElementById('errorPasswordPaciente');
        if (pass1 === '' || pass2 === '') { errorPass.textContent = 'Debes rellenar las dos contraseñas.'; errorPass.style.display = 'block'; valido = false; }
        else if (pass1 !== pass2) { errorPass.textContent = 'Las contraseñas no coinciden.'; errorPass.style.display = 'block'; valido = false; }
        else if (pass1.length < 6) { errorPass.textContent = 'Mínimo 6 caracteres.'; errorPass.style.display = 'block'; valido = false; }
        else errorPass.style.display = 'none';

        if (valido) document.getElementById('formCrearPaciente').submit();
    }

    function validarVincularFamiliar() {
        let valido = true;
        console.log('Validando...');
        const regexDni = /^[0-9]{8}[A-Z]$/;
        const regexEmail = /^[a-zA-Z0-9._%+\-]+@gmail\.com$/;

        const nombre = document.getElementById('nombreFamiliarInput').value.trim();
        const errorNombre = document.getElementById('errorNombreFamiliar');
        if (nombre === '') { errorNombre.style.display = 'block'; valido = false; }
        else errorNombre.style.display = 'none';

        const dni = document.getElementById('dniFamiliarInput').value.trim().toUpperCase();
        const errorDni = document.getElementById('errorDniFamiliar');
        if (!regexDni.test(dni)) { errorDni.textContent = 'DNI inválido. Ej: 12345678A'; errorDni.style.display = 'block'; valido = false; }
        else errorDni.style.display = 'none';

        const email = document.getElementById('emailFamiliarInput').value.trim().toLowerCase();
        const errorEmail = document.getElementById('errorEmailFamiliar');
        if (!regexEmail.test(email)) { errorEmail.textContent = 'El email debe ser @gmail.com'; errorEmail.style.display = 'block'; valido = false; }
        else errorEmail.style.display = 'none';

        const pass1 = document.getElementById('passwordFamiliarInput').value;
        const pass2 = document.getElementById('password2FamiliarInput').value;
        const errorPass = document.getElementById('errorPasswordFamiliar');
        if (pass1 === '' || pass2 === '') { errorPass.textContent = 'Debes rellenar las dos contraseñas.'; errorPass.style.display = 'block'; valido = false; }
        else if (pass1 !== pass2) { errorPass.textContent = 'Las contraseñas no coinciden.'; errorPass.style.display = 'block'; valido = false; }
        else if (pass1.length < 6) { errorPass.textContent = 'Mínimo 6 caracteres.'; errorPass.style.display = 'block'; valido = false; }
        else errorPass.style.display = 'none';

        const nombrePaciente = document.getElementById('nombrePacienteInput').value.trim();
        const errorNombrePaciente = document.getElementById('errorNombrePacienteVincular');
        if (nombrePaciente === '') { errorNombrePaciente.style.display = 'block'; valido = false; }
        else errorNombrePaciente.style.display = 'none';

        const dniPaciente = document.getElementById('dniPacienteInput').value.trim().toUpperCase();
        const errorDniPaciente = document.getElementById('errorDniPacienteVincular');
        if (!regexDni.test(dniPaciente)) { errorDniPaciente.textContent = 'DNI inválido. Ej: 12345678A'; errorDniPaciente.style.display = 'block'; valido = false; }
        else errorDniPaciente.style.display = 'none';

        console.log('Válido:', valido);
        if (valido) document.getElementById('formVincularFamiliar').submit();
    }
</script>
</body>
</html>