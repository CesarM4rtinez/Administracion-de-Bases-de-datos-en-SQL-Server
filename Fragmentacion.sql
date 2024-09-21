select 
'[' + sc.name + '].[' + object_name(ips.object_id,ips.database_id) + ']' as ObjectName,
'[' + si.name + ']' as index_name, au.total_pages/128 as TotalMB,au.used_pages/128 as UsadoMB, 
au.data_pages/128 as DataMB,
ips.avg_fragmentation_in_percent, ips.fragment_count, ips.avg_fragment_size_in_pages,ips.index_type_desc, 
'alter index [' + si.name + '] on [' + sc.name + '].[' + object_name(ips.object_id,ips.database_id) + '] rebuild with (FILLFACTOR=90);' as strSQL
-- ips.* 
from master.sys.dm_db_index_physical_stats(db_id('TSQL'),NULL,NULL,NULL,'DETAILED') as ips 
inner join sys.tables as so on ips.object_id=so.object_id
inner join sys.indexes AS si on ips.object_id = si.object_id AND ips.index_id = si.index_id
inner join sys.schemas as sc on so.schema_id=sc.schema_id
inner join sys.partitions as pt on pt.object_id=so.object_id and si.index_id=pt.index_id
inner join sys.allocation_units as au on pt.partition_id=au.container_id
where ips.avg_fragmentation_in_percent>=10 and ips.index_id>0;