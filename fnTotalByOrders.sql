CREATE FUNCTION dbo.fnTotalByOrders (@orderid int)
RETURNS money
AS
BEGIN
DECLARE @total money
SET @total = (
SELECT CAST(SUM(unitprice*qty*(1-discount)) as money) AS TotalOrders
FROM Sales.OrderDetails
WHERE orderid=@orderid
GROUP BY orderid)
RETURN @total
END
GO
SELECT dbo.fnTotalByOrders(10248)
GO
SELECT *, dbo.fnTotalByOrders(orderid) AS Total
FROM Sales.Orders