-- FULL BACKUP --
BACKUP DATABASE BD_FICHAJUGADOR
TO DISK = 'D:\Documentos\Trabajos\Programaci�n ll - C#\MC1832012022 - PARCIAL II - PROGRAMACI�N II\BD_FICHAJUGADOR-FULL'

-- DIFERENCIAL BACKUP --
BACKUP DATABASE PRUEBA2
TO DISK = 'D:\Documentos\SQL\SQL Server\FORO SEMANA 12\PRUEBA2_DIFERENCIAL.BAK'
WITH DIFFERENTIAL

-- LOG BACKUP --
BACKUP LOG PRUEBA2
TO DISK = 'D:\Documentos\SQL\SQL Server\FORO SEMANA 12\PRUEBA2_LOG.BAK'