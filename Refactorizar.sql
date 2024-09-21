SELECT C.custid, TopOrders.orderid, TopOrders.orderdate
FROM Sales.Customers AS C
OUTER APPLY
(SELECT TOP (3) orderid, orderdate
FROM Sales.Orders AS O
WHERE O.custid = C.custid
ORDER BY orderdate DESC, orderid DESC) AS TopOrders
ORDER BY custid, orderdate DESC, orderid DESC; 


SELECT C.custid, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT JOIN (SELECT custid, orderid, orderdate, 
NR = ROW_NUMBER() OVER(PARTITION BY custid ORDER BY custid, orderdate DESC, orderid DESC)
  FROM Sales.Orders) AS O
ON O.custid = C.custid
 AND nr <= 3
ORDER BY custid, orderdate DESC, orderid DESC;