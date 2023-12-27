ALTER SERVER AUDIT [Audit-TriggerDB-DB] 
WITH (STATE = OFF)
GO
USE [master]
GO
ALTER SERVER AUDIT [Audit-TriggerDB-DB]
WHERE ([server_principal_name]<>'sql1' 
AND [server_principal_name]<>'sql2')
GO
ALTER SERVER AUDIT [Audit-TriggerDB-DB] 
WITH (STATE = ON)




