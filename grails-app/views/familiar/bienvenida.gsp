<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Mi Álbum</title>
    <asset:stylesheet src="familiar.css"/>
    <asset:stylesheet src="cuidador.css"/>
</head>
<body>
<div class="app-wrapper">

    <h1 class="bienvenida-titulo">Hola, ${usuario.nombreCompleto} 👋</h1>

    <g:if test="${flash.message}">
        <div class="alerta-success">${flash.message}</div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alerta-error">${flash.error}</div>
    </g:if>

    <div class="tabs-nav">
        <button class="tab-btn activo" onclick="cambiarTab('inicio', this)">🏠 Inicio</button>
        <button class="tab-btn" onclick="cambiarTab('album', this)" id="btnTabAlbum">📖 Álbum</button>
    </div>

    <div class="tab-contenido">

        <!-- TAB INICIO -->
        <div id="tab-inicio" class="tab-pane activo">
            <div class="inicio-banner">
                <div class="banner-icono">📸</div>
                <div>
                    <h3>El álbum de recuerdos</h3>
                    <p>Aquí puedes construir el álbum de recuerdos de tu familiar. Añade fotos, descripciones y fechas para que cada momento quede guardado con cariño.</p>
                </div>
            </div>
            <div class="inicio-grid" style="margin-top:24px;">
                <div class="inicio-card">
                    <div class="card-icono">🖼️</div>
                    <h4>Añadir fotos</h4>
                    <p>Sube imágenes del pasado con su descripción y fecha para construir el álbum.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">🏷️</div>
                    <h4>Clasificar recuerdos</h4>
                    <p>Organiza los recuerdos por etiquetas: Familia, Juventud, Viajes y más.</p>
                </div>
                <div class="inicio-card">
                    <div class="card-icono">📅</div>
                    <h4>Línea temporal</h4>
                    <p>Los recuerdos se ordenan cronológicamente para revivir la historia paso a paso.</p>
                </div>
            </div>
        </div>

        <!-- TAB ÁLBUM -->
        <div id="tab-album" class="tab-pane">

            <%-- ESTADO 1: Sin álbum --%>
            <g:if test="${!album}">
                <div id="cardVacio" class="album-vacio-card">
                    <div class="album-vacio-icono">📸</div>
                    <div>
                        <h3>Aún no hay álbum</h3>
                        <p>Crea el álbum de recuerdos de tu familiar. Podrás añadir fotos, descripciones, fechas y etiquetas.</p>
                        <button class="btn-primario" style="margin-top:16px;"
                                onclick="mostrarEstado('estadoCrear')">
                            ➕ Crear álbum
                        </button>
                    </div>
                </div>

                <div id="estadoCrear" style="display:none;">
                    <div class="form-seccion">
                        <h4>📖 Crear álbum</h4>
                        <g:form controller="familiar" action="crearAlbum" enctype="multipart/form-data" id="formAlbum">

                            <div class="campo" style="margin-bottom:24px; max-width:500px;">
                                <label>Título del álbum</label>
                                <input type="text" id="tituloAlbum" name="titulo"
                                       placeholder="Ej: Los recuerdos de Abuelo Luis"
                                       style="width:100%; padding:11px 16px; border:1.5px solid #dde8db; border-radius:10px; font-family:'Nunito',sans-serif; font-size:0.95rem; background:var(--verde-suave); outline:none;"/>
                            </div>

                            <%-- FOTO DE PORTADA --%>
                            <div style="margin-bottom:24px;">
                                <p class="form-subtitulo">Foto de portada</p>
                                <div style="background:#e8f2e6; border:1.5px dashed #a8c5a0; border-radius:12px; padding:20px 24px; max-width:500px;">
                                    <p style="font-size:0.85rem; color:#6b5e52; margin-bottom:12px;">🖼️ Esta imagen aparecerá como portada de tu álbum. No lleva descripción ni fecha.</p>
                                    <label style="display:inline-flex; align-items:center; gap:8px; cursor:pointer; background:var(--blanco-roto); border:1.5px solid rgba(168,197,160,0.4); border-radius:10px; padding:10px 18px; font-family:'Nunito',sans-serif; font-size:0.92rem; font-weight:600; color:#6b5e52;">
                                        📷 Seleccionar foto de portada
                                        <input type="file" name="portada" id="inputPortada" accept="image/*" style="display:none;" onchange="previsualizarPortada(this)"/>
                                    </label>
                                    <div id="prevPortada" style="margin-top:12px; display:none;">
                                        <img id="imgPortada" style="width:120px; height:120px; object-fit:cover; border-radius:10px; border:2px solid rgba(168,197,160,0.4);"/>
                                    </div>
                                </div>
                            </div>

                            <%-- FOTOS CON DESCRIPCIÓN --%>
                            <p class="form-subtitulo">Fotos del álbum</p>
                            <div id="listaFotos" style="display:flex; flex-direction:column; gap:8px; margin-bottom:20px;"></div>
                            <div style="margin-bottom:24px;">
                                <label style="display:inline-flex; align-items:center; gap:8px; cursor:pointer; background:var(--verde-suave); border:1.5px solid rgba(168,197,160,0.4); border-radius:10px; padding:10px 18px; font-family:'Nunito',sans-serif; font-size:0.92rem; font-weight:600; color:#6b5e52;">
                                    ➕ Añadir foto
                                    <input type="file" id="inputFotoNueva" accept="image/*" style="display:none;" onchange="anadirFoto(this)"/>
                                </label>
                            </div>

                            <div class="form-acciones">
                                <button type="button" onclick="mostrarEstado('cardVacio')" class="btn-secundario">Cancelar</button>
                                <button type="submit" class="btn-primario">Crear Álbum</button>
                            </div>
                        </g:form>
                    </div>
                </div>
            </g:if>

            <%-- ESTADO 2: Álbum existente --%>
            <g:if test="${album}">

                <div id="vistaAlbum">
                    <div class="album-portada">
                        <div style="display:flex; align-items:center; gap:20px;">
                            <g:if test="${album.portada}">
                                <img src="${g.createLink(controller:'familiar', action:'portada', id:album.id)}"
                                     style="width:80px; height:80px; object-fit:cover; border-radius:12px; border:2px solid rgba(168,197,160,0.3);"/>
                            </g:if>
                            <g:else>
                                <div class="album-portada-icono">📖</div>
                            </g:else>
                            <div class="album-portada-info">
                                <h3>${album.titulo}</h3>
                                <p>${album.recuerdos?.size() ?: 0} recuerdo(s) · Creado el ${album.fechaCreacion ? new java.text.SimpleDateFormat('dd/MM/yyyy').format(album.fechaCreacion) : ''}</p>
                            </div>
                        </div>
                        <div style="display:flex; gap:10px;">
                            <button class="btn-lapiz" onclick="mostrarEstado('vistaEditar')">✏️ Editar álbum</button>
                            <g:form controller="familiar" action="eliminarAlbum" style="margin:0;">
                                <button type="submit" class="btn-lapiz"
                                        style="border-color:#f5c6c2; color:#c0392b; background:#fdecea;"
                                        onclick="return confirm('¿Estás segura de eliminar el álbum completo? Se perderán todos los recuerdos.')">
                                    🗑️ Eliminar álbum
                                </button>
                            </g:form>
                        </div>
                    </div>
                </div>

                <div id="vistaEditar" style="display:none;">
                    <div class="form-seccion">
                        <h4>✏️ Editar álbum</h4>
                        <g:form controller="familiar" action="guardarCambios" enctype="multipart/form-data" id="formEditar">

                            <div style="margin-bottom:24px;">
                                <p class="form-subtitulo">Foto de portada</p>
                                <div style="display:flex; align-items:center; gap:16px; background:#e8f2e6; border:1.5px dashed #a8c5a0; border-radius:12px; padding:16px 20px; max-width:500px;">
                                    <g:if test="${album.portada}">
                                        <img src="${g.createLink(controller:'familiar', action:'portada', id:album.id)}"
                                             id="imgPortadaEdit"
                                             style="width:80px; height:80px; object-fit:cover; border-radius:10px; border:2px solid rgba(168,197,160,0.3); flex-shrink:0;"/>
                                    </g:if>
                                    <div>
                                        <p style="font-size:0.82rem; color:#6b5e52; margin-bottom:8px;">Puedes cambiar la foto de portada seleccionando una nueva imagen.</p>
                                        <label style="display:inline-flex; align-items:center; gap:8px; cursor:pointer; background:var(--blanco-roto); border:1.5px solid rgba(168,197,160,0.4); border-radius:10px; padding:8px 14px; font-family:'Nunito',sans-serif; font-size:0.88rem; font-weight:600; color:#6b5e52;">
                                            📷 Cambiar portada
                                            <input type="file" name="portada" accept="image/*" style="display:none;"
                                                   onchange="document.getElementById('imgPortadaEdit').src = URL.createObjectURL(this.files[0])"/>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <p class="form-subtitulo">Fotos del álbum</p>
                            <div style="display:flex; flex-direction:column; gap:8px; margin-bottom:20px;">
                                <g:each in="${album.recuerdos?.sort { it.fecha }}" var="recuerdo">
                                    <div style="display:flex; align-items:flex-start; gap:16px; background:#fdfdfa; border:1px solid rgba(168,197,160,0.3); border-radius:14px; padding:16px 20px;">
                                        <img src="${g.createLink(controller:'familiar', action:'foto', id:recuerdo.id)}"
                                             style="width:90px; height:90px; object-fit:cover; border-radius:10px; border:2px solid rgba(168,197,160,0.3); flex-shrink:0;"/>
                                        <div style="flex:1; display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                            <div style="grid-column:1/-1;">
                                                <label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Descripción</label>
                                                <textarea name="texto_recuerdo_${recuerdo.id}" rows="2" style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:'Nunito',sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;resize:vertical;">${recuerdo.texto}</textarea>
                                            </div>
                                            <div>
                                                <label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Fecha</label>
                                                <input type="date" name="fecha_recuerdo_${recuerdo.id}"
                                                       value="${recuerdo.fecha ? new java.text.SimpleDateFormat('yyyy-MM-dd').format(recuerdo.fecha) : ''}"
                                                       style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:'Nunito',sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;"/>
                                            </div>
                                            <div>
                                                <label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Etiqueta</label>
                                                <select name="etiqueta_recuerdo_${recuerdo.id}" style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:'Nunito',sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;">
                                                    <option value="Familia" ${recuerdo.etiqueta == 'Familia' ? 'selected' : ''}>Familia</option>
                                                    <option value="Juventud" ${recuerdo.etiqueta == 'Juventud' ? 'selected' : ''}>Juventud</option>
                                                    <option value="Viajes" ${recuerdo.etiqueta == 'Viajes' ? 'selected' : ''}>Viajes</option>
                                                    <option value="Trabajo" ${recuerdo.etiqueta == 'Trabajo' ? 'selected' : ''}>Trabajo</option>
                                                    <option value="Celebraciones" ${recuerdo.etiqueta == 'Celebraciones' ? 'selected' : ''}>Celebraciones</option>
                                                    <option value="Infancia" ${recuerdo.etiqueta == 'Infancia' ? 'selected' : ''}>Infancia</option>
                                                    <option value="Otros" ${recuerdo.etiqueta == 'Otros' ? 'selected' : ''}>Otros</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Cambiar foto (opcional)</label>
                                                <input type="file" name="foto_recuerdo_${recuerdo.id}" accept="image/*"
                                                       style="background:#e8f2e6; padding:6px; border:1.5px solid #dde8db; border-radius:10px; width:100%; font-size:0.85rem;"/>
                                            </div>
                                        </div>
                                        <a href="${g.createLink(controller:'familiar', action:'eliminarRecuerdo', params:[id:recuerdo.id])}"
                                            style="background:none;border:none;font-size:1.2rem;cursor:pointer;color:#c0392b;padding:4px;flex-shrink:0;align-self:flex-start;text-decoration:none;"
                                            onclick="return confirm('¿Eliminar este recuerdo?')">🗑️
                                        </a>
                                    </div>
                                </g:each>
                            </div>

                            <div id="listaFotosNuevas" style="display:flex; flex-direction:column; gap:8px; margin-bottom:20px;"></div>
                            <div style="margin-bottom:24px;">
                                <label style="display:inline-flex; align-items:center; gap:8px; cursor:pointer; background:var(--verde-suave); border:1.5px solid rgba(168,197,160,0.4); border-radius:10px; padding:10px 18px; font-family:'Nunito',sans-serif; font-size:0.92rem; font-weight:600; color:#6b5e52;">
                                    ➕ Añadir nueva foto
                                    <input type="file" id="inputFotoNuevaEdit" accept="image/*" style="display:none;" onchange="anadirFotoEdicion(this)"/>
                                </label>
                            </div>

                            <div class="form-acciones">
                                <button type="button" onclick="window.location.reload()" class="btn-secundario">Cancelar</button>
                                <button type="submit" class="btn-primario">Guardar cambios</button>
                            </div>
                        </g:form>
                    </div>
                </div>

            </g:if>
        </div>
    </div>
</div>

<script type="text/javascript">
    function cambiarTab(nombre, btn) {
        document.querySelectorAll('.tab-pane').forEach(function(p) { p.classList.remove('activo'); });
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('activo'); });
        document.getElementById('tab-' + nombre).classList.add('activo');
        btn.classList.add('activo');
    }

    function mostrarEstado(id) {
        var ids = ['cardVacio', 'estadoCrear', 'vistaAlbum', 'vistaEditar'];
        ids.forEach(function(i) {
            var el = document.getElementById(i);
            if (el) el.style.display = 'none';
        });
        var target = document.getElementById(id);
        if (target) target.style.display = (id === 'cardVacio') ? 'flex' : 'block';
    }

    function comprimirImagen(archivo, callback) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var img = new Image();
            img.onload = function() {
                var canvas = document.createElement('canvas');
                var maxW = 800;
                var ratio = Math.min(maxW / img.width, 1);
                canvas.width = img.width * ratio;
                canvas.height = img.height * ratio;
                var ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                canvas.toBlob(function(blob) {
                    var archivoComprimido = new File([blob], archivo.name, { type: 'image/jpeg' });
                    callback(e.target.result, archivoComprimido);
                }, 'image/jpeg', 0.6);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(archivo);
    }

    function previsualizarPortada(input) {
        if (!input.files || !input.files[0]) return;
        var archivo = input.files[0];
        comprimirImagen(archivo, function(imgSrc, archivoComprimido) {
            document.getElementById('imgPortada').src = imgSrc;
            document.getElementById('prevPortada').style.display = 'block';
            var dt = new DataTransfer();
            dt.items.add(archivoComprimido);
            input.files = dt.files;
        });
    }

    var numFotos = 0;
    function anadirFoto(input) {
        if (!input.files || !input.files[0]) return;
        var archivo = input.files[0];
        var indice = numFotos;
        numFotos++;
        comprimirImagen(archivo, function(imgSrc, archivoComprimido) {
            var card = crearCardFoto(imgSrc, archivoComprimido, indice, 'listaFotos', 'fotos');
            document.getElementById('listaFotos').appendChild(card);
        });
        input.value = '';
    }

    var numFotosNuevas = 0;
    function anadirFotoEdicion(input) {
        if (!input.files || !input.files[0]) return;
        var archivo = input.files[0];
        var indice = numFotosNuevas;
        numFotosNuevas++;
        comprimirImagen(archivo, function(imgSrc, archivoComprimido) {
            var card = crearCardFoto(imgSrc, archivoComprimido, indice, 'listaFotosNuevas', 'fotos_nuevas', true);
            document.getElementById('listaFotosNuevas').appendChild(card);
        });
        input.value = '';
    }

    function crearCardFoto(imgSrc, archivo, indice, listaId, nombreInput, esEdicion) {
        var prefijo = esEdicion ? 'nueva_' : '';
        var card = document.createElement('div');
        card.id = 'foto-card-' + listaId + '-' + indice;
        card.style.cssText = 'display:flex;align-items:flex-start;gap:16px;background:#fdfdfa;border:1px solid rgba(168,197,160,0.3);border-radius:14px;padding:16px 20px;margin-bottom:8px;';

        var img = document.createElement('img');
        img.src = imgSrc;
        img.style.cssText = 'width:90px;height:90px;object-fit:cover;border-radius:10px;border:2px solid rgba(168,197,160,0.3);flex-shrink:0;';

        var contenido = document.createElement('div');
        contenido.style.cssText = 'flex:1;display:grid;grid-template-columns:1fr 1fr;gap:12px;';

        var d1 = document.createElement('div');
        d1.style.cssText = 'grid-column:1/-1;';
        d1.innerHTML = '<label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Descripcion</label>' +
            '<textarea name="texto_' + prefijo + indice + '" rows="2" placeholder="Describe este recuerdo..." style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:Nunito,sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;resize:vertical;"></textarea>';

        var d2 = document.createElement('div');
        d2.innerHTML = '<label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Fecha</label>' +
            '<input type="date" name="fecha_' + prefijo + indice + '" style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:Nunito,sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;"/>';

        var d3 = document.createElement('div');
        d3.innerHTML = '<label style="display:block;font-size:0.8rem;font-weight:600;color:#6b5e52;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.4px;">Etiqueta</label>' +
            '<select name="etiqueta_' + prefijo + indice + '" style="width:100%;padding:10px 14px;border:1.5px solid #dde8db;border-radius:10px;font-family:Nunito,sans-serif;font-size:0.92rem;background:#e8f2e6;outline:none;">' +
            '<option value="Familia">Familia</option><option value="Juventud">Juventud</option>' +
            '<option value="Viajes">Viajes</option><option value="Trabajo">Trabajo</option>' +
            '<option value="Celebraciones">Celebraciones</option><option value="Infancia">Infancia</option>' +
            '<option value="Otros">Otros</option></select>';

        contenido.appendChild(d1);
        contenido.appendChild(d2);
        contenido.appendChild(d3);

        var fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.name = nombreInput;
        fileInput.style.display = 'none';
        var dt = new DataTransfer();
        dt.items.add(archivo);
        fileInput.files = dt.files;

        var btn = document.createElement('button');
        btn.type = 'button';
        btn.innerHTML = '\uD83D\uDDD1\uFE0F';
        btn.style.cssText = 'background:none;border:none;font-size:1.2rem;cursor:pointer;color:#c0392b;padding:4px;flex-shrink:0;align-self:flex-start;';
        var cardId = card.id;
        btn.onclick = function() { document.getElementById(cardId).remove(); };

        card.appendChild(img);
        card.appendChild(contenido);
        card.appendChild(fileInput);
        card.appendChild(btn);
        return card;
    }

    window.addEventListener('DOMContentLoaded', function() {
        var tieneAlbum = ${album ? 'true' : 'false'};
        var hayMensaje = ${flash.message ? 'true' : 'false'};
        if (tieneAlbum || hayMensaje) {
            document.getElementById('btnTabAlbum').click();
        }
    });
</script>
</body>
</html>