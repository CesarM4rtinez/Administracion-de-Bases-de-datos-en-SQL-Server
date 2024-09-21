SELECT *
FROM Sales.Customers
WHERE country='mexico' or country='germany' or city <>'berlin'
GO
SELECT *
FROM Sales.Customers
WHERE country='mexico' or country='germany' and city <>'berlin'
--Clientes que sean de Sudamérica
SELECT *
FROM Sales.Customers
WHERE country='argentina' or country='brazil'
GO
SELECT *
FROM Sales.Customers
WHERE country IN ('argentina','brazil')
SELECT *
FROM Sales.Customers
WHERE country IN ('spain','france','germany','uk','portugal')
GO
--Ordenes entre el 31/07/2006 al 31/03/2007
SELECT *
FROM Sales.Orders
WHERE orderdate>='20060731' and orderdate <='20070331'
GO
SELECT *
FROM Sales.Orders
WHERE orderdate IN ('20060731','20070331')
SELECT *
FROM Sales.Orders
WHERE orderdate BETWEEN '20060731' AND '20070331'
GO
SELECT *
FROM Sales.Orders
WHERE shipcountry NOT IN ('finland','venezuela')