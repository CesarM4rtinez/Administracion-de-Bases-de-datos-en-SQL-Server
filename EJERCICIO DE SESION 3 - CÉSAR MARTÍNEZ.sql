/* 
======================================================================
Elaborado por: César Ovidio Martínez Chicas
Fecha creación: 15/06/2024
Ejercicio: Reducir el Storage de una Base de datos.
           Realizando: de Filegroups, Datafiles y Shrink a un Log (File).

Sesión recibida: N°3
Módulo #2: Administrador de Base de datos con SQL Server
======================================================================
*/

--PASO 1: CAMBIAR A MODELO DE RECUPERACIÓN SIMPLE LA BASE DE DATOS. 

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

SET @mb_comienzo = 5120 -- Tamaño actual del fichero en MB
SET @mb_limite = 512 -- Tamaño deseado en MB
SET @file_name = 'DCesar_log2' -- Ajusta este nombre según el resultado de la consulta anterior
SET @step = 600 -- Paso inicial

WHILE (@mb_comienzo > @mb_limite)
BEGIN
    -- Reducir en pasos más pequeños cuando se acerque al tamaño deseado
    IF @mb_comienzo - @step < @mb_limite
    BEGIN
        SET @step = 60 -- Reducir el paso cuando se acerque al límite
    END
    
    SET @mb_comienzo = @mb_comienzo - @step
    
    PRINT 'Reduciendo a: ' + CAST(@mb_comienzo AS VARCHAR) + 'MB.'
    DBCC SHRINKFILE (@file_name, @mb_comienzo)
    
    -- Verificar el tamaño actual del archivo después de la reducción
    SELECT @actual_size = size / 128 FROM sys.master_files 
	WHERE name = @file_name AND type = 1 -- type = 1 es para el archivo de registro

    IF @actual_size <= @mb_limite
    BEGIN
        PRINT 'El tamaño del archivo de registro es ahora ' + CAST(@actual_size AS VARCHAR) + 'MB.'
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