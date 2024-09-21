--  Demonstration B

SELECT custid, orderid, orderdate
FROM Sales.Orders
ORDER BY custid
GO
SELECT MAX(orderdate) ultimaorden
FROM Sales.Orders
WHERE custid=3
GO
SELECT custid, orderid, orderdate
FROM Sales.Orders AS outerorders--alias table
WHERE orderdate =
	(SELECT MAX(orderdate)
	FROM Sales.Orders AS innerorders--alias table
	WHERE innerorders.custid = outerorders.custid)
ORDER BY custid;

-- Select and execute the following query to 
-- show the use of a correlated subquery that
-- uses the empid from Sales.Orders to retrieve
-- orders placed by an employee on the latest order 
-- date for each employee
SELECT orderid, empid, orderdate
FROM Sales.Orders AS O1
WHERE orderdate =
	(SELECT MAX(orderdate)
	 FROM Sales.Orders AS O2
	 WHERE O2.empid = O1.empid)
ORDER BY empid, orderdate;
GO
SELECT orderid, productid, qty
FROM Sales.OrderDetails O1
WHERE O1.qty =
		(SELECT MAX(qty)
		FROM Sales.OrderDetails O2
		WHERE O1.productid=O2.productid
		)
ORDER BY productid,qty

-- Select and execute the following query to 
-- show the use of a correlated subquery 
SELECT custid, ordermonth, qty
FROM Sales.Custorders AS outercustorders
WHERE qty =
	(SELECT MAX(qty)
		FROM Sales.CustOrders AS innercustorders
		WHERE innercustorders.custid =outercustorders.custid
	)
ORDER BY custid;