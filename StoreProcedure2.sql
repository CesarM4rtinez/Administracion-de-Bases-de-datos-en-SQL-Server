SELECT *
FROM Sales.Customers
WHERE companyname='Customer AZJED'
GO
SELECT *
FROM Sales.Orders
WHERE shipcity='London'

SELECT city,COUNT(custid) As NroFROM Sales.Customers GROUP BY city
HAVING COUNT(custid)>1
GO
CREATE PROCEDURE sp_OrdersByCity @custid int
AS
DECLARE @city varchar(50)
SET @city = (SELECT city FROM Sales.Customers WHERE custid=@custid)
SELECT * 
FROM Sales.Orders
WHERE shipcity = @city
GO
EXEC sp_OrdersByCity 12
GO
CREATE PROCEDURE sp_RpteAnioMesActual
AS
DECLARE @anio int, @mes int
SET @anio=YEAR(GETDATE())
SET @mes=YEAR(GETDATE())
SELECT SO.orderid, SOD.productid, SOD.SubTotal, SO.orderdate, SO.custid, SC.companyname, 
SO.empid,HRE.lastname,HRE.firstname 
FROM Sales.TotSOD AS SOD
INNER JOIN Sales.Orders AS SO
ON SOD.orderid=SO.orderid
INNER JOIN Sales.Customers AS SC
ON SO.custid=SC.custid
INNER JOIN HR.Employees AS HRE
ON SO.empid=HRE.empid
WHERE YEAR(orderdate)=@anio AND MONTH(orderdate)=@mes
GO
EXEC sp_RpteAnioMesActual