/* 
======================================================================
Elaborado por: C�sar Ovidio Mart�nez Chicas
Fecha creaci�n: 08/05/2024
Ejercicio: N�1

Clase recibida: N�4
M�dulo #1: Analista de Base de datos con SQL Server
======================================================================
*/
--Construccion de reportes
-- 1. �Cu�les son las categor�as de Productos que m�s adquieren los clientes que vienen de Argentina?
SELECT p.categoryid, COUNT(*) AS total_compras
	FROM Sales.Orders o
		INNER JOIN Sales.OrderDetails od ON o.orderid = od.orderid
		INNER JOIN Production.Products p ON od.productid = p.productid
	WHERE o.shipcountry = 'Argentina'
GROUP BY p.categoryid
ORDER BY total_compras DESC;
GO

-- 2. �Cu�ntos pedidos se han enviado hacia USA, del �ltimo trimestre del a�o 2007?
SELECT 
count(orderid)   AS PedidosTotales
FROM Sales.Orders
WHERE YEAR(Orderdate) = 2007 AND shipcountry = 'USA' AND MONTH(ORDERDATE) >= 10
GO

--
SELECT
YEAR(orderdate)  AS A�o,
MONTH(orderdate) AS Mes,
shipcountry      AS Pais

FROM Sales.Orders
WHERE YEAR(Orderdate) = 2007 AND shipcountry = 'USA' AND MONTH(ORDERDATE) >= 10
ORDER BY ORDERDATE DESC
GO

--SCRIPT DE EJEMPLO EN CLASE
--�Cu�l es el total en usd, de los pedidos atendidos de los empleados, segmentados por a�o y mes?
SELECT CONCAT(HRE.lastname,' ',HRE.firstname) AS Empleado, 
       YEAR(SO.orderdate)   AS A�o, 
       MONTH (SO.orderdate) AS Mes,
	   SUM(CAST(SOD.unitprice*SOD.qty*(1-SOD.discount) AS money)) AS total
	 
FROM   Sales.OrderDetails AS SOD
       INNER JOIN Sales.Orders AS SO
ON     SOD.orderid=SO.orderid
       INNER JOIN HR.Employees AS HRE
ON     SO.empid=HRE.empid
GROUP BY HRE.lastname, HRE.firstname, YEAR(SO.orderdate),MONTH (SO.orderdate)
ORDER BY A�o,Mes