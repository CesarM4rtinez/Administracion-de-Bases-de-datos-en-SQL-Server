/* 
======================================================================
Elaborado por: C�sar Ovidio Mart�nez Chicas
Fecha creaci�n: 15/06/2024
Ejercicio: Reducir el Storage de una Base de datos.
           Realizando: de Filegroups, Datafiles y Shrink a un Log (File).

Sesi�n recibida: N�3
M�dulo #2: Administrador de Base de datos con SQL Server
======================================================================
*/

--PASO 1: CAMBIAR A MODELO DE RECUPERACI�N SIMPLE LA BASE DE DATOS. 

USE [master]
GO
ALTER DATABASE [DB_CESAR] SET RECOVERY SIMPLE WITH NO_WAIT
GO

--PASO 2: REALIZAR EL SHRINK DEL DATAFILE, A LA BASE DE DATOS.
--Shrink por etapas
DECLARE @mb_comienzo INT
DECLARE @mb_limite INT
DECLARE @file_name NVARCHAR(128)
DECLARE @step INT
DECLARE @actual_size INT

SET @mb_comienzo = 5120 -- Tama�o actual del fichero en MB
SET @mb_limite = 512 -- Tama�o deseado en MB
SET @file_name = 'DCesar_log2' -- Ajusta este nombre seg�n el resultado de la consulta anterior
SET @step = 600 -- Paso inicial

WHILE (@mb_comienzo > @mb_limite)
BEGIN
    -- Reducir en pasos m�s peque�os cuando se acerque al tama�o deseado
    IF @mb_comienzo - @step < @mb_limite
    BEGIN
        SET @step = 60 -- Reducir el paso cuando se acerque al l�mite
    END
    
    SET @mb_comienzo = @mb_comienzo - @step
    
    PRINT 'Reduciendo a: ' + CAST(@mb_comienzo AS VARCHAR) + 'MB.'
    DBCC SHRINKFILE (@file_name, @mb_comienzo)
    
    -- Verificar el tama�o actual del archivo despu�s de la reducci�n
    SELECT @actual_size = size / 128 FROM sys.master_files 
	WHERE name = @file_name AND type = 1 -- type = 1 es para el archivo de registro

    IF @actual_size <= @mb_limite
    BEGIN
        PRINT 'El tama�o del archivo de registro es ahora ' + CAST(@actual_size AS VARCHAR) + 'MB.'
        BREAK
    END
END
GO

-- Obtener nombres de archivos
/*
SELECT 
    name, 
    physical_name, 
    size * 8 / 1024 AS size_in_mb
FROM sys.database_files;
GO
*/