/* 
======================================================================
Elaborado por: César Ovidio Martínez Chicas
Fecha creación: 19/05/2024
Ejercicio: N°2

Clase recibida: N°5
Módulo #1: Analista de Base de datos con SQL Server
======================================================================
*/

--MOSTRAR TOTALES DE LA TABLA SALES.ORDERS
--SELECT*FROM SALES.ORDERS;

SELECT*FROM dbo.fnTotalOrders(10248)
go

CREATE FUNCTION dbo.fnTotalOrders (@orderid int)
RETURNS TABLE
AS
RETURN 
SELECT orderid, CAST(SUM(unitprice*qty*(1-discount)) as money) as TotalOrders
FROM Sales.OrderDetails
Group By orderid
go