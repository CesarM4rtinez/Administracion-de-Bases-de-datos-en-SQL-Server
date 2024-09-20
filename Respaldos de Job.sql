-- RESPALDAR JOB --
BACKUP DATABASE [msdb] TO  DISK = N'D:\msdb_bak.bak' WITH NOFORMAT,

NOINIT,  NAME = N'msdb-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- ELIMINAR JOB --
USE msdb
GO 

 
EXEC sp_delete_job 
    @job_name = N'Job de Prueba'
GO

-- RESTAURAR JOBS -- 
USE [master]

RESTORE DATABASE [msdb] FROM  DISK = N'D:\msdb_bak.bak'

WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO

