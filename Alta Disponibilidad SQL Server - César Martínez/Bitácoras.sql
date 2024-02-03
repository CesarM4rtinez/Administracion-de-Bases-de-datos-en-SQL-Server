CREATE TABLE Log_Transacciones (
Transaccion_ID INT IDENTITY(1,1) PRIMARY KEY,
Nombre_Tabla VARCHAR(50),
Fecha_Hora DATETIME,
Tipo_Operacion VARCHAR(10),
Datos_Anteriores VARCHAR(MAX),
Datos_Nuevos VARCHAR(MAX)
);
go

select*from Log_Transacciones
go

CREATE TRIGGER trg_Log_Transacciones -- Nombre del trigger
ON Log_Transacciones  -- Nombre de la tabla
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @Nombre_Tabla VARCHAR(50) = 'MiTabla'
DECLARE @Fecha_Hora DATETIME = GETDATE()
DECLARE @Tipo_Operacion VARCHAR(10)
DECLARE @Datos_Anteriores VARCHAR(MAX)
DECLARE @Datos_Nuevos VARCHAR(MAX)

IF EXISTS (SELECT * FROM inserted)
BEGIN
    SET @Tipo_Operacion = 'INSERT'
    SET @Datos_Nuevos = (SELECT * FROM inserted FOR JSON AUTO)
END

IF EXISTS (SELECT * FROM deleted)
BEGIN
    SET @Tipo_Operacion = 'DELETE'
    SET @Datos_Anteriores = (SELECT * FROM deleted FOR JSON AUTO)
END

IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
BEGIN
    SET @Tipo_Operacion = 'UPDATE'
    SET @Datos_Anteriores = (SELECT * FROM deleted FOR JSON AUTO)
    SET @Datos_Nuevos = (SELECT * FROM inserted FOR JSON AUTO)
END

INSERT INTO Log_Transacciones (Nombre_Tabla, Fecha_Hora, Tipo_Operacion, Datos_Anteriores, Datos_Nuevos)
VALUES (@Nombre_Tabla, @Fecha_Hora, @Tipo_Operacion, @Datos_Anteriores, @Datos_Nuevos)
End


INSERT INTO Log_Transacciones (Nombre_Tabla, Fecha_Hora, Tipo_Operacion, Datos_Anteriores, Datos_Nuevos)
VALUES ('nombre_de_la_tabla', GETDATE(), 'tipo_de_operacion', 'datos_anteriores', 'datos_nuevos');


BEGIN TRANSACTION

DECLARE @Producto VARCHAR(50) = 'Producto A'
DECLARE @Precio DECIMAL(10, 2) = 10.00

UPDATE Ventas
SET PrecioVenta = @Precio
WHERE Producto = @Producto

IF @@ROWCOUNT > 0
BEGIN
   INSERT INTO Transacciones (Nombre_tabla, Fecha_hora, Tipo_Operacion, Datos_Anteriores, Datos_Nuevos)
   VALUES (@Nombre_tabla, (SELECT PrecioVenta FROM deleted), @Precio, GETDATE())

   COMMIT TRANSACTION
END
ELSE
BEGIN
   ROLLBACK TRANSACTION
END


USE northwind
DBCC SQLPERF(LOGSPACE); 

DBCC SHRINKFILE('northwind_log', TRUNCATEONLY);

ALTER DATABASE <database_name> SET RECOVERY SIMPLE;

-- Desactivar la bitácora de la base de datos:
ALTER DATABASE <database_name> SET RECOVERY OFF;

