SET STATISTICS TIME ON
SET STATISTICS IO ON
SELECT SalesOrderDetailID,OrderQty
FROM Sales.SalesOrderDetail sod WITH (INDEX(IX_SecondTry))
WHERE ProductID= (SELECT AVG(ProductID)
FROM Sales.SalesOrderDetail sod1 WITH (INDEX(IX_SecondTry))
WHERE sod.SalesOrderID=sod1.SalesOrderID
GROUP BY SalesOrderID)
GO
CREATE NONCLUSTERED INDEX IX_SecondTry
ON Sales.SalesOrderDetail (ProductId ASC, SalesOrderId ASC)
INCLUDE (SalesOrderDetailID, OrderQty)
GO
DBCC FREEPROCCACHE
GO
DROP INDEX IX_SecondTry ON Sales.SalesOrderDetail 