/* 
======================================================================
Elaborado por: César Ovidio Martínez Chicas
Fecha creación: 08/05/2024
Ejercicio: N°1

Clase recibida: N°4
Módulo #1: Analista de Base de datos con SQL Server
======================================================================
*/
--Construccion de reportes
-- 1. ¿Cuáles son las categorías de Productos que más adquieren los clientes que vienen de Argentina?
SELECT p.categoryid, COUNT(*) AS total_compras
	FROM Sales.Orders o
		INNER JOIN Sales.OrderDetails od ON o.orderid = od.orderid
		INNER JOIN Production.Products p ON od.productid = p.productid
	WHERE o.shipcountry = 'Argentina'
GROUP BY p.categoryid
ORDER BY total_compras DESC;
GO

-- 2. ¿Cuántos pedidos se han enviado hacia USA, del último trimestre del año 2007?
SELECT 
count(orderid)   AS PedidosTotales
FROM Sales.Orders
WHERE YEAR(Orderdate) = 2007 AND shipcountry = 'USA' AND MONTH(ORDERDATE) >= 10
GO

--
SELECT
YEAR(orderdate)  AS Año,
MONTH(orderdate) AS Mes,
shipcountry      AS Pais

FROM Sales.Orders
WHERE YEAR(Orderdate) = 2007 AND shipcountry = 'USA' AND MONTH(ORDERDATE) >= 10
ORDER BY ORDERDATE DESC
GO

--SCRIPT DE EJEMPLO EN CLASE
--¿Cuál es el total en usd, de los pedidos atendidos de los empleados, segmentados por año y mes?
SELECT CONCAT(HRE.lastname,' ',HRE.firstname) AS Empleado, 
       YEAR(SO.orderdate)   AS Año, 
       MONTH (SO.orderdate) AS Mes,
	   SUM(CAST(SOD.unitprice*SOD.qty*(1-SOD.discount) AS money)) AS total
	 
FROM   Sales.OrderDetails AS SOD
       INNER JOIN Sales.Orders AS SO
ON     SOD.orderid=SO.orderid
       INNER JOIN HR.Employees AS HRE
ON     SO.empid=HRE.empid
GROUP BY HRE.lastname, HRE.firstname, YEAR(SO.orderdate),MONTH (SO.orderdate)
ORDER BY Año,Mes