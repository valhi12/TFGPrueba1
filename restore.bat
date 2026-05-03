@echo off
echo Introduce el nombre de la carpeta de backup (ej: backup_2026-04-14_10-30):
set /p NOMBRE=

REM Restaurar base de datos
docker exec -i tfg-db mysql -u root -padmin tfg_db < backups\%NOMBRE%\tfg_db.sql

echo Restauracion completada desde: backups\%NOMBRE%
pause