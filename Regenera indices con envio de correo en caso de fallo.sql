/*----------------------------------------------
Reconstruye los indices dañados por mas del 30%
Islas (DR) Mexico
*/----------------------------------------------


-- MyDatabase, modifique este nombre por el de su base de datos

IF OBJECT_ID('tempdb..#work_to_do') IS NOT NULL
        DROP TABLE tempdb..#work_to_do

BEGIN TRY
--BEGIN TRAN
USE [DB Completa]  -- Cambie por su nombre de base de datos
-- Modifico el tipo de recuperacion a SIMPLE
ALTER DATABASE [DB Completa] SET RECOVERY SIMPLE
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

-- Seleccione condicionalmente tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir ID de índice y objeto en nombres.

    SELECT  top (10) --< Solo se procesaran 10 indices del total dañados
	    object_id AS objectid ,
            index_id AS indexid ,
            partition_number AS partitionnum ,
            avg_fragmentation_in_percent AS frag ,
            page_count AS page_count
    INTO    #work_to_do

    FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL,'LIMITED')
    WHERE   avg_fragmentation_in_percent > @fragmentation_minimum
	        AND index_id > 0
            AND page_count > @page_count_minimum;

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
        FROM    #work_to_do;

-- Se abre el cursor.
    OPEN partitions;
-- Recorre la partición.
    WHILE ( 1 = 1 )
        BEGIN;
            FETCH NEXT
                    FROM partitions
                    INTO @objectid, @indexid, @partitionnum, @frag, @pagecount;
            IF @@FETCH_STATUS < 0
                BREAK;

            SELECT  @objectname = QUOTENAME(o.name) ,
                    @schemaname = QUOTENAME(s.name)
            FROM    sys.objects AS o
                    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
            WHERE   o.object_id = @objectid;
            SELECT  @indexname = QUOTENAME(name)
            FROM    sys.indexes
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SELECT  @partitioncount = COUNT(*)
            FROM    sys.partitions
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SET @command = N'ALTER INDEX ' + @indexname + N' ON '
                + @schemaname + N'.' + @objectname + N' REBUILD';

            IF @partitioncount > 1
                SET @command = @command + N' PARTITION='
                    + CAST(@partitionnum AS NVARCHAR(10));
            EXEC (@command);
            -- print (@command); //uncomment for testing
                    -- Si dan las 7 am y no ha terminado, termina el ciclo
            IF DATEPART(HH,GETDATE()) = 7
                BREAK;

            PRINT N'Rebuilding index ' + @indexname + ' on table '
                + @objectname;
            PRINT N'  Fragmentation: ' + CAST(@frag AS VARCHAR(15));
            PRINT N'  Page Count:    ' + CAST(@pagecount AS VARCHAR(15));
            PRINT N' ';
        END;

-- Cierra y elimina el cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

-- Regreso la base a FULL en su tipo de recuperacion
    ALTER DATABASE MyDatabase SET RECOVERY FULL
-- Elimina la tabla temporal.
    DROP TABLE #work_to_do;

--COMMIT TRAN

-- Actualizo estadisticos
EXEC sp_updatestats

END TRY

BEGIN CATCH
--ROLLBACK TRAN
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'SuProfile',  
    @recipients = 'SuCuentaDeCorreos@live.com',  --< Cambie la cuenta de correos
    @body = 'El proceso de regeneracion de indices fallo',
    @subject = 'Se encontro un error:' + ERROR_MESSAGE(); 
    --PRINT 'Se encontro un error:' + ERROR_MESSAGE()
END CATCH
