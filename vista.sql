CREATE VIEW Reporte
AS
SELECT SC.companyname,CONCAT(HRE.firstname,' ',HRE.lastname)AS Empleado,
PC.categoryname,PP.productname, SP.companyname AS Tienda, YEAR(SO.orderdate)AS Anio,
MONTH(SO.orderdate) AS MES, DAY(SO.orderdate)AS Dia, SOD.unitprice*qty*(1-discount)AS Total
FROM Sales.OrderDetails AS SOD
INNER JOIN Sales.Orders AS SO
ON SOD.orderid=SO.orderid
INNER JOIN HR.Employees AS HRE
ON SO.empid=HRE.empid
INNER JOIN Sales.Customers AS SC
ON SO.custid=SC.custid
INNER JOIN Production.Products AS PP
ON SOD.productid=PP.productid
INNER JOIN Production.Categories AS PC
ON PP.categoryid=PC.categoryid
INNER JOIN Sales.Shippers AS SP
ON SO.shipperid=SP.shipperid
GO