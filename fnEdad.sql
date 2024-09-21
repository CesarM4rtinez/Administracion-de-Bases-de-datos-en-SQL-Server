/*Función: Calculando la edad de las Personas con SQL*/
CREATE FUNCTION dbo.fnEdad (@fecnac date)
RETURNS int
AS
BEGIN
DECLARE @edad int
IF MONTH(@fecnac) <= MONTH(GETDATE()) AND DAY(@fecnac) <= DAY(GETDATE())
	BEGIN
	SET @edad= (SELECT DATEDIFF(yy,@fecnac,GETDATE()) - 0)
	END
ELSE
	BEGIN
	SET @edad= (SELECT DATEDIFF(yy,@fecnac,GETDATE()) - 1)
	END
RETURN @edad
END
GO
SELECT dbo.fnEdad('19850713')