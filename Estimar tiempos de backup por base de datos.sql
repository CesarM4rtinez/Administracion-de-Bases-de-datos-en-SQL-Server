-- Script para estimar tiempos de backup en SQL Server 2016

-- Establecer la base de datos de la cual deseas estimar el tiempo de backup
USE SISTEMA_TEL;

-- Calcular el tamaño total de la base de datos
DECLARE @TotalSizeMB DECIMAL(12, 2);
SELECT @TotalSizeMB = SUM(size * 8 / 1024)
FROM sys.master_files
WHERE DB_NAME(database_id) = DB_NAME();

-- Calcular la velocidad de transferencia promedio (puedes ajustar este valor según tu entorno)
DECLARE @TransferRateMBps DECIMAL(12, 2) = 50;

-- Calcular el tiempo estimado de backup en minutos
DECLARE @BackupTimeMinutes DECIMAL(12, 2);
SET @BackupTimeMinutes = @TotalSizeMB / @TransferRateMBps / 60;

-- Mostrar el resultado
SELECT 'El tiempo estimado de backup para la base de datos ' + DB_NAME() + ' es de aproximadamente ' + CAST(@BackupTimeMinutes AS VARCHAR) + ' minutos.';
