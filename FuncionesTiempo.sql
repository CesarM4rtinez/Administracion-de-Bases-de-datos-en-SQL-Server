/*Funciones de Tiempo en SQL Server
======================================================================
Elaborado por: AprendeDB
Fecha creación: 30/03/2024
*/
SELECT
GETDATE() AS FechaHoraActual,--Tipo de Dato datetime
--Resultado: 2024-03-30 11:43:26.380
SYSDATETIME() AS FechaHoraActual,--Tipo de Dato datetime2(7)
--Resultado: 2024-03-30 11:43:26.3817943
GETUTCDATE() AS FechaHoraActual--Tipo de Dato datetime
--Resultado: 2024-03-30 16:43:26.380
GO
SELECT 
YEAR(GETDATE()) AS Año,--Tipo de Dato int 
--Resultado: 2024
MONTH(GETDATE()) AS Mes,--Tipo de Dato int 
--Resultado: 3
DAY(GETDATE()) AS Día --Tipo de Dato int 
--Resultado: 30
GO
SELECT
DATEADD(yy,1,GETDATE())AS AñoSgte,--Tipo de Dato smalldatetime
--Resultado: 2025-03-30 12:07:15.257
DATEADD(mm,1,GETDATE())AS MesSgte,--Tipo de Dato smalldatetime
--Resultado: 2024-04-30 12:07:15.257
DATEADD(dd,1,GETDATE()) AS DiaSgte --Tipo de Dato smalldatetime
--Resultado: 2024-03-31 12:07:15.257
GO
SELECT
DATEDIFF(yy,'19850713',GETDATE()) AS DiffAños, --Tipo de Dato int
--Resultado: 39
DATEDIFF(mm,'19850713',GETDATE()) AS DiffMeses, --Tipo de Dato int
--Resultado: 464
DATEDIFF(dd,'19850713',GETDATE()) AS DiffDias --Tipo de Dato int
--Resultado: 14140
GO
/*Pregunta Reto: ¿Cómo podemos calcular la Edad utilizando SQL? 10min*/
SELECT(DATEDIFF(mm,'20031110',GETDATE()))/12 AS Edadselect DATEDIFF(year,'19711013',getdate())SELECT DATEDIFF(dd,'19850331',GETDATE())/365 AS DiffAñosselect DATEDIFF(day, '19850331', GETDATE()) / 365SELECT     DATEDIFF(YEAR, '19960705', GETDATE()) -     CASE WHEN DATEADD(YEAR, 					DATEDIFF(YEAR, '19960705', GETDATE()), '19960705'						) > GETDATE() 	THEN 1  ELSE 0 END AS MiEdad;