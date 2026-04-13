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

    <div class="tabs-nav">
        <button class="tab-btn activo" onclick="cambiarTab('inicio', this)">Inicio</button>
        <g:if test="${rol == 'ROLE_CUIDADOR'}">
            <button class="tab-btn" onclick="cambiarTab('crearPaciente', this)">Crear Paciente</button>
            <button class="tab-btn ${flash.codigoGenerado ? 'activo' : ''}" onclick="cambiarTab('vincularFamiliar', this)">Vincular Familiar</button>
            <button class="tab-btn ${params.mostrarZip || flash.errorZip ? 'activo' : ''}" onclick="cambiarTab('descargarZip', this)">Descargar ZIP</button>
            <button class="tab-btn ${flash.errorEliminar ? 'activo' : ''}" onclick="cambiarTab('eliminarCuenta', this)">Eliminar cuenta</button>
        </g:if>
    </div>

    <div class="tab-contenido">

        <div id="tab-inicio" class="tab-pane activo">
            <div class="inicio-banner">
                <div class="banner-icono">📖</div>
                <div>
                    <h3>Bienvenido al Álbum de Recuerdos</h3>
                    <p>Este es el espacio donde la familia cuida la memoria. Gestiona perfiles, invita a familiares y revive momentos especiales.</p>
                </div>
            </div>
            <div class="inicio-grid" style="margin-top:24px;">
                <div class="inicio-card">
                    <div class="card-icono">👴🏻</div>
                    <h4>Crear Paciente</h4>
                    <p>Registra el perfil del paciente para su álbum personal.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">💌</div>
                    <h4>Invitar Familiares</h4>
                    <p>Genera códigos de acceso para la familia.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">🖼️</div>
                    <h4>Gestionar Recuerdos</h4>
                    <p>Añade fotos y descripciones al álbum.</p>
                </div>
            </div>
        </div>

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
                            <div class="campo" style="grid-column: 1 / -1;">
                                <label>Aspecto del paciente</label>
                                <div style="display:flex; gap:12px; margin-top:6px;">
                                    <label class="avatar-opcion">
                                        <input type="radio" name="avatar" value="👴🏻" class="avatar-radio" checked/>
                                        <span class="avatar-circulo" style="width:52px; height:52px; font-size:1.6rem;">👴🏻</span>
                                    </label>
                                    <label class="avatar-opcion">
                                        <input type="radio" name="avatar" value="👵🏻" class="avatar-radio"/>
                                        <span class="avatar-circulo" style="width:52px; height:52px; font-size:1.6rem;">👵🏻</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-acciones">
                            <button type="button" class="btn-primario" onclick="validarCrearPaciente()">Crear Paciente</button>
                        </div>
                    </g:form>
                </div>
            </div>

            <div id="tab-vincularFamiliar" class="tab-pane">
                <div class="form-seccion">
                    <h4>Vincular nuevo familiar</h4>
                    <g:if test="${flash.codigoGenerado}">
                        <div class="codigo-generado-box">
                            <h5>Código generado correctamente</h5>
                            <div class="codigo-badge">${flash.codigoGenerado}</div>
                            <p style="font-size:0.88rem; color:#9b9088; margin-bottom:16px;">Se enviará a: <strong>${flash.emailFamiliar}</strong></p>
                            <div style="display:flex; gap:12px; margin-top:8px;">
                                <button type="button" class="btn-secundario" onclick="mostrarFormulario()">← Volver</button>
                                <button type="button" class="btn-primario" onclick="document.getElementById('modalEnviar').classList.add('abierto')">Enviar por correo</button>
                            </div>
                        </div>
                        <div class="modal-overlay" id="modalEnviar">
                            <div class="modal-box">
                                <h5>Confirmar envío</h5>
                                <p>¿Enviar el código <strong>${flash.codigoGenerado}</strong> a <strong>${flash.emailFamiliar}</strong>?</p>
                                <div class="modal-acciones">
                                    <button type="button" class="btn-secundario" onclick="document.getElementById('modalEnviar').classList.remove('abierto')">Cancelar</button>
                                    <g:form controller="cuidador" action="enviarCodigo" style="display:inline;">
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
                                <div class="campo"><label>Nombre completo</label><input type="text" name="nombreFamiliar" required/></div>
                                <div class="campo"><label>DNI</label><input type="text" name="dniFamiliar" required/></div>
                                <div class="campo"><label>Email</label><input type="text" name="emailFamiliar" required/></div>
                                <div class="campo"><label>Contraseña</label><input type="password" name="passwordFamiliar" required/></div>
                                <div class="campo"><label>Repite contraseña</label><input type="password" name="passwordFamiliar2" required/></div>
                            </div>
                            <hr class="form-separador"/>
                            <p class="form-subtitulo">Paciente a vincular</p>
                            <div class="form-grid">
                                <div class="campo">
                                    <label>DNI del paciente</label>
                                    <input type="text" name="dniPaciente" placeholder="DNI del paciente" required/>
                                </div>
                            </div>
                            <div class="form-acciones">
                                <button type="submit" class="btn-primario">Generar Código</button>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>

            <div id="tab-descargarZip" class="tab-pane">
                <div class="form-seccion">
                    <h4>Descargar álbum en ZIP</h4>
                    <div id="formBusqueda" style="${params.mostrarZip && params.albumId ? 'display:none;' : ''}">
                        <g:form controller="cuidador" action="buscarAlbum" style="max-width:500px;">
                            <div class="form-grid">
                                <div class="campo">
                                    <label>DNI del paciente</label>
                                    <input type="text" name="dni" placeholder="Ej: 12345678A" required
                                        style="width:100%; padding:11px 16px; border:1.5px solid #dde8db; border-radius:10px; background:var(--verde-suave); outline:none;"/>
                                </div>
                            </div>
                            <div class="form-acciones">
                                <button type="submit" class="btn-primario">Obtener álbum</button>
                            </div>
                        </g:form>
                    </div>
                    <g:if test="${params.mostrarZip && params.albumId}">
                        <% def albumZip = tfg.Album.get(params.albumId?.toLong()) %>
                        <g:if test="${albumZip}">
                            <div style="margin-top:32px; background:var(--verde-suave); border-radius:16px; padding:28px 32px;">
                                <h3>${albumZip.titulo}</h3>
                                <p>Paciente: ${albumZip.paciente.nombre}</p>
                                <a href="${g.createLink(controller:'cuidador', action:'descargarZip', params:[albumId: albumZip.id])}"
                                   class="btn-primario" style="text-decoration:none; display:inline-block; margin-top:10px;">Descargar ZIP</a>
                            </div>
                        </g:if>
                    </g:if>
                </div>
            </div>

            <div id="tab-eliminarCuenta" class="tab-pane">
                <div class="form-seccion">
                    <h4>Eliminar cuenta</h4>
                    <p style="margin-bottom:28px; color:#9b9088;">Busca la cuenta que deseas eliminar mediante el DNI.</p>

                    <g:if test="${flash.errorEliminar}">
                        <div class="alerta-error" style="background: #fdecea; color: #c0392b; padding: 15px; border-radius: 10px; border: 1px solid #f5c6c2; margin-bottom: 24px;">
                            ${flash.errorEliminar}
                        </div>
                    </g:if>

                    <div style="background:var(--verde-suave); border-radius:14px; padding:24px 28px; margin-bottom:20px;">
                        <h5>🧓 Eliminar cuenta de paciente</h5>
                        <div class="form-grid" style="max-width:500px;">
                            <div class="campo">
                                <label>DNI del paciente</label>
                                <input type="text" id="dniPacienteEliminar" placeholder="Ej: 12345678A"
                                       style="width:100%; padding:11px 16px; border:1.5px solid #dde8db; border-radius:10px; background:var(--blanco-roto); outline:none;"/>
                            </div>
                        </div>
                        <div style="margin-top:16px;">
                            <button type="button" class="btn-primario" style="background:#e74c3c;" onclick="abrirModalEliminar('modalEliminarPaciente')">Eliminar paciente</button>
                        </div>
                    </div>

                    <div style="background:var(--verde-suave); border-radius:14px; padding:24px 28px; margin-bottom:20px;">
                        <h5>👨‍👩‍👧 Eliminar cuenta de familiar</h5>
                        <div class="form-grid" style="max-width:500px;">
                            <div class="campo">
                                <label>DNI del familiar</label>
                                <input type="text" id="dniFamiliarEliminar" placeholder="Ej: 12345678A"
                                       style="width:100%; padding:11px 16px; border:1.5px solid #dde8db; border-radius:10px; background:var(--blanco-roto); outline:none;"/>
                            </div>
                        </div>
                        <div style="margin-top:16px;">
                            <button type="button" class="btn-primario" style="background:#e74c3c;" onclick="abrirModalEliminar('modalEliminarFamiliar')">Eliminar familiar</button>
                        </div>
                    </div>

                    <div style="background:#fdecea; border:1px solid #f5c6c2; border-radius:14px; padding:24px 28px;">
                        <h5 style="color:#c0392b;">⚠️ Eliminar mi cuenta</h5>
                        <div style="max-width:300px;">
                            <div class="campo">
                                <label>Confirma tu contraseña</label>
                                <input type="password" id="passwordCuidadorEliminar" placeholder="Tu contraseña actual"
                                       style="width:100%; padding:11px 16px; border:1.5px solid #f5c6c2; border-radius:10px; background:var(--blanco-roto); outline:none;"/>
                            </div>
                        </div>
                        <div style="margin-top:16px;">
                            <button type="button" class="btn-primario" style="background:#c0392b;" onclick="abrirModalEliminar('modalEliminarPropia')">Eliminar mi cuenta</button>
                        </div>
                    </div>
                </div>
            </div>
        </g:if>
    </div>
</div>

<div class="modal-overlay" id="modalEliminarPaciente">
    <div class="modal-box">
        <h5>Confirmar eliminación</h5>
        <p>¿Segura que quieres eliminar al paciente con DNI <strong id="dniPacienteConfirm"></strong>? Esta acción es irreversible.</p>
        <div class="modal-acciones">
            <button type="button" class="btn-secundario" onclick="cerrarModal('modalEliminarPaciente')">Cancelar</button>
            <g:form controller="cuidador" action="eliminarCuentaPaciente" style="display:inline;">
                <input type="hidden" id="hiddenDniPaciente" name="dni"/>
                <button type="submit" class="btn-primario" style="background:#e74c3c;">Sí, eliminar</button>
            </g:form>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modalEliminarFamiliar">
    <div class="modal-box">
        <h5>Confirmar eliminación</h5>
        <p>¿Segura que quieres eliminar al familiar con DNI <strong id="dniFamiliarConfirm"></strong>?</p>
        <div class="modal-acciones">
            <button type="button" class="btn-secundario" onclick="cerrarModal('modalEliminarFamiliar')">Cancelar</button>
            <g:form controller="cuidador" action="eliminarCuentaFamiliar" style="display:inline;">
                <input type="hidden" id="hiddenDniFamiliar" name="dni"/>
                <button type="submit" class="btn-primario" style="background:#e74c3c;">Sí, eliminar</button>
            </g:form>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modalEliminarPropia">
    <div class="modal-box">
        <h5>Confirmar eliminación</h5>
        <p>¿Segura que quieres borrar tu cuenta? Se perderán todos tus datos.</p>
        <div class="modal-acciones">
            <button type="button" class="btn-secundario" onclick="cerrarModal('modalEliminarPropia')">Cancelar</button>
            <g:form controller="cuidador" action="eliminarCuentaPropia" style="display:inline;">
                <input type="hidden" id="hiddenPasswordCuidador" name="password"/>
                <button type="submit" class="btn-primario" style="background:#c0392b;">Sí, eliminar</button>
            </g:form>
        </div>
    </div>
</div>

<script>
    function cambiarTab(nombre, btn) {
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('activo'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('activo'));
        document.getElementById('tab-' + nombre).classList.add('activo');
        if(btn) btn.classList.add('activo');
    }

    function mostrarFormulario() {
        document.getElementById('formularioVincular').style.display = 'block';
        document.querySelector('.codigo-generado-box')?.style.setProperty('display', 'none');
    }

    function abrirModalEliminar(modalId) {
        if (modalId === 'modalEliminarPaciente') {
            const dni = document.getElementById('dniPacienteEliminar').value.trim();
            if (!dni) { alert('Introduce el DNI del paciente.'); return; }
            document.getElementById('dniPacienteConfirm').textContent = dni;
            document.getElementById('hiddenDniPaciente').value = dni;
        } 
        else if (modalId === 'modalEliminarFamiliar') {
            const dni = document.getElementById('dniFamiliarEliminar').value.trim();
            if (!dni) { alert('Introduce el DNI del familiar.'); return; }
            document.getElementById('dniFamiliarConfirm').textContent = dni;
            document.getElementById('hiddenDniFamiliar').value = dni;
        } 
        else if (modalId === 'modalEliminarPropia') {
            const password = document.getElementById('passwordCuidadorEliminar').value;
            if (!password) { alert('Introduce tu contraseña.'); return; }
            document.getElementById('hiddenPasswordCuidador').value = password;
        }
        document.getElementById(modalId).classList.add('abierto');
    }

    function cerrarModal(modalId) {
        document.getElementById(modalId).classList.remove('abierto');
    }

    window.addEventListener('DOMContentLoaded', function() {
        // Lógica de apertura automática de pestañas por errores o procesos
        if (${flash.codigoGenerado ? 'true' : 'false'}) {
            cambiarTab('vincularFamiliar', document.querySelector('.tab-btn:nth-child(3)'));
        } else if (${params.mostrarZip || flash.errorZip ? 'true' : 'false'}) {
            cambiarTab('descargarZip', document.querySelector('.tab-btn:nth-child(4)'));
        } else if (${flash.errorEliminar ? 'true' : 'false'}) {
            cambiarTab('eliminarCuenta', document.querySelector('.tab-btn:nth-child(5)'));
        }
    });

    function validarCrearPaciente() {
        let valido = true;
        const nombre = document.getElementById('nombrePaciente').value.trim();
        const dni = document.getElementById('dniPaciente').value.trim();
        if (!nombre) { document.getElementById('errorNombrePaciente').style.display = 'block'; valido = false; }
        if (dni.length < 9) { document.getElementById('errorDniPaciente').style.display = 'block'; valido = false; }
        if (valido) document.getElementById('formCrearPaciente').submit();
    }
</script>
</body>
</html>