DECLARE @PATH VARCHAR(1024)
SELECT @PATH = LOG_FILE_PATH + '*.*'
FROM sys.server_file_audits 
WHERE name = 'Audit-TriggerDB-Instance'

SELECT A.NAME,
       A.class_desc,
	   A.parent_class_desc,
	   A.covering_parent_action_name,
F.* 
FROM sys.fn_get_audit_file 
(@PATH,default,default) as F
left join sys.dm_audit_actions A
on F.action_id = A.action_id 
ORDER BY EVENT_TIME DESC;
GO

