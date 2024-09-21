USE TSQL2017
GO
SELECT *
FROM Sales.OrderDetails
WHERE orderid = (
SELECT TOP 1 orderid
FROM Sales.Orders
ORDER BY orderid DESC)
GO
SELECT *
FROM Sales.OrderDetails
WHERE orderid =(
SELECT MAX(orderid)
FROM Sales.Orders)
GO
SELECT TOP 1 empid
FROM Sales.Orders
ORDER BY orderid DESC
GO
SELECT *
FROM HR.Employees
WHERE empid = (SELECT TOP 1 empid
FROM Sales.Orders
ORDER BY orderid DESC)
GO
SELECT *
FROM HR.Employees
WHERE empid= (
		SELECT empid
		FROM Sales.Orders
		WHERE orderid=(
					SELECT MAX(orderid)
					FROM Sales.Orders)
				)