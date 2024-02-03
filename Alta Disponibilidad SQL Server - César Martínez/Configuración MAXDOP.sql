sp_configure 'Configurando el grado máximo de paralelismo 
              de 0 a 8192 que equivale a 8 de ram', 8192 go


sp_configure 'Extrayendo la información sobre la nueva
              configuración del grado de pralelismo de config_value' go


sp_configure 'MAXDOP', MB go
------------------------------------------------------

------------------------------------------------------
-- Espacio de capturas.. 

sp_configure 'Configuración deL MAXDOP', 4192;                                                /* Captura 1 (Punto 5) */ go




sp_configure 'Información sobre el grado de pralelismo'                                       /* Captura 2 (Punto 5)*/ go



sp_configure 'MAXDOP', MB                                                                     /* Captura 3 (Punto 6)*/


-----------------------------------------------------

------------------------------------------------------
-- PUNTO 5.
-- CORRER LINEA POR LINEA.
go
exec sp_configure 'show advanced options', 0; -- Configurar primero para abrir concexiones remotas de 0 a 1. (paso 1)
                                              -- SIN ESA CONSULTA NO SE PUEDE HACER NADA. Si esta en 0 no se puede ejecutar la consulta 3.

RECONFIGURE with override -- (Paso 2)	      -- IMPORTANTE! luego para cerrarla despues de hacer las consultas cambiar el 1 por el 0.
											  -- para asi no dañar el Sistema SMS(la interfaz de sql server) al ejecutar 
											  -- cualquier otra consulta para una base en uso.
go
sp_configure 'max degree of parallelism', 8192 -- luego ejecturar linea y post el reconfigure...  (paso 3)
GO
RECONFIGURE with override               -- Memoria máxima -- (Paso 4)
GO

sp_configure 'max degree of parallelism' -- Para ver el config_value que es la ram que le pusiste y tambien los datos del mismo MAXDOP. (paso 5)
go
-----------------------------------------------------
-- PUNTO 6.

sp_configure 'MAXDOP', MB 
-----------------------------------------------------
sp_configure 'min', 1
GO
RECONFIGURE
GO

sp_configure 'min'
go

option (maxdop 1)
EXEC sp_configure maxdop, 8192;
RECONFIGURE;

use primerparcial
























sp_configure 'remote admin connections', 0
GO
RECONFIGURE                -- Habilitar las conexiones remotas para establece un minimo de memoria
GO
