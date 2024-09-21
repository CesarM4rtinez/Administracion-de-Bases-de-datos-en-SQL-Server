DECLARE @anio int
SET @anio = (SELECT MAX(YEAR(orderdate)) FROM Sales.Orders)
SELECT *
FROM Sales.Orders
WHERE YEAR(orderdate)=@anio
GO
CREATE VIEW Sales.TotSOD
AS
SELECT *, CAST(unitprice*qty*(1-discount) as money)  AS SubTotal
FROM Sales.OrderDetails
GO
ALTER VIEW Sales.TotSOD
AS
SELECT *, CAST(unitprice*qty*(1-discount) as money)*0.10  AS SubTotal
FROM Sales.OrderDetails
GO
CREATE PROCEDURE sp_RpteMes @anio int, @mes int
AS
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
DECLARE @saldo money
EXEC sp_RpteMes 2008,4
GO
ALTER PROCEDURE sp_RpteMes @anio int, @mes int
AS
SELECT SO.orderid, SOD.productid, SOD.SubTotal, SO.orderdate, SO.custid, SC.companyname, SC.country,
SO.empid,HRE.lastname,HRE.firstname 
FROM Sales.TotSOD AS SOD
INNER JOIN Sales.Orders AS SO
ON SOD.orderid=SO.orderid
INNER JOIN Sales.Customers AS SC
ON SO.custid=SC.custid
INNER JOIN HR.Employees AS HRE
ON SO.empid=HRE.empid
WHERE YEAR(orderdate)=@anio AND MONTH(orderdate)=@mes
SELECT * FROM HR.Employees
CREATE TABLE T1(ID INT)
INSERT INTO T1(ID) VALUES (1),(2),(3)
GO
EXEC sp_RpteMes 2008,4
select * from t1