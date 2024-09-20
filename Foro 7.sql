------------------------------------------------------

          /* Foro Asíncronico Semana 7 */

------------------------------------------------------
-- ESPACIO DE CAPTURAS... 
-- CAPTURAS DE LAS CONSULTAS QUE SE HARÁN...


sp_configure 'Configuración deL MAXDOP', 4192;                                                /* Captura 1 (Punto 5) */ go




sp_configure 'Información sobre el MAXDOP'                                                    /* Captura 2 (Punto 5) */ go




sp_configure 'MAXDOP', MB                                                                     /* Captura 3 (Punto 6) */ go




-----------------------------------------------------

         /* Foro Asíncronico Semana 7 */

------------------------------------------------------
-- ESPACIO DE CONSULTAS...
-- PUNTO 5.
-- CORRER LINEA POR LINEA.
-- IMPORTANTE LEER!!!
exec sp_configure 'show advanced options', 0;  -- Configurar primero para abrir concexiones remotas de 0 a 1. (paso 1)
                                               -- SIN ESA CONSULTA NO SE PUEDE HACER NADA. Si esta en 0 no se puede ejecutar la consulta 3.

RECONFIGURE with override -- (Paso 2)	       -- IMPORTANTE! luego para cerrarla despues de hacer las consultas cambiar el 1 por el 0.
											   -- para asi no dañar el Sistema SMS(la interfaz de sql server) al ejecutar 
											   -- cualquier otra consulta para una base en uso.
go
sp_configure 'max degree of parallelism', 8192 -- luego ejecturar linea post al reconfigure...  (paso 3)
go

RECONFIGURE with override                      -- Memoria máxima -- (Paso 4)
go

sp_configure 'max degree of parallelism'       -- Para ver el config_value que es la ram que le pusiste y tambien los datos del mismo MAXDOP. (paso 5)
go


------------------------------------------------------
-- PUNTO 6.

sp_configure 'max degree of parallelism', 8192 -- Que es la misma consulta que se ha venido ejecutando anteriormente.
RECONFIGURE with override 
------------------------------------------------------