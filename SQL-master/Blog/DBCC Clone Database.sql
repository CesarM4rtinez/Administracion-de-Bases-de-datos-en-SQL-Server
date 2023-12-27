-- USO DE DBCC CLONEDATABASE PARA RESOLVER PROBLEMAS DE PERFORMANCE


USE AdventureWorks2014 
GO

SELECT *
FROM [Sales].[SalesOrderHeader] H
INNER JOIN [Sales].[SalesOrderDetail] D 
ON [h].[SalesOrderID] = [d].[SalesOrderID]
ORDER by d.LineTotal 


SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 897;
 
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 870;

DBCC CLONEDATABASE (AdventureWorks2014, AdventureWorks2014_Clone);    
GO 

USE AdventureWorks2014_Clone
GO

SELECT *
FROM [Sales].[SalesOrderHeader] H
INNER JOIN [Sales].[SalesOrderDetail] D 
ON [h].[SalesOrderID] = [d].[SalesOrderID]
ORDER by d.LineTotal 


SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 897;
 
SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 870;

SELECT SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 1;
