<!doctype html>
<html lang="es" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Mi Álbum de Recuerdos"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>
</head>

<body>

    <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #007bff; margin-bottom: 20px;">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">Mi Álbum de Recuerdos</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav ms-auto">
                    </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <g:layoutBody/>
    </div>

    <div class="footer" role="contentinfo" style="text-align: center; padding: 20px; color: #999; margin-top: 50px; border-top: 1px solid #eee;">
        © 2026 - Mi TFG de Recuerdos Familiares
    </div>

    <asset:javascript src="application.js"/>

</body>
</html>