/*REFACTORIZAR EL SIGUIENTE SCRIPT A 
FIN DE QUE EL NESTED LOOPS SE CONVIERTA
EN UN HASH*/
SELECT C.custid, TopOrders.orderid, TopOrders.orderdate
FROM Sales.Customers AS C
OUTER APPLY
(SELECT TOP (3) orderid, orderdate
FROM Sales.Orders AS O
WHERE O.custid = C.custid
ORDER BY orderdate DESC, orderid DESC) AS TopOrders
ORDER BY custid, orderdate DESC, orderid DESC; 
