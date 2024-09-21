-- Obtener nombres de archivos
USE [DB_CESAR]
GO
SELECT 
    name, 
    physical_name, 
    size * 8 / 1024 AS size_in_mb
FROM sys.database_files;
GO

-- Suponiendo que el nombre correcto del archivo de registro es 'DCesar_log'
-- Shrink por etapas
-- Primero, realiza un respaldo del registro de transacciones

ALTER DATABASE [DB_CESAR] SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE [DB_CESAR] TO  DISK = N'T:\Backup\Full\BD_CESAR' WITH NOFORMAT, NOINIT,  
NAME = N'DB_CESAR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
BACKUP LOG [DB_CESAR] TO  DISK = N'T:\Backup\Log_Transacciones\bdcesar' WITH NOFORMAT, NOINIT,  
NAME = N'DB_CESAR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
ALTER DATABASE [DB_CESAR] SET RECOVERY SIMPLE WITH NO_WAIT
GO

-- Shrink por etapas
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