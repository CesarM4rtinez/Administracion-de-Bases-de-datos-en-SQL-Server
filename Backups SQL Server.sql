/*  Respaldos Backups  */

-- Full Backup --
BACKUP DATABASE SISTEMA_BANCARIO
TO DISK = 'D:\Banco Proyecto\SISTEMA BANCARIO\SISTEMA_BANCARIO-FullBacup.bak'
WITH FORMAT;

-- Differential Backup --
BACKUP DATABASE NombreDeLaBaseDeDatos
TO DISK = 'RutaDelArchivo.bak'
WITH DIFFERENTIAL;

-- Transaction Log Backup --
BACKUP LOG NombreDeLaBaseDeDatos
TO DISK = 'RutaDelArchivo.trn';

-- Bulk Backup --
BACKUP DATABASE NombreDeLaBaseDeDatos
TO DISK = 'RutaDelArchivo.bak'
WITH COPY_ONLY;


---------------------------------
/*  Restaruar Backups  */

-- Full Backup --
RESTORE DATABASE NombreDeLaBaseDeDatos
FROM DISK = 'RutaDelArchivo.bak'
WITH REPLACE;

-- Differential Backup --
RESTORE DATABASE NombreDeLaBaseDeDatos
FROM DISK = 'RutaDelArchivo.bak'
WITH NORECOVERY;

-- Transaction Log Backup --
RESTORE LOG NombreDeLaBaseDeDatos
FROM DISK = 'RutaDelArchivo.trn'
WITH NORECOVERY;

-- Bulk Backup --
RESTORE DATABASE NombreDeLaBaseDeDatos
FROM DISK = 'RutaDelArchivo.bak'
WITH REPLACE, RECOVERY;


