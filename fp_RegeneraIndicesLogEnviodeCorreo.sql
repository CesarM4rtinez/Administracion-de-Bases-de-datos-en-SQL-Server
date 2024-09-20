USE [master]
GO

/****** Object:  StoredProcedure [dbo].[fp_RegeneraIndices]    Script Date: 03/22/2021 17:50:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*----------------------------------------------
Reconstruye los indices dañados por mas del 30%
IIslas (DR) Mexico
*/----------------------------------------------

CREATE PROC [dbo].[fp_RegeneraIndices]
AS           
BEGIN

BEGIN TRY
--BEGIN TRAN

DECLARE @DB sysname = DB_NAME()
DECLARE	@SQLString nvarchar(max),
		@ParmDefinition nvarchar(max)

    SET NOCOUNT ON;
    DECLARE @objectid INT;
    DECLARE @indexid INT;
    DECLARE @partitioncount BIGINT;
    DECLARE @schemaname NVARCHAR(130);
    DECLARE @objectname NVARCHAR(130);
    DECLARE @indexname NVARCHAR(130);
    DECLARE @partitionnum BIGINT;
    DECLARE @partitions BIGINT;
    DECLARE @frag FLOAT;
    DECLARE @pagecount INT;
    DECLARE @command NVARCHAR(4000);
    DECLARE @page_count_minimum SMALLINT
    SET @page_count_minimum = 1000
    DECLARE @fragmentation_minimum FLOAT
    SET @fragmentation_minimum = 30.0

-- Creo una tabla, en caso de no existir para llevar un log de trabajo
IF OBJECT_ID('LogRegeneraIndices') IS NULL
 BEGIN
   CREATE TABLE LogRegeneraIndices (
		[Base] nvarchar(50),
		[indexname] NVARCHAR(130),
		[objectname] NVARCHAR(130),
		[frag] float,
		[pagecount] int,
		[Start] Datetime,
		Final Datetime,
		command nvarchar(400))
		-- Le creo un indices
		CREATE INDEX idex_LogRegeneraIndices 
		ON LogRegeneraIndices ([indexname],[objectname])
 END

-- Seleccione condicionalmente tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir ID de índice y objeto en nombres, solo de 100 en 100.
IF OBJECT_ID(N'tempdb..#work_to_do', N'U') IS NOT NULL 
DROP TABLE #work_to_do
    SELECT top 100 object_id AS objectid ,
            index_id AS indexid ,
            partition_number AS partitionnum ,
            avg_fragmentation_in_percent AS frag ,
            page_count AS page_count
    INTO    #work_to_do
    FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL,'LIMITED')
    WHERE   avg_fragmentation_in_percent >= @fragmentation_minimum
	        AND index_id > 0
            AND page_count > @page_count_minimum

-- Verifico si aun hay indices por regenerar
IF @@ROWCOUNT = 0
 BEGIN
DECLARE @profile_name sysname = 'No reply',
		@recipients varchar(max) = 'mycorreo@live.com.mx',  
		@copy_recipients varchar(max) = NULL,
		@blind_copy_recipients varchar(max),
		@subject nvarchar(255) = 'Termino mantenimiento a indices en ' + @DB,
		@body nvarchar(max) = 'Ya no existen indices por procesar en ' + @DB,
		@file_attachments nvarchar(max) 
	 EXEC msdb.dbo.sp_send_dbmail  
		@profile_name=@profile_name,
		@recipients=@recipients,
		@copy_recipients=@copy_recipients,
		@blind_copy_recipients=@blind_copy_recipients,
		@subject=@subject,
		@body=@body,
		@file_attachments=@file_attachments
     RETURN
 END

-- Modifico el tipo de recuperacion a SIMPLE
	SET @SQLString = 'ALTER DATABASE ['+@DB+'] SET RECOVERY SIMPLE'
	SET @ParmDefinition = N'@DB sysname'
   EXEC sp_executesql @SQLString, @ParmDefinition, @DB=@DB

IF CURSOR_STATUS('global', 'partitions') >= -1
BEGIN
   -- PRINT 'partitions CURSOR DELETED' ;
    CLOSE partitions
    DEALLOCATE partitions
END

-- Declare el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR LOCAL
FOR
    SELECT  *
    FROM    #work_to_do

-- Se abre el cursor.
    OPEN partitions
-- Recorre la particiónes.
    WHILE ( 1 = 1 )
        BEGIN
            FETCH NEXT
                    FROM partitions
                    INTO @objectid, @indexid, @partitionnum, @frag, @pagecount;
            IF @@FETCH_STATUS < 0
                BREAK

           -- Inserto en la tabla de log, el indice que se esta procesando
           INSERT INTO LogRegeneraIndices (base, indexname, objectname, frag, pagecount, start)
           Values (DB_NAME(DB_ID()), @indexname, @objectname, @frag, @pagecount, getdate())

            SELECT  @objectname = QUOTENAME(o.name),
                    @schemaname = QUOTENAME(s.name)
            FROM    sys.objects AS o
                    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
            WHERE   o.object_id = @objectid;
            SELECT  @indexname = QUOTENAME(name)
            FROM    sys.indexes
            WHERE   object_id = @objectid
                    AND index_id = @indexid
                    AND QUOTENAME(name) IS NOT NULL

            SELECT  @partitioncount = COUNT(*)
            FROM    sys.partitions
            WHERE   object_id = @objectid
                    AND index_id = @indexid

            SET @command = N'ALTER INDEX ' + @indexname + N' ON '
                + @schemaname + N'.' + @objectname + N' REBUILD'

            IF @partitioncount > 1
                SET @command = @command + N' PARTITION = '
                    + CAST(@partitionnum AS NVARCHAR(10));
                EXEC (@command)
                -- print (@command); //uncomment for testing

            -- Actualizo la tabla LogRegeneraIndices
	UPDATE LogRegeneraIndices SET Final = GETDATE(),
	command = @command
	WHERE objectname = @objectname
	AND indexname = @indexname

            -- Si dan las 7 am y no ha terminado, termina el ciclo
            IF DATEPART(HH,GETDATE()) = 7
                BREAK;

            --PRINT N'Rebuilding index ' + @indexname + ' on table '
            --    + @objectname;
            --PRINT N'  Fragmentation: ' + CAST(@frag AS VARCHAR(15));
            --PRINT N'  Page Count:    ' + CAST(@pagecount AS VARCHAR(15));
            --PRINT N' ';
        END

-- Cierra y elimina el cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

-- Regreso la base a FULL en su tipo de recuperacion
	SET @SQLString = 'ALTER DATABASE ['+@DB+'] SET RECOVERY FULL'
	SET @ParmDefinition = N'@DB sysname'
   EXEC sp_executesql @SQLString, @ParmDefinition, @DB=@DB

-- Elimina la tabla temporal.
DROP TABLE #work_to_do;

--COMMIT TRAN

-- Actualizo estadisticos
EXEC sp_updatestats

END TRY

BEGIN CATCH
--ROLLBACK TRAN

 SELECT @profile_name = 'No reply',
		@recipients = 'mycorreo@live.com.mx',  
		@copy_recipients = 'isaias.islas@live.com.mx',
		@blind_copy_recipients = NULL,
		@subject = 'Se encontro un error: ' + ERROR_MESSAGE(),
		@body = 'El proceso de regeneracion de indices fallo',
		@file_attachments = NULL
	 EXEC msdb.dbo.sp_send_dbmail  
		@profile_name=@profile_name,
		@recipients=@recipients,
		@copy_recipients=@copy_recipients,
		@blind_copy_recipients=@blind_copy_recipients,
		@subject=@subject,
		@body=@body,
		@file_attachments=@file_attachments
END CATCH

END

GO


