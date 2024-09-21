--¿Cuál es el total en usd, de los pedidos atendidos de los empleados, segmentados por año y mes?
--Sales.Orders, HR.Employee, Sales.OrderDetails
SELECT SOD.orderid,CAST(SOD.unitprice*SOD.qty*(1-SOD.discount) AS money) AS Total
,SO.empid,SO.orderdate,YEAR(SO.orderdate) AS Anio, MONTH(SO.orderdate)AS Mes
,CONCAT(HRE.lastname,' ',HRE.firstname) AS Empleado
FROM Sales.OrderDetails AS SOD
INNER JOIN Sales.Orders AS SO
ON SOD.orderid=SO.orderid
INNER JOIN HR.Employees AS HRE
ON SO.empid=HRE.empid
GO
SELECT CONCAT(HRE.lastname,' ',HRE.firstname) AS Empleado, YEAR(SO.orderdate) AS Anio, MONTH(SO.orderdate)AS Mes,
SUM(CAST(SOD.unitprice*SOD.qty*(1-SOD.discount) AS money)) AS Total
FROM Sales.OrderDetails AS SOD
INNER JOIN Sales.Orders AS SO
ON SOD.orderid=SO.orderid
INNER JOIN HR.Employees AS HRE
ON SO.empid=HRE.empid
GROUP BY HRE.lastname, HRE.firstname,YEAR(SO.orderdate),MONTH(SO.orderdate)
ORDER BY Anio,Mes