SELECT custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate
GO
SELECT TOP 5 orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate DESC
GO
SELECT TOP 5 orderid, custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
--ORDER BY orderid
GO
SELECT TOP 10 PERCENT orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate DESC
GO
SELECT TOP 5 WITH TIES orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate DESC