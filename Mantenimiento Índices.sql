SELECT OBJECT_NAME(IDX.object_id)  Table_Name
      , IDX.name  Index_name
	  , PAR.rows  NumOfRows
	  , IDX.type_desc  TypeOfIndex
FROM sys.partitions PAR
INNER JOIN sys.indexes IDX ON PAR.object_id = IDX.object_id  AND PAR.index_id = IDX.index_id AND IDX.type = 0
INNER JOIN sys.tables TBL
ON TBL.object_id = IDX.object_id and TBL.type ='U'
GO

-- Desfragmentar el �ndice previo que tiene un porcentaje alto de fragmentaci�n --
DBCC INDEXDEFRAG (IndexDemoDB, 'STD_Evaluation', IX_STD_Evaluation_STD_Course_Grade);  
GO

-- Reconstrucci�n de �ndice previo --
USE [IndexDemoDB]
GO 
ALTER INDEX [IX_STD_Evaluation_STD_Course_Grade] ON [dbo].[STD_Evaluation] REBUILD PARTITION = ALL WITH (
PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-- Reorganizar �ndice --
USE [IndexDemoDB]
GO
ALTER INDEX [IX_STD_Evaluation_STD_Course_Grade] ON [dbo].[STD_Evaluation] REORGANIZE  WITH ( LOB_COMPACTION = ON )
GO

-- Reconstruir �ndices de una tabla --
ALTER INDEX ALL ON [dbo].[Table name] 
REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = 
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-- Actualizar las estad�sticas de todos los �ndices bajo el nombre de la tabla -- 
UPDATE STATISTICS [Table name]  
GO


-- Actualizar las estad�sticas de solo un �ndice de una tabla --
UPDATE STATISTICS [Table name] [Indice name];  
GO


-- Actualizar las estad�sticas de toda la tabla de �ndices, al especificar el porcentaje de las filas ejemplares --
UPDATE STATISTICS [Table name]   
    WITH SAMPLE 50 PERCENT;
GO

-- Forzar a escanear todas las filas de una tabla durante la actualizaci�n de estad�sticas de la tabla, usando la opci�n FULLSCAN --
UPDATE STATISTICS empleados 
    WITH FULLSCAN, NORECOMPUTE;  
GO