# Imagen base con Java 17
FROM eclipse-temurin:17-jdk-focal

# Carpeta de trabajo dentro de Docker
WORKDIR /app

# Copiamos todos tus archivos al contenedor
COPY . .

# Damos permisos y preparamos el ejecutable
RUN chmod +x gradlew

# Exponemos el puerto de la aplicación
EXPOSE 8080

# Comando para arrancar Grails
CMD ["./gradlew", "bootRun"]