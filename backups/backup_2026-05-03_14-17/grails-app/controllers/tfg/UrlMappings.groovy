package tfg

class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints { }
        }
        "/"(controller: "inicio", action: "bienvenida")
        "/login"(controller: "login", action: "index")
        "/familiar/$action?"(controller: "familiar")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}