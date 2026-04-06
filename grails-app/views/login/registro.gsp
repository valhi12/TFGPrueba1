<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Registro - Mi TFG</title>
</head>
<body>
    <div class="card-registro">
        <h2 style="text-align:center; color:#333;">Crea tu cuenta</h2>
        <p style="text-align:center; color:#666; margin-bottom:20px;">Únete al círculo de cuidado</p>

        <g:if test="${flash.message}">
            <div style="background:#ffe6e6; color:#cc0000; padding:10px; border-radius:5px; margin-bottom:15px;">
                ${flash.message}
            </div>
        </g:if>

        <g:form action="guardarRegistro" id="formRegistro">
            <label>Nombre Completo</label>
            <input type="text" name="nombre" class="form-control" placeholder="Tu nombre y apellidos" required/>

            <label>Email</label>
            <input type="email" name="email" class="form-control" placeholder="ejemplo@correo.com" required/>

            <label>Contraseña</label>
            <input type="password" name="password" class="form-control" placeholder="Mínimo 6 caracteres" required/>

            <hr style="margin:25px 0;"/>
            <h5 style="margin-bottom:15px;">¿Cómo vas a usar la app?</h5>

            <div class="opcion-registro">
                <label style="cursor:pointer; width:100%; margin:0; display:block;">
                    <input type="radio" id="radioCuidador" name="tipoRegistro" value="CUIDADOR" checked
                           onclick="document.getElementById('divCodigo').classList.add('hidden')">
                    <strong style="margin-left:10px;">Soy Cuidador</strong>
                    <p style="margin-left:25px; font-size:0.85em; color:#777;">Crearé un nuevo círculo para un paciente.</p>
                </label>
            </div>

            <div class="opcion-registro">
                <label style="cursor:pointer; width:100%; margin:0; display:block;">
                    <input type="radio" id="radioFamiliar" name="tipoRegistro" value="FAMILIAR"
                           onclick="document.getElementById('divCodigo').classList.remove('hidden')">
                    <strong style="margin-left:10px;">Soy Familiar</strong>
                    <p style="margin-left:25px; font-size:0.85em; color:#777;">Tengo un código para unirme a un grupo existente.</p>
                </label>
            </div>

            <div id="divCodigo" class="hidden" style="margin-top:15px; background:#fff9e6; padding:15px; border-radius:8px;">
                <label>Introduce el Código Familiar</label>
                <input type="text" id="inputCodigo" name="codigo" class="form-control" placeholder="Ej: ABC12345"/>
            </div>

            <div style="margin-top:25px; font-size:0.9em;">
                <label style="cursor:pointer;">
                    <input type="checkbox" required> Acepto los términos y la política de privacidad.
                </label>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top:20px; padding:10px; font-size:1.1em;">
                Finalizar Registro
            </button>
        </g:form>
    </div>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formRegistro');
            form.onsubmit = function(e) {
                const esFamiliar = document.getElementById('radioFamiliar').checked;
                const codigo = document.getElementById('inputCodigo').value.trim();
                if (esFamiliar && codigo === "") {
                    e.preventDefault();
                    alert("¡Atención! No puedes registrarte como Familiar sin introducir el código de tu familia.");
                    document.getElementById('inputCodigo').focus();
                    return false;
                }
                return true;
            };
        });
    </script>
</body>
</html>