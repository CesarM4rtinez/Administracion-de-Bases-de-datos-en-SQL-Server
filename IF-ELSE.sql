DECLARE @nombre varchar(10)='bertha', @apellido varchar(10)='morales'
IF LEN(@nombre) <= LEN(@apellido)
	BEGIN
	IF SUBSTRING(@nombre,1,1)='b'
		BEGIN
		SELECT 'El nombre empieza con b'
		END
	ELSE
		BEGIN
		SELECT 'El nombre no empieza con b'
		END
	END
ELSE
	BEGIN
			SELECT 'El nombre tiene más letras que el apellido'

	END