SELECT *,
CASE WHEN MONTH(orderdate)=1 THEN 'Enero'
WHEN MONTH(orderdate)=2 THEN 'Febrero'
ELSE 'NoMes' END MesOrden
FROM Sales.Orders
GO
SELECT *
FROM Sales.Orders SO
INNER JOIN Dim_Date DD
ON SO.orderdate=[Date]