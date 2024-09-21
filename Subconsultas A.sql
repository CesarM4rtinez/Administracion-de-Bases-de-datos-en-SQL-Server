-- Step 1: Scalar subqueres:
-- Select this query and execute it to
-- obtain most recent order
SELECT MIN(orderid) AS orders
FROM Sales.Orders;
GO
SELECT MAX(orderid) AS lastorder
FROM Sales.Orders;
GO
SELECT *
FROM Sales.OrderDetails
WHERE orderid=11077
-- Select this query and execute it to
-- find details in Sales.OrderDetails
-- for most recent order
SELECT orderid, productid, unitprice, qty
FROM Sales.OrderDetails
WHERE orderid = 
	(SELECT MAX(orderid) AS lastorder--Subconsulta Escalar
	FROM Sales.Orders);

-- THIS WILL FAIL, since
-- subquery returns more than 
-- 1 value
SELECT orderid, productid, unitprice, qty
FROM Sales.OrderDetails
WHERE orderid = 
	(SELECT orderid AS O
	FROM Sales.Orders
	WHERE empid =2);
GO
SELECT orderid, productid, unitprice, qty
FROM Sales.OrderDetails
WHERE orderid IN 
	(SELECT orderid AS O
	FROM Sales.Orders
	WHERE empid =2);--Subconsultas Valores Múltiples 


-- Step 3: Multi-valued subqueries 
-- Select this query and execute it to	
-- return order info for customers in Mexico
SELECT custid, orderid
FROM Sales.orders
WHERE custid IN (
	SELECT custid
	FROM Sales.Customers
	WHERE country = N'Mexico');
/*Crear una consulta que muestre los detalles de órdenes
(Sales.OrderDetails),que sean de la Categoría de Producto 
igual a 2 y 3.
Production.Categories(categoryid es 2 y 3)
Beverages,Condiments
10minutos
aprendedb@gmail.com*/
GO
SELECT orderid,productid,qty
FROM Sales.OrderDetails
WHERE productid IN
				(
				SELECT productid
				FROM Production.Products
				WHERE categoryid IN 
						(SELECT categoryid
						FROM Production.Categories
						WHERE categoryname IN ('Beverages','Condiments')
						)
				)