<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Mi Álbum</title>
    <asset:stylesheet src="paciente.css"/>
</head>
<body>

<div class="paciente-layout">

    <%-- MENÚ ETIQUETAS --%>
    <g:if test="${album}">
        <div class="etiquetas-menu">
            <h4>🏷️ Etiquetas</h4>
            <a href="${g.createLink(controller:'paciente', action:'bienvenida')}"
               class="etiqueta-item ${!etiquetaSeleccionada ? 'activa' : ''}">
                Todas
            </a>
            <g:each in="${etiquetas}" var="etiqueta">
                <a href="${g.createLink(controller:'paciente', action:'bienvenida', params:[etiqueta:etiqueta])}"
                   class="etiqueta-item ${etiquetaSeleccionada == etiqueta ? 'activa' : ''}">
                    ${etiqueta}
                </a>
            </g:each>
        </div>
    </g:if>

    <%-- CONTENIDO --%>
    <div class="paciente-contenido">

        <g:if test="${!album}">
            <div class="sin-album">
                <div class="icono">📷</div>
                <h3>Aún no hay álbum</h3>
                <p>Tu familia está preparando tu álbum de recuerdos. ¡Pronto estará listo!</p>
            </div>
        </g:if>

        <g:if test="${album}">

            <%-- PORTADA --%>
            <div id="vistaPortada">
                <div class="portada-card">
                    <g:if test="${album.portada}">
                        <img src="${g.createLink(controller:'paciente', action:'portada', id:album.id)}" alt="portada"/>
                    </g:if>
                    <g:else>
                        <div style="height:320px; background:var(--verde-suave); display:flex; align-items:center; justify-content:center; font-size:5rem;">📖</div>
                    </g:else>
                    <div class="portada-info">
                        <h2>${album.titulo}</h2>
                        <p>${recuerdos?.size() ?: 0} recuerdo(s)</p>
                        <g:if test="${recuerdos && recuerdos.size() > 0}">
                            <button class="btn-verde" onclick="comenzar()">Comenzar ▶</button>
                        </g:if>
                        <g:else>
                            <p style="color:#9b9088; font-style:italic;">No hay fotos en esta categoría.</p>
                        </g:else>
                    </div>
                </div>
            </div>

            <%-- VISOR --%>
            <div id="vistaVisor" style="display:none;">
                <div class="visor-wrapper">

                    <div class="visor-navegacion">
                        <button class="btn-flecha" id="btnAnterior" onclick="anterior()" disabled>◀</button>

                        <div class="tarjeta-container">
                            <div class="tarjeta-inner" id="tarjetaInner">
                                <div class="tarjeta-cara tarjeta-frente">
                                    <img id="fotoActual" src="" alt="recuerdo"/>
                                </div>
                                <div class="tarjeta-cara tarjeta-dorso">
                                    <div class="descripcion" id="descripcionActual"></div>
                                </div>
                            </div>
                        </div>

                        <button class="btn-flecha" id="btnSiguiente" onclick="siguiente()">▶</button>
                    </div>

                    <div class="visor-acciones">
                        <button class="btn-secundario-p" onclick="volverPortada()">← Volver al principio</button>
                        <span class="contador" id="contadorFotos"></span>
                        <button class="btn-verde" onclick="girar()">🔄 Girar</button>
                    </div>

                </div>
            </div>

        </g:if>
    </div>
</div>

<script type="text/javascript">
    var recuerdos = [
        <g:each in="${recuerdos}" var="r" status="i">
        {
            id: ${r.id},
            url: '${g.createLink(controller:"paciente", action:"foto", id:r.id)}',
            descripcion: '${r.texto?.replace("'", "\\'")?.replace("\n", " ") ?: ""}',
            fecha: '${r.fecha ? new java.text.SimpleDateFormat('dd/MM/yyyy').format(r.fecha) : ""}',
            etiqueta: '${r.etiqueta ?: ""}'
        }${i < recuerdos.size() - 1 ? ',' : ''}
        </g:each>
    ];

    var indiceActual = 0;
    var girada = false;

    function comenzar() {
        indiceActual = 0;
        girada = false;
        document.getElementById('tarjetaInner').classList.remove('girada');
        document.getElementById('vistaPortada').style.display = 'none';
        document.getElementById('vistaVisor').style.display = 'block';
        mostrarRecuerdo();
    }

    function mostrarRecuerdo() {
        var r = recuerdos[indiceActual];
        document.getElementById('fotoActual').src = r.url;
        document.getElementById('descripcionActual').textContent = r.descripcion || 'Sin descripción';
        document.getElementById('contadorFotos').textContent = (indiceActual + 1) + ' / ' + recuerdos.length;

        var btnAnt = document.getElementById('btnAnterior');
        var btnSig = document.getElementById('btnSiguiente');

        btnAnt.disabled = false;
        btnSig.disabled = false;

        if (indiceActual === 0) btnAnt.disabled = true;
        if (indiceActual === recuerdos.length - 1) btnSig.disabled = true;

        girada = false;
        document.getElementById('tarjetaInner').classList.remove('girada');
    }

    function siguiente() {
        if (indiceActual < recuerdos.length - 1) {
            indiceActual++;
            mostrarRecuerdo();
        }
    }

    function anterior() {
        if (indiceActual > 0) {
            indiceActual--;
            mostrarRecuerdo();
        }
    }

    function girar() {
        girada = !girada;
        var inner = document.getElementById('tarjetaInner');
        if (girada) {
            inner.classList.add('girada');
        } else {
            inner.classList.remove('girada');
        }
    }

    function volverPortada() {
        document.getElementById('vistaVisor').style.display = 'none';
        document.getElementById('vistaPortada').style.display = 'block';
        girada = false;
        document.getElementById('tarjetaInner').classList.remove('girada');
    }
</script>

</body>
</html>