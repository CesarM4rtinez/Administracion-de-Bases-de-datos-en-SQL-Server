-- TRANSACCIONES BÁSICAS EN SQL SERVER

DECLARE @edad INT = 18;

IF @edad >= 18
BEGIN
  PRINT 'Eres mayor de edad';
END
ELSE
BEGIN
  PRINT 'Eres menor de edad';
END
--------------------------------------------------

DECLARE @contador INT = 0;

WHILE @contador < 10
BEGIN
  PRINT @contador;
  SET @contador = @contador + 1;
END



------------------------------------------------------


DECLARE @edad INT = 17;

IF @edad >= 18
BEGIN
  GOTO etiqueta_mayor_edad; ---ir a: ir a la etiqueta maryr_edad
END

PRINT 'Eres menor de edad con GOTO';
GOTO etiqueta_fin;

etiqueta_mayor_edad:
PRINT 'Eres mayor de edad con GOTO';

etiqueta_fin:





------------------------


DECLARE @nombre VARCHAR(50) = 'Juan';
DECLARE @edad INT = 25;
DECLARE @es_casado BIT = 0;

PRINT 'Nombre: ' + @nombre;
PRINT 'Edad: ' + CAST(@edad AS VARCHAR(10));
PRINT 'Es casado: ' + CAST(@es_casado AS VARCHAR(10));
