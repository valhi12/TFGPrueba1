package tfg

import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory
import org.springframework.boot.web.server.WebServerFactoryCustomizer
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class TomcatConfig {

    @Bean
    WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
        return { factory ->
            factory.addConnectorCustomizers({ connector ->
                connector.setMaxPostSize(52428800) // 50MB
            })
        }
    }
}