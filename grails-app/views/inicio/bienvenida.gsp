<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Inicio</title>
</head>
<body>
<div class="container mt-4">

    <h2>Bienvenido, ${usuario.nombreCompleto}</h2>
    <p class="text-muted">Rol: ${rol}</p>

    <g:if test="${flash.message}">
        <div class="alert alert-success">${flash.message}</div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alert alert-danger">${flash.error}</div>
    </g:if>

    <ul class="nav nav-tabs mt-4">
        <li class="nav-item">
            <a class="nav-link ${!flash.codigoGenerado ? 'active' : ''}" data-bs-toggle="tab" href="#inicio">Inicio</a>
        </li>
        <g:if test="${rol == 'ROLE_CUIDADOR'}">
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#crearPaciente">Crear Paciente</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${flash.codigoGenerado ? 'active' : ''}" data-bs-toggle="tab" href="#vincularFamiliar">Vincular Familiar</a>
            </li>
        </g:if>
    </ul>

    <div class="tab-content mt-4">

        <div class="tab-pane fade ${!flash.codigoGenerado ? 'show active' : ''}" id="inicio">
            <h4>Panel principal</h4>
            <p>Selecciona una opción del menú superior.</p>
        </div>

        <g:if test="${rol == 'ROLE_CUIDADOR'}">

            <div class="tab-pane fade" id="crearPaciente">
                <h4>Crear nuevo paciente</h4>
                <g:form controller="cuidador" action="crearPaciente" class="mt-3" style="max-width:500px;">
                    <div class="mb-3">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" name="nombre" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">DNI</label>
                        <input type="text" name="dni" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Fecha de nacimiento</label>
                        <input type="date" name="fechaNacimiento" class="form-control"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email (para el login del paciente)</label>
                        <input type="email" name="email" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" name="password" class="form-control" required/>
                    </div>
                    <button type="submit" class="btn btn-primary">Crear Paciente</button>
                </g:form>
            </div>

            <div class="tab-pane fade ${flash.codigoGenerado ? 'show active' : ''}" id="vincularFamiliar">
                <h4>Vincular nuevo familiar</h4>

                <g:if test="${flash.codigoGenerado}">
                    <div class="alert alert-success mt-3">
                        <h5>✅ Código generado correctamente</h5>
                        <p>Código: <strong style="font-size:1.4em; letter-spacing:3px;">${flash.codigoGenerado}</strong></p>
                        <p>Se enviará a: <strong>${flash.emailFamiliar}</strong></p>
                        <button type="button" class="btn btn-success mt-2" data-bs-toggle="modal" data-bs-target="#modalEnviar">
                            Enviar código por correo
                        </button>
                    </div>

                    <div class="modal fade" id="modalEnviar" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Confirmar envío</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p>¿Estás segura de enviar el código <strong>${flash.codigoGenerado}</strong> al correo <strong>${flash.emailFamiliar}</strong>?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <g:form controller="cuidador" action="enviarCodigo" style="display:inline;">
                                        <input type="hidden" name="codigo" value="${flash.codigoGenerado}"/>
                                        <input type="hidden" name="email" value="${flash.emailFamiliar}"/>
                                        <input type="hidden" name="nombre" value="${flash.nombreFamiliar}"/>
                                        <button type="submit" class="btn btn-success">Sí, enviar</button>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:if>

                <g:form controller="cuidador" action="generarCodigo" class="mt-4" style="max-width:500px;">
                    <h6 class="text-muted mb-3">Datos del familiar</h6>
                    <div class="mb-3">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" name="nombreFamiliar" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">DNI</label>
                        <input type="text" name="dniFamiliar" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="emailFamiliar" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" name="passwordFamiliar" class="form-control" required/>
                    </div>
                    <hr/>
                    <h6 class="text-muted mb-3">Paciente a vincular</h6>
                    <div class="mb-3">
                        <label class="form-label">Nombre completo del paciente</label>
                        <input type="text" name="nombrePaciente" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">DNI del paciente</label>
                        <input type="text" name="dniPaciente" class="form-control" required/>
                    </div>
                    <button type="submit" class="btn btn-primary">Generar Código</button>
                </g:form>
            </div>

        </g:if>
    </div>
</div>
</body>
</html>