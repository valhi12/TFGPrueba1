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
                    <p>Este es el espacio donde la familia cuida la memoria. Gestiona perfiles, invita a familiares y descarga los álbumes</p>
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
                    <h4>Descarga álbumes</h4>
                    <p>Descarga los álbumes en formato zip</p>
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
                                <input type="date" name="fechaNacimiento" max="${new java.text.SimpleDateFormat('yyyy-MM-dd').format(new Date())}"/>
                            </div>
                            <div class="campo">
                                <label>Email</label>
                                <input type="text" name="email" id="emailPaciente" placeholder="ejemplo@gmail.com"/>
                                <div id="errorEmailPaciente" class="error-campo"></div>
                            </div>
                            <div class="campo">
                                <label>Contraseña</label>
                                <div style="position:relative; width:100%; display:block;">
                                    <input type="password" name="password" id="passwordPaciente" placeholder="Mínimo 6 caracteres"
                                           style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; color:#4a4a4a; background:#e8f2e6; outline:none; box-sizing:border-box;"/>
                                    <button type="button" onclick="toggleOjo('passwordPaciente','svgOjoPP')" tabindex="-1"
                                            style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                        <svg id="svgOjoPP" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                            <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <div class="campo">
                                <label>Repite la contraseña</label>
                                <div style="position:relative; width:100%; display:block;">
                                    <input type="password" id="password2Paciente" placeholder="Repite la contraseña"
                                           style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; color:#4a4a4a; background:#e8f2e6; outline:none; box-sizing:border-box;"/>
                                    <button type="button" onclick="toggleOjo('password2Paciente','svgOjoPP2')" tabindex="-1"
                                            style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                        <svg id="svgOjoPP2" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                            <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                        </svg>
                                    </button>
                                </div>
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
                            <%-- type="button" para que pase por validarCrearPaciente() antes de enviar --%>
                            <button type="button" onclick="validarCrearPaciente()" class="btn-primario">Crear Paciente</button>
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
                        <g:form controller="cuidador" action="generarCodigo" id="formVincularFamiliar">
                            <p class="form-subtitulo">Datos del familiar</p>
                            <div class="form-grid">
                                <div class="campo"><label>Nombre completo</label><input type="text" name="nombreFamiliar" placeholder="Nombre y apellidos" required/></div>
                                <div class="campo">
                                    <label>DNI</label>
                                    <input type="text" name="dniFamiliar" id="dniFamiliar" placeholder="Ej: 12345678A" required/>
                                    <div id="errorDniFamiliar" class="error-campo"></div>
                                </div>
                                <div class="campo"><label>Email</label><input type="text" name="emailFamiliar" placeholder="ejemplo@gmail.com" required/></div>
                                <div class="campo">
                                    <label>Contraseña</label>
                                    <div style="position:relative; width:100%; display:block;">
                                        <input type="password" name="passwordFamiliar" id="passwordFamiliar" placeholder="Mínimo 6 caracteres" required
                                               style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; color:#4a4a4a; background:#e8f2e6; outline:none; box-sizing:border-box;"/>
                                        <button type="button" onclick="toggleOjo('passwordFamiliar','svgOjoPF')" tabindex="-1"
                                                style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                            <svg id="svgOjoPF" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                                <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                                <div class="campo">
                                    <label>Repite contraseña</label>
                                    <div style="position:relative; width:100%; display:block;">
                                        <input type="password" name="passwordFamiliar2" id="passwordFamiliar2" placeholder="Repite la contraseña" required
                                               style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; color:#4a4a4a; background:#e8f2e6; outline:none; box-sizing:border-box;"/>
                                        <button type="button" onclick="toggleOjo('passwordFamiliar2','svgOjoPF2')" tabindex="-1"
                                                style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                            <svg id="svgOjoPF2" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                                <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <div id="errorPasswordFamiliar" class="error-campo"></div>
                                </div>
                            </div>
                            <hr class="form-separador"/>
                            <p class="form-subtitulo">Paciente a vincular</p>
                            <div class="campo" style="max-width:calc(50% - 6px);"><label>DNI del paciente</label><input type="text" name="dniPaciente" id="dniPacienteVincular" placeholder="DNI del paciente" required/><div id="errorDniPacienteVincular" class="error-campo"></div></div>                            
                            <div class="form-acciones">
                                <%-- type="button" para que pase por validarVincularFamiliar() antes de enviar --%>
                                <button type="button" onclick="validarVincularFamiliar()" class="btn-primario">Generar Código</button>
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
                        <h5>👵🏻 Eliminar cuenta de paciente</h5>
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
                        <h5>👨🏽 Eliminar cuenta de familiar</h5>
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
                                <div style="position:relative; width:100%; display:block;">
                                    <input type="password" id="passwordCuidadorEliminar" placeholder="Tu contraseña actual"
                                           style="width:100%; padding:11px 44px 11px 16px; border:1.5px solid #f5c6c2; border-radius:10px; background:var(--blanco-roto); outline:none; box-sizing:border-box;"/>
                                    <button type="button" onclick="toggleOjo('passwordCuidadorEliminar','svgOjoEliminar')" tabindex="-1"
                                            style="position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; padding:4px; line-height:0;">
                                        <svg id="svgOjoEliminar" xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 256 256" style="display:block; fill:#6b5e52; opacity:0.6;">
                                            <path d="M247.31,124.76c-.35-.79-8.82-19.58-27.65-38.41C194.57,61.26,162.88,48,128,48S61.43,61.26,36.34,86.35C17.51,105.18,9,124,8.69,124.76a8,8,0,0,0,0,6.5c.35.79,8.82,19.57,27.65,38.4C61.43,194.74,93.12,208,128,208s66.57-13.26,91.66-38.34c18.83-18.83,27.3-37.61,27.65-38.4A8,8,0,0,0,247.31,124.76ZM128,192c-30.78,0-57.67-11.19-79.93-33.25A133.47,133.47,0,0,1,25,128,133.33,133.33,0,0,1,48.07,97.25C70.33,75.19,97.22,64,128,64s57.67,11.19,79.93,33.25A133.46,133.46,0,0,1,231.05,128C223.84,141.46,192.43,192,128,192Zm0-112a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160Z"/>
                                        </svg>
                                    </button>
                                </div>
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
        if (${flash.codigoGenerado ? 'true' : 'false'}) {
            cambiarTab('vincularFamiliar', document.querySelector('.tab-btn:nth-child(3)'));
        } else if (${params.mostrarZip || flash.errorZip ? 'true' : 'false'}) {
            cambiarTab('descargarZip', document.querySelector('.tab-btn:nth-child(4)'));
        } else if (${flash.errorEliminar ? 'true' : 'false'}) {
            cambiarTab('eliminarCuenta', document.querySelector('.tab-btn:nth-child(5)'));
        }
    });

    // ===== VALIDACIÓN DE CONTRASEÑA COMPARTIDA =====
    // Mínimo 6 caracteres, 1 mayúscula, 1 minúscula, 1 número, 1 carácter especial
    function validarPassword(pass) {
        if (pass.length < 6) return 'La contraseña debe tener mínimo 6 caracteres.';
        if (!/[A-Z]/.test(pass)) return 'La contraseña debe contener al menos una mayúscula.';
        if (!/[a-z]/.test(pass)) return 'La contraseña debe contener al menos una minúscula.';
        if (!/[0-9]/.test(pass)) return 'La contraseña debe contener al menos un número.';
        if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pass)) return 'La contraseña debe contener al menos un carácter especial.';
        return null; // null = sin errores
    }

    // ===== VALIDAR CREAR PACIENTE =====
    function validarCrearPaciente() {
        let valido = true;

        const nombre = document.getElementById('nombrePaciente').value.trim();
        if (!nombre) {
            document.getElementById('errorNombrePaciente').style.display = 'block';
            valido = false;
        } else {
            document.getElementById('errorNombrePaciente').style.display = 'none';
        }

        const dni = document.getElementById('dniPaciente').value.trim();
        if (dni.length < 9) {
            document.getElementById('errorDniPaciente').textContent = 'DNI inválido.';
            document.getElementById('errorDniPaciente').style.display = 'block';
            valido = false;
        } else {
            document.getElementById('errorDniPaciente').style.display = 'none';
        }

        const pass1 = document.getElementById('passwordPaciente').value;
        const pass2 = document.getElementById('password2Paciente').value;
        const errorPass = document.getElementById('errorPasswordPaciente');
        if (pass1 === '' || pass2 === '') {
            errorPass.textContent = 'Debes rellenar las dos contraseñas.';
            errorPass.style.display = 'block';
            valido = false;
        } else if (pass1 !== pass2) {
            errorPass.textContent = 'Las contraseñas no coinciden.';
            errorPass.style.display = 'block';
            valido = false;
        } else {
            var errorFuerza = validarPassword(pass1);
            if (errorFuerza) {
                errorPass.textContent = errorFuerza;
                errorPass.style.display = 'block';
                valido = false;
            } else {
                errorPass.style.display = 'none';
            }
        }

        if (valido) document.querySelector('#tab-crearPaciente form').submit();
    }

    // ===== VALIDAR VINCULAR FAMILIAR =====
    // ===== VALIDAR VINCULAR FAMILIAR =====
    function validarVincularFamiliar() {
        let valido = true;

        // Validar formato DNI familiar (8 números + 1 letra)
        const dniFamiliar = document.getElementById('dniFamiliar').value.trim();
        const errorDniFamiliar = document.getElementById('errorDniFamiliar');
        if (!/^\d{8}[A-Za-z]$/.test(dniFamiliar)) {
            errorDniFamiliar.textContent = 'DNI inválido. Formato esperado: 12345678A';
            errorDniFamiliar.style.display = 'block';
            valido = false;
        } else {
            errorDniFamiliar.style.display = 'none';
        }

        // Validar formato DNI paciente (8 números + 1 letra)
        const dniPaciente = document.getElementById('dniPacienteVincular').value.trim();
        const errorDniPaciente = document.getElementById('errorDniPacienteVincular');
        if (!/^\d{8}[A-Za-z]$/.test(dniPaciente)) {
            errorDniPaciente.textContent = 'DNI inválido. Formato esperado: 12345678A';
            errorDniPaciente.style.display = 'block';
            valido = false;
        } else {
            errorDniPaciente.style.display = 'none';
        }

        const pass1 = document.getElementById('passwordFamiliar').value;
        const pass2 = document.getElementById('passwordFamiliar2').value;
        const errorPass = document.getElementById('errorPasswordFamiliar');
        if (pass1 === '' || pass2 === '') {
            errorPass.textContent = 'Debes rellenar las dos contraseñas.';
            errorPass.style.display = 'block';
            valido = false;
        } else if (pass1 !== pass2) {
            errorPass.textContent = 'Las contraseñas no coinciden.';
            errorPass.style.display = 'block';
            valido = false;
        } else {
            var errorFuerza = validarPassword(pass1);
            if (errorFuerza) {
                errorPass.textContent = errorFuerza;
                errorPass.style.display = 'block';
                valido = false;
            } else {
                errorPass.style.display = 'none';
            }
        }

        if (valido) document.querySelector('#tab-vincularFamiliar form').submit();
    }
</script>
</body>
</html>