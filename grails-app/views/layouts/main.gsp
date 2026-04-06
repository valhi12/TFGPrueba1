<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><g:layoutTitle default="Mi Álbum de Recuerdos"/></title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="registro.css"/>
</head>
<body>

    <nav class="navbar navbar-dark bg-primary px-3">
        <span class="navbar-brand mb-0 h1">Mi Álbum de Recuerdos</span>
        <g:if test="${session.usuario}">
            <g:link controller="inicio" action="logout" class="btn btn-outline-light btn-sm">
                Cerrar sesión
            </g:link>
        </g:if>
    </nav>

    <g:layoutBody/>

    <div class="footer" role="contentinfo">
        <div class="container">
            <p style="text-align: center">&copy; 2026 - Mi TFG de Recuerdos Familiares</p>
        </div>
    </div>

    <asset:javascript src="application.js"/>
</body>
</html>