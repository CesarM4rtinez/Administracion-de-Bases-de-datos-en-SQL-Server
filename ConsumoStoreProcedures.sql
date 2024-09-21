SELECT stxt.dbid,p.name AS [SP Name], qs.total_logical_reads AS [TotalLogicalReads],
qs.total_logical_reads/qs.execution_count AS [AvgLogicalReads],qs.execution_count,
ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second],
qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count
AS [avg_elapsed_time], qs.cached_time,stxt.[text]--Contenido del SP
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as stxt
ON p.[object_id] = qs.[object_id]
WHERE stxt.text like '%DetalleVenta%'
ORDER BY avg_elapsed_time DESC;