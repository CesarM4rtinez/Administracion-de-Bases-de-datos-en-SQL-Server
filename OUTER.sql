SELECT *
FROM Sales.Customers AS A
LEFT JOIN Sales.Orders AS B
ON A.custid=B.custid
WHERE B.custid IS NULL
GO
SELECT *
FROM Sales.Customers AS A
JOIN Sales.Orders AS B
ON A.custid=B.custid
GO
SELECT *
FROM Sales.Customers AS A
RIGHT JOIN Sales.Orders AS B
ON A.custid=B.custid
WHERE A.custid IS NULL