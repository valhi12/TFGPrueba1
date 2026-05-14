package tfg

//Clase que define el mapeo de URLs a controladores y acciones de la aplicación

class UrlMappings {

    //Bloque principal donde se declaran todas las rutas de la aplicación
    static mappings = {
        //Esta línea permite que todas las páginas funcionen automáticamente
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        //Esta línea hace que al entrar a la web, se abra tu Login
        "/"(controller: "login", action: "index")

        //Páginas de error estándar
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}