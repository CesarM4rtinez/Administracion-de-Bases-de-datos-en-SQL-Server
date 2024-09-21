SELECT TOP 100 orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate ASC
--Pregunta reto: Construir un query que permita ver las órdenes del puesto 101 al puesto 200.
--Tiempo 10'
GO
SELECT orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate ASC
OFFSET 0 ROWS FETCH FIRST 100 ROWS ONLY
GO
SELECT orderid,custid, empid, orderdate,shipcountry, shipcity
FROM Sales.Orders
ORDER BY orderdate ASC
OFFSET 100 ROWS FETCH NEXT 100 ROWS ONLY
GO
