# Trabajo de Fin de Grado - Valeria Hidalgo Aguilar

Este repositorio contiene el prototipo funcional de la aplicación web diseñada para la **gestión y comunicación entre cuidadores y familiares**, desarrollada como Trabajo de Fin de Grado.

---

## Arquitectura del Sistema

El entorno de este prototipo funciona mediante una arquitectura mixta (ejecución local + contenedores Docker) dividida en los siguientes servicios:

*   **Backend (Grails):** Aplicación principal desarrollada con el framework **Grails** sobre **Java 17**. Gestiona la lógica de negocio, las vistas (GSP) y la conexión con la base de datos mediante GORM/Hibernate.
*   **DB (tfg-db):** Motor de base de datos **MySQL 8.0** en contenedor Docker. Utiliza volúmenes locales (`./mysql-data`) para garantizar la persistencia de los datos entre reinicios.
*   **Gestor BD (tfg-adminer):** Cliente web ligero basado en **Adminer** contenerizado, diseñado para la consulta directa y verificación de la base de datos sin necesidad de instalar clientes SQL externos.

---

## Requisitos Previos

Para desplegar y evaluar el prototipo en un entorno local, es estrictamente necesario contar con:

*   [ ] **Java Development Kit (JDK) 17** instalado en el sistema.
*   [ ] **Docker Desktop** instalado y en ejecución.
*   [ ] **Terminal de comandos** (PowerShell, CMD, o Bash).

---

##  Guía de Arranque Paso a Paso

Sigue estas instrucciones en el terminal para levantar el entorno completo "end-to-end":

### 1. Preparación y Variables de Envornot
La conexión entre el backend y la base de datos ya está preconfigurada en el archivo `grails-app/conf/application.yml`. No es necesario crear archivos `.env` externos.

*   **Base de datos:** `tfg_db`
*   **Usuario:** `root`
*   **Contraseña:** `admin`

### 2. Levantar la Infraestructura (Docker)
Abre un terminal en la carpeta raíz del proyecto y ejecuta el siguiente comando:

```bash
docker-compose up -d
```

> **Nota:** Si es la primera vez que se ejecuta, Docker tardará unos instantes en descargar las imágenes de MySQL y Adminer.

---

### 3. Arranque del Backend

En el mismo terminal, compila y lanza la aplicación Grails mediante su wrapper integrado.

**Si usas Windows:**
```powershell
.\gradlew.bat bootRun
```

**Si usas Mac/Linux:**
```bash
./gradlew bootRun
```
> El servidor estará listo cuando la consola muestre el mensaje: `Grails application running at http://localhost:8080`.

---

##  Puertos y Accesos

| Servicio | URL Local | Puerto Externo | Puerto Interno |
| :--- | :--- | :---: | :---: |
| **Aplicación Web (Grails)** | [http://localhost:8080](http://localhost:8080) | 8080 | N/A |
| **Gestor de BD (Adminer)** | [http://localhost:8081](http://localhost:8081) | 8081 | 8080 |
| **Base de Datos (MySQL)** | `127.0.0.1` | 3307 | 3306 |

---

##  Guía de Verificación y Pruebas

A continuación se demuestran las funcionalidades básicas que certifican el correcto flujo entre el **Frontend**, el **Backend** y la **persistencia** en Base de Datos.

### Prueba 1: Registro de usuario y validación de seguridad
Se verifica que el sistema gestiona correctamente los roles y exige el código de vinculación para los familiares, deteniendo el registro en caso de ausencia.

*El sistema detiene el registro si falta el código de vinculación.*

*Confirmación de cuenta creada con datos correctos.*

### Prueba 2: Persistencia en Base de Datos (End-to-End)
Accediendo a **Adminer** (`http://localhost:8081` -> Servidor: `tfg-db` | Usuario: `root` | Pass: `admin`), se comprueba que el usuario recién registrado se ha guardado correctamente en la tabla `usuario` de la base de datos `tfg_db`.

### Prueba 3: Autenticación (Login)
Utilizando las credenciales del usuario almacenado en el paso anterior, el sistema autentica correctamente la sesión y redirige al panel principal.
