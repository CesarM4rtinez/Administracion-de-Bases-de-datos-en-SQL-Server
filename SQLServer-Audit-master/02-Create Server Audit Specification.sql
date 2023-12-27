USE [master]
GO

CREATE SERVER AUDIT SPECIFICATION 
[ServerAuditSpecification-triggerdb]
FOR SERVER AUDIT [Audit-TriggerDB-Instance]
ADD (FAILED_LOGIN_GROUP),
ADD (LOGIN_CHANGE_PASSWORD_GROUP)
GO
ALTER SERVER AUDIT SPECIFICATION 
[ServerAuditSpecification-triggerdb]
WITH (STATE = ON);
