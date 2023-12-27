USE [AdventureWorks2014]
GO
CREATE DATABASE AUDIT SPECIFICATION 
[DatabaseAuditSpecification-TriggerDB]
FOR SERVER AUDIT [Audit-TriggerDB-DB]
ADD (SELECT ON DATABASE::[AdventureWorks2014] BY [public]),
ADD (UPDATE ON DATABASE::[AdventureWorks2014] BY [public]),
ADD (DELETE ON DATABASE::[AdventureWorks2014] BY [public]),
ADD (SELECT ON DATABASE::[AdventureWorks2014] BY [dbo]),
ADD (UPDATE ON DATABASE::[AdventureWorks2014] BY [dbo]),
ADD (DELETE ON DATABASE::[AdventureWorks2014] BY [dbo])
WITH (STATE = ON)
GO


