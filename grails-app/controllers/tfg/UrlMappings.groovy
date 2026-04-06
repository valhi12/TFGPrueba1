package tfg

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "inicio", action: "bienvenida")
        "/login"(controller: "login", action: "index")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
