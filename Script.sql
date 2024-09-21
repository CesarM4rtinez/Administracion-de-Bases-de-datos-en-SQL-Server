SELECT t.name AS 'Your TableName',
    s.name AS 'Your SchemaName',
    p.rows AS 'Number of Rows in Your Table',
    SUM(a.total_pages) * 8 AS 'Total Space of Your Table (KB)',
    SUM(a.used_pages) * 8 AS 'Used Space of Your Table (KB)',
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS 'Unused Space of Your Table (KB)',
    CASE 
        WHEN i.index_id = 0
            THEN 'Yes'
        ELSE 'No'
        END AS 'Is Your Table a Heap?'
FROM sys.tables t
INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
INNER JOIN sys.partitions p
    ON i.object_id = p.object_id
        AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a
    ON p.partition_id = a.container_id
LEFT JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE i.index_id <= 1 -- 0 for Heap, 1 for Clustered Index
GROUP BY t.name,
    s.name,
    i.index_id,
    p.rows
ORDER BY 'Your TableName';