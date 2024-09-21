CREATE FUNCTION dbo.fnTotalOrders (@orderid int)
RETURNS TABLE
AS
RETURN
SELECT orderid, CAST(SUM(unitprice*qty*(1-discount)) as money) AS TotalOrders
FROM Sales.OrderDetails
WHERE orderid=@orderid
GROUP BY orderid
GO
SELECT * FROM dbo.fnTotalOrders(10248)
--5min para que muestren los totales de la tabla Sales.Orders
SELECT SO.*, fnTotalOrders.TotalOrders,SC.companyname,SC.city,SC.country
FROM Sales.Orders AS SO
CROSS APPLY dbo.fnTotalOrders(SO.orderid)
INNER JOIN Sales.Customers AS SC
ON SO.custid=SC.custid