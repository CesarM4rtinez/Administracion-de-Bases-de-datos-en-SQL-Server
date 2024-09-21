SELECT *
FROM Sales.Customers
GO
SELECT *
FROM Sales.Orders
GO
SELECT *
FROM HR.Employees AS HR, Sales.Orders AS SO
WHERE HR.empid=SO.empid
--HR.Employees: El empleado con más ordenes y con menos ordenes.10'
GO
SELECT *
FROM Sales.Customers AS SC, Sales.Orders AS SO
WHERE SC.custid=SO.custid
GO
SELECT *
FROM Sales.Customers AS SC 
INNER JOIN Sales.Orders AS SO
ON SC.custid=SO.custid
GO
SELECT *
FROM Sales.Customers
GO
SELECT *
FROM HR.Employees
GO
SELECT SC.custid,SC.companyname,SC.city,SC.country,HR.empid,HR.city,HR.country
FROM Sales.Customers AS SC
INNER JOIN HR.Employees AS HR
ON SC.country=HR.country AND SC.city=HR.city
WHERE HR.empid IN (5,6)
GO
SELECT DISTINCT SC.city,SC.country,HR.city,HR.country
FROM Sales.Customers AS SC
INNER JOIN HR.Employees AS HR
ON SC.country=HR.country AND SC.city=HR.city
