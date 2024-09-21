CREATE TABLE AprendeDB
(
ID int IDENTITY(1,1) PRIMARY KEY CLUSTERED,
Name nvarchar(50)
)

--Aplicaremos el siguiente fix data ejecutándolo para obtener 1000 registros

DECLARE @max int=1000, @count int=1
WHILE @max>=@count
BEGIN
BEGIN TRAN
INSERT INTO AprendeDB VALUES('www.aprendedb.com')
COMMIT
SET @count=@count+1
END
--Definición del Cursor:
SET NOCOUNT ON
DECLARE my_cursor CURSOR FOR SELECT ID,Name FROM AprendeDB
DECLARE @id INT
DECLARE @name NVARCHAR(50)
OPEN my_cursor
FETCH NEXT FROM my_cursor INTO @id,@name
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT  (CAST(@id AS VARCHAR(5)) + '.)' + @name)
FETCH NEXT FROM my_cursor
END
CLOSE my_cursor
DEALLOCATE my_cursor
GO

--Definición del While:
DECLARE @Rows INT, @id1 INT
DECLARE @name1 NVARCHAR(50)
SET @Rows = 1
SET @id1 = 0
WHILE @Rows > 0
BEGIN
SELECT TOP 1 @id1 = ID, @name1 = Name FROM AprendeDB WHERE ID >= @id1
SET @Rows = @@ROWCOUNT
PRINT  (CAST(@id1 AS VARCHAR(5)) + '.)' + @name1)
SET @id1 += 1
END