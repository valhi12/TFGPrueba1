# ---- Etapa de compilación ----
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copiar wrapper de Gradle primero (caché de capas)
COPY gradlew .
COPY gradle gradle
RUN chmod +x gradlew

# Copiar ficheros de configuración de build
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties gradle.properties

# Copiar código fuente
COPY grails-app grails-app
COPY src src

# Compilar solo el JAR ejecutable (bootJar en vez de assemble)
RUN ./gradlew bootJar --no-daemon -x test

# ---- Etapa de ejecución ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*-plain.jar app-plain.jar 2>/dev/null || true
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]