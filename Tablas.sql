USE VentasDB
GO
ALTER TABLE DetalleVenta
DROP CONSTRAINT IF EXISTS FK_Producto_DetalleVenta
GO
DROP TABLE IF EXISTS PRODUCTO
GO
CREATE TABLE Producto(
IdProducto smallint NOT NULL identity(1,1) PRIMARY KEY,
CodProducto varchar(10) NULL,
NomProducto varchar(255) NULL,
Fabricante varchar(255) NULL,
FecIngreso smalldatetime NULL DEFAULT GETDATE()
)
GO
DROP TABLE IF EXISTS DetalleVenta
GO
CREATE TABLE DetalleVenta(
IdDetalleVenta int NOT NULL identity(1,1) PRIMARY KEY,
IdVenta int NULL,
IdProducto smallint NULL,
Qty int NULL,
PrecioUnitario money
)
GO
ALTER TABLE DetalleVenta
ADD CONSTRAINT FK_Producto_DetalleVenta
FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
GO
-- CÉSAR MARTÍNEZ | EJEMPLOS DE CREACIÓN DE TABLAS EN ENTORNOS DE DESARROLLO