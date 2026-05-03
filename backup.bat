@echo off
set FECHA=%date:~6,4%-%date:~3,2%-%date:~0,2%
set HORA=%time:~0,2%-%time:~3,2%
set NOMBRE=backup_%FECHA%_%HORA%
mkdir backups\%NOMBRE%

REM Copia de seguridad de la base de datos
docker exec tfg-db mysqldump -u root -padmin tfg_db > backups\%NOMBRE%\tfg_db.sql

REM Copia del código fuente
xcopy /E /I /Q grails-app backups\%NOMBRE%\grails-app

echo Backup completado: backups\%NOMBRE%
pause