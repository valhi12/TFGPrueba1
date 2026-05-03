# Bitácora de Incidencias — Mi Álbum de Recuerdos

Registro cronológico de todos los errores encontrados durante el desarrollo del proyecto, con su causa y solución aplicada.

---

## INC-01 — `codigo_unico cannot be null` al crear paciente

- **Fecha:** Abril 2026
- **Síntoma:** Al intentar crear un paciente desde el panel del cuidador, el servidor devolvía error SQL: `Column 'codigo_unico' cannot be null`.
- **Causa:** La tabla `paciente` en MySQL se había creado inicialmente con `codigo_unico NOT NULL`. Aunque el dominio Groovy tenía `nullable: true`, MySQL no regeneró la columna automáticamente.
- **Solución aplicada:** Ejecutar en Adminer: `ALTER TABLE paciente MODIFY COLUMN codigo_unico VARCHAR(255) NULL` para cambiar la columna a nullable sin perder datos.
- **Estado:** Resuelto

---

## INC-02 — `Date.parse()` en Groovy no acepta formato como parámetro

- **Fecha:** Abril 2026
- **Síntoma:** Al intentar crear un paciente con fecha de nacimiento, el servidor lanzaba un error en la línea `Date.parse('yyyy-MM-dd', params.fechaNacimiento)`.
- **Causa:** En Groovy, `Date.parse()` no acepta un formato como primer parámetro igual que en Java.
- **Solución aplicada:** Sustituir por `new java.text.SimpleDateFormat('yyyy-MM-dd').parse(params.fechaNacimiento)`.
- **Estado:** Resuelto

---

## INC-03 — `TransactionRequiredException` en `generarCodigo`

- **Fecha:** Abril 2026
- **Síntoma:** Al pulsar "Generar Código" salía el error: `jakarta.persistence.TransactionRequiredException: no transaction is in progress`.
- **Causa:** El método `generarCodigo` hacía un `.save(flush: true)` en una `Invitacion` sin estar dentro de un bloque de transacción.
- **Solución aplicada:** Envolver el método en `Invitacion.withTransaction { ... }`.
- **Estado:** Resuelto

---

## INC-04 — `return` dentro de `withTransaction` no sale del método

- **Fecha:** Abril 2026
- **Síntoma:** El registro de usuarios funcionaba de forma errática: a veces no redirigía, a veces daba errores silenciosos.
- **Causa:** En Groovy, el `return` dentro de un closure (como `withTransaction`) solo sale del closure, no del método controlador. La ejecución continuaba después del bloque causando comportamientos inesperados.
- **Solución aplicada:** Reestructurar el `LoginController` extrayendo la lógica a métodos privados `registrarFamiliar()` y `registrarCuidador()`, eliminando la dependencia de `return` dentro de closures.
- **Estado:** Resuelto

---

## INC-05 — Error 404 en `CuidadorController`

- **Fecha:** Abril 2026
- **Síntoma:** Al enviar el formulario de crear paciente aparecía Error 404 en `/cuidador/crearPaciente`.
- **Causa:** El fichero `CuidadorController.groovy` no estaba guardado en la ruta correcta o el servidor no se había reiniciado tras crearlo.
- **Solución aplicada:** Verificar que el fichero existe en `grails-app/controllers/tfg/CuidadorController.groovy` y reiniciar el servidor.
- **Estado:** Resuelto

---

## INC-06 — Error 413 Payload Too Large al subir imágenes

- **Fecha:** Abril 2026
- **Síntoma:** Al intentar subir fotografías al álbum, el servidor devolvía error 413 y la conexión se reseteaba.
- **Causa:** Tomcat tiene un límite de 128KB por defecto para peticiones multipart. Las fotografías superaban ese límite.
- **Solución aplicada:** Compresión de imágenes en el navegador con Canvas API (máximo 800px, calidad 0.6) antes de enviarlas. Configuración de `max-file-size` y `max-request-size` en `application.yml` y creación de la clase `TomcatConfig.groovy` con `setMaxPostSize(-1)`.
- **Estado:** Resuelto

---

## INC-07 — `EntityNotFoundException`: deleted object would be re-saved by cascade

- **Fecha:** Abril 2026
- **Síntoma:** Al intentar eliminar un álbum, Hibernate lanzaba `EntityNotFoundException`.
- **Causa:** Al borrar el álbum, Hibernate intentaba re-guardar los recuerdos asociados porque la colección seguía referenciándolos en memoria.
- **Solución aplicada:** Borrar los recuerdos explícitamente con `Recuerdo.findAllByAlbum(album)` antes de borrar el álbum, y limpiar la colección con `album.recuerdos?.clear()`.
- **Estado:** Resuelto

---

## INC-08 — `SQLIntegrityConstraintViolationException` al eliminar paciente

- **Fecha:** Abril 2026
- **Síntoma:** Al eliminar la cuenta de un paciente, MySQL lanzaba error de clave foránea.
- **Causa:** La tabla `invitacion` tiene una FK hacia `paciente` que no se eliminaba antes de borrar el paciente.
- **Solución aplicada:** Añadir `Invitacion.findAllByPaciente(paciente).each { it.delete(flush: true) }` antes de borrar el paciente.
- **Estado:** Resuelto

---

## INC-09 — El JavaScript de `familiar.js` no se actualizaba por caché

- **Fecha:** Abril 2026
- **Síntoma:** Los cambios realizados en `familiar.js` no se reflejaban en el navegador aunque se reiniciara el servidor.
- **Causa:** El asset pipeline de Grails cachea los ficheros JS en compilación.
- **Solución aplicada:** Mover el JavaScript directamente al GSP como código inline con `<script>`, eliminando la dependencia del fichero externo. Para el JS con template literals que Grails interpreta como Groovy, moverlo a un fichero `.js` externo que el GSP no procesa.
- **Estado:** Resuelto

---

## INC-10 — GSP interpreta `${}` dentro de bloques `<script>` como Groovy

- **Fecha:** Abril 2026
- **Síntoma:** Al usar template literals de JavaScript con `${e.target.result}` dentro de un GSP, el servidor lanzaba error porque Grails intentaba evaluar la expresión como código Groovy.
- **Causa:** Grails procesa todas las expresiones `${}` en ficheros `.gsp`, incluso las que están dentro de bloques `<script>`.
- **Solución aplicada:** Mover el JavaScript que contiene template literals o expresiones con `${}` a un fichero `.js` externo donde Grails no lo procesa, y referenciar ese fichero con `<asset:javascript src="familiar.js"/>`.
- **Estado:** Resuelto

---

## INC-11 — Formularios anidados rompían el submit

- **Fecha:** Abril 2026
- **Síntoma:** El botón de guardar cambios del formulario de edición no hacía nada al pulsarlo.
- **Causa:** HTML no permite formularios anidados. Un `<g:form>` anidado dentro de otro formulario rompía silenciosamente el DOM.
- **Solución aplicada:** Sustituir el `<g:form>` de eliminar por un enlace `<a href>` con `g.createLink()`.
- **Estado:** Resuelto

---

## INC-12 — `<g:form>` no conservaba el `id` del formulario

- **Fecha:** Abril 2026
- **Síntoma:** Al llamar a `document.getElementById('formCrearPaciente').submit()` desde JavaScript, el método devolvía null y el formulario no se enviaba.
- **Causa:** La etiqueta `<g:form>` de Grails no garantiza que el atributo `id` se transfiera correctamente.
- **Solución aplicada:** Usar `document.querySelector('#tab-crearPaciente form').submit()` en lugar de buscar por `id`, o cambiar el botón a `type="button"` con `onclick="validarYEnviar()"` y dentro usar `document.querySelector('form').submit()`.
- **Estado:** Resuelto

---

## INC-13 — `Cannot read properties of null (reading 'submit')` en registro

- **Fecha:** Abril 2026
- **Síntoma:** Al pulsar "Finalizar Registro" aparecía en consola: `Uncaught TypeError: Cannot read properties of null (reading 'submit')`.
- **Causa:** La función `validarYEnviar()` llamaba a `document.getElementById('formRegistro').submit()` pero `g:form` no generaba el `id` esperado.
- **Solución aplicada:** Sustituir por `document.querySelector('form').submit()`.
- **Estado:** Resuelto

---

## INC-14 — `DataTransfer` para asignar archivos comprimidos a inputs file

- **Fecha:** Abril 2026
- **Síntoma:** Al comprimir imágenes con Canvas API, no había forma de asignar el archivo comprimido al `<input type="file">`.
- **Causa:** Los inputs de tipo file son de solo lectura por seguridad del navegador.
- **Solución aplicada:** Usar la API `DataTransfer`: `const dt = new DataTransfer(); dt.items.add(archivoComprimido); fileInput.files = dt.files`.
- **Estado:** Resuelto

---

## INC-15 — Spring Security sobreescribía el login personalizado

- **Fecha:** Abril 2026
- **Síntoma:** Al añadir la dependencia de Spring Security para usar BCrypt, aparecía el formulario de login por defecto de Spring Security en lugar del login personalizado.
- **Causa:** `spring-boot-starter-security` activa automáticamente `SecurityAutoConfiguration`, que intercepta todas las rutas.
- **Solución aplicada:** Cambiar la dependencia a `spring-security-crypto:6.1.0` y añadir la exclusión en `Application.groovy`.
- **Estado:** Resuelto

---

## INC-16 — `HibernateException`: No Session found for current thread en el Interceptor

- **Fecha:** Abril 2026
- **Síntoma:** El `SecurityInterceptor.groovy` fallaba con `HibernateException: No Session found for current thread`.
- **Causa:** Los interceptores de Grails 7 se ejecutan antes de que Hibernate abra la sesión de base de datos, por lo que no se pueden hacer consultas GORM desde ellos.
- **Solución aplicada:** Eliminar el interceptor y mover la verificación de roles directamente a cada método del controlador mediante el método privado `verificarCuidador()`.
- **Estado:** Resuelto

---

## INC-17 — Contraseñas antiguas en texto plano no funcionaban tras implementar BCrypt

- **Fecha:** Abril 2026
- **Síntoma:** Los usuarios creados antes de implementar BCrypt no podían iniciar sesión.
- **Causa:** Sus contraseñas estaban en texto plano en la BD, pero el login ya usaba `encoder.matches()` que espera un hash BCrypt.
- **Solución aplicada:** Actualización manual de contraseñas en BD mediante Adminer con un `UPDATE` SQL usando un hash BCrypt generado en bcrypt-generator.com.
- **Estado:** Resuelto

---

## INC-18 — `TomcatServletWebServerFactory` no se podía registrar en `resources.groovy`

- **Fecha:** Abril 2026
- **Síntoma:** Al intentar registrar el bean en `resources.groovy`, el servidor no arrancaba.
- **Causa:** El DSL de beans de Grails no admite la configuración de beans de tipo `WebServerFactory`.
- **Solución aplicada:** Crear la clase `src/main/groovy/tfg/TomcatConfig.groovy` con la anotación `@Configuration` y un `@Bean` de tipo `WebServerFactoryCustomizer`.
- **Estado:** Resuelto

---

## INC-19 — Errores múltiples en la configuración del envío de correo SMTP

- **Fecha:** Abril 2026
- **Síntoma:** El sistema de envío de código de invitación fallaba con distintos errores: primero `Authentication failed`, después el correo no llegaba sin mostrar ningún error.
- **Causa:** Múltiple:
  1. La clave `spring:` aparecía duplicada en `application.yml`, por lo que la sección `mail` era ignorada.
  2. Grails no recogía bien la configuración de mail del YAML en algunos casos.
  3. La cuenta de Gmail nueva (`tfgalbum12@gmail.com`) bloqueaba el acceso SMTP por ser demasiado reciente.
  4. Las contraseñas de aplicación de Google se borraron o se copiaron con espacios.
- **Solución aplicada:**
  1. Fusionar los bloques `spring:` duplicados en uno solo en `application.yml`.
  2. Mover la configuración del `mailSender` directamente a `resources.groovy` como bean explícito de Spring, eliminando la dependencia del YAML.
  3. Usar la cuenta personal `valhi09@gmail.com` (con antigüedad) en lugar de la cuenta nueva.
  4. Generar correctamente una contraseña de aplicación de 16 caracteres desde `myaccount.google.com/apppasswords` y pegarla sin espacios.
- **Estado:** Resuelto

---

## INC-20 — `java.sql.Timestamp.format()` no existe en Java 17

- **Fecha:** Abril 2026
- **Síntoma:** Al cargar la vista del familiar aparecía el error: `No signature of method: java.sql.Timestamp.format()`.
- **Causa:** Grails 7 con Java 17 usa `java.sql.Timestamp` para las fechas almacenadas por GORM. Este tipo no tiene el método `.format()` de Groovy que sí tienen otros tipos de fecha.
- **Solución aplicada:** Sustituir todas las llamadas `fecha?.format('dd/MM/yyyy')` por `new java.text.SimpleDateFormat('dd/MM/yyyy').format(fecha)`.
- **Estado:** Resuelto

---

## INC-21 — Pérdida de datos de la base de datos al reiniciar Docker

- **Fecha:** Mayo 2026
- **Síntoma:** Todos los usuarios y datos desaparecieron tras un reinicio del entorno.
- **Causa:** Se ejecutó `docker-compose down -v` que elimina los volúmenes, o el volumen no estaba bien configurado.
- **Solución aplicada:** Verificar que `docker-compose.yml` tiene el volumen `./mysql-data:/var/lib/mysql`. Usar siempre `docker-compose down` sin el flag `-v`.
- **Estado:** Resuelto

---

## INC-22 — Tests unitarios fallaban por acceso a GORM sin sesión

- **Fecha:** Mayo 2026
- **Síntoma:** Al ejecutar `.\gradlew.bat test`, el test `LoginControllerSpec` fallaba con `IllegalStateException`.
- **Causa:** Los tests unitarios de controlador en Grails no tienen acceso a la base de datos ni a sesiones de Hibernate. El método `autenticar` llama a `Usuario.findByUsername()` que requiere GORM.
- **Solución aplicada:** Simplificar los tests para que no llamen a métodos que dependan de GORM, probando únicamente la lógica del controlador que no requiere base de datos.
- **Estado:** Resuelto

---

*Bitácora mantenida durante el desarrollo del TFG — Valeria Hidalgo Aguilar — DAW 2026*