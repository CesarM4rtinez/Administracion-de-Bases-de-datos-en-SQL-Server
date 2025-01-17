/*
 * Security Queries: Server-level
 * Released on 2013-10-24 by Greg Drake
 * Compatible with SQL Server 2005+
 * 
 * This set of queries attempts to gather as much security-related information on a single server as possible.
 * The output for any of these should be the same regardless of the currently selected database.
 * How to use this script to compare multiple servers or environments...
 *     (1) Set "Results to text"
 *     (2) Execute the entire script as a single batch.
 *     (3) Save results in text files 
 *     (4) Use any common text file comparison/merge application (e.g. WinMerge, Beyond Compare)
 * Note that many result sets have columns commented out to make comparison easier. These columns (mostly dates) will always be different and generally aren't that useful.
 *
 * Included queries:
 
    Server information & settings
    Server roles
    Server logins
    Server role membership
    Server role and login permissions
    Server-level SQL/Assembly module EXECUTE AS
    Database ownership
    SQL Agent Job ownership
    SQL Agent Schedule ownership
    SSIS package ownership
    Maintenance plan ownership

 */


-- Runtime context
PRINT 'Executed by ' + quotename(suser_sname()) + ' on server ' + quotename(@@servername) + ' at ' + convert(varchar(50), getdate(), 120) + '.' + (char(13) + char(10)) + (char(13) + char(10))


PRINT 'SERVER INFORMATION & SETTINGS'
SELECT
	[item]
	,[value]
FROM
	(
		(SELECT           [order] = 10, [item] = convert(nvarchar(30), 'authentication_mode'), [value] = convert(nvarchar(128), CASE serverproperty('IsIntegratedSecurityOnly') WHEN 1 THEN 'Windows Authentication mode' WHEN 0 THEN 'SQL Server and Windows Authentication mode (mixed mode)' END))
		UNION ALL (SELECT [order] = 15, [item] = convert(nvarchar(30), 'single-user_mode'   ), [value] = convert(nvarchar(128), serverproperty('IsSingleUser')))
		UNION ALL (SELECT [order] = 20, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'remote access')
		UNION ALL (SELECT [order] = 25, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'remote login timeout (s)')
		UNION ALL (SELECT [order] = 30, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'remote admin connections')
		UNION ALL (SELECT [order] = 35, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'clr enabled')
		UNION ALL (SELECT [order] = 40, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'xp_cmdshell')
		UNION ALL (SELECT [order] = 45, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'c2 audit mode')
		UNION ALL (SELECT [order] = 50, [item] = convert(nvarchar(30), [name]               ), [value] = convert(nvarchar(128), value_in_use) FROM sys.configurations WHERE [name] = N'cross db ownership chaining')
	) ugly_union_derived_table
ORDER BY
	[order]


PRINT 'SERVER ROLES'
SELECT
	'role_name' = ssp_r.[name]
	,ssp_r.is_disabled
	--,ssp_r.create_date
	--,ssp_r.modify_date
FROM
	sys.server_principals ssp_r
WHERE
	ssp_r.[type] = 'R'
ORDER BY
	ssp_r.[name]


PRINT 'SERVER LOGINS'
SELECT
	'login_type'  = ssp_l.type_desc
	,'login_name' = ssp_l.[name]
	,ssp_l.is_disabled
	--,ssp_l.create_date
	--,ssp_l.modify_date
	,ssp_l.default_database_name
	,ssp_l.default_language_name
	,sslog.is_policy_checked
	,sslog.is_expiration_checked
FROM
	sys.server_principals ssp_l
	LEFT OUTER JOIN
	sys.sql_logins sslog ON (ssp_l.principal_id = sslog.principal_id)
WHERE
	-- Constraints taken from SQL Server Management Studio > Object Explorer
	(ssp_l.[type] IN ('U', 'G', 'S', 'C', 'K')
	AND ssp_l.principal_id NOT BETWEEN 101 AND 255
	AND ssp_l.[name] <> N'##MS_AgentSigningCertificate##')
ORDER BY
	ssp_l.type_desc
	,ssp_l.[name]


PRINT 'SERVER ROLE MEMBERSHIP'
SELECT
	'role_name'    = ssp_r.[name]
	,'member_type' = isnull(ssp_l.type_desc, N'<NO MEMBERS>')
	,'member_name' = isnull(ssp_l.[name], N'')
FROM
	sys.server_principals ssp_r
	LEFT OUTER JOIN
	(
		sys.server_principals ssp_l
		LEFT OUTER JOIN
		sys.server_role_members ssrm ON (ssp_l.principal_id = ssrm.member_principal_id)
	) ON (
		ssp_r.principal_id = ssrm.role_principal_id
		AND (
			-- A role can be a member of another role, so this query is general in terms of the member
			ssp_l.[type] = 'R'
			OR (
				-- Constraints taken from SQL Server Management Studio > Object Explorer
				ssp_l.[type] IN ('U', 'G', 'S', 'C', 'K')
				AND ssp_l.principal_id NOT BETWEEN 101 AND 255
				AND ssp_l.[name] <> N'##MS_AgentSigningCertificate##'
			)
		)
	)
WHERE
	ssp_r.[type] = 'R'
ORDER BY
	ssp_r.[name]
	,ssp_l.type_desc
	,ssp_l.[name]


PRINT 'SERVER ROLE AND LOGIN PERMISSIONS'
SELECT
	'principal_type'   = ssp.type_desc
	,'principal_name'  = ssp.[name]
	,'class'           = isnull(ssper.class_desc, N'<NO_SECURABLES>')
	,'object_name'     = isnull(convert(nvarchar(128), CASE
		WHEN (ssper.class = 100) /* Server           */ THEN serverproperty(N'Servername')
		WHEN (ssper.class = 101) /* Server-principal */ THEN (SELECT lookup_ssp.[name] FROM sys.server_principals lookup_ssp WHERE lookup_ssp.principal_id = ssper.major_id)
		WHEN (ssper.class = 105) /* Endpoint         */ THEN (SELECT lookup_sep.[name] FROM sys.endpoints lookup_sep WHERE lookup_sep.endpoint_id = ssper.major_id)
		ELSE (N'<UNHANDLED_LOOKUP class=' + convert(nvarchar(20), ssper.class) + N', major_id=' + convert(nvarchar(20), ssper.major_id) + N', minor_id=' + convert(nvarchar(20), ssper.minor_id) + N'>')
	END), N'')
	,'permission_name' = isnull(ssper.permission_name, N'')
	,'state'           = isnull(ssper.state_desc, N'')
	--,[granted_by]      = (SELECT ssp2.[name] FROM sys.server_principals ssp2 WHERE ssp2.principal_id = ssper.grantor_principal_id)
FROM
	sys.server_principals AS ssp
	LEFT OUTER JOIN
	sys.server_permissions AS ssper ON (ssp.principal_id = ssper.grantee_principal_id)
WHERE
	ssp.[type] = 'R'
	OR (
		-- Constraints taken from SQL Server Management Studio > Object Explorer
		ssp.[type] IN ('U', 'G', 'S', 'C', 'K')
		AND ssp.principal_id NOT BETWEEN 101 AND 255
		AND ssp.[name] <> N'##MS_AgentSigningCertificate##'
	)
ORDER BY
	ssp.type_desc
	,ssp.[name]
	,CASE
		WHEN (ssper.class = 100) /* Server           */ THEN convert(sysname, serverproperty(N'Servername'))
		WHEN (ssper.class = 101) /* Server-principal */ THEN (SELECT lookup_ssp.[name] FROM sys.server_principals lookup_ssp WHERE lookup_ssp.principal_id = ssper.major_id)
		WHEN (ssper.class = 105) /* Endpoint         */ THEN (SELECT lookup_sep.[name] FROM sys.endpoints lookup_sep WHERE lookup_sep.endpoint_id = ssper.major_id)
		ELSE NULL
	END
	,ssper.permission_name
	,ssper.state_desc


PRINT 'SERVER-LEVEL SQL/ASSEMBLY MODULE EXECUTE AS'
-- TODO: Test this query with better data
SELECT
	'object_type'                = coalesce(ssl_sql.type_desc, ssl_ass.type_desc)
	,'object_name'               = coalesce(ssl_sql.[name], ssl_ass.[name])
	,'execute_as_principal_type' = CASE WHEN coalesce(sssm.execute_as_principal_id, ssam.execute_as_principal_id) = -2 THEN N'OWNER' ELSE ssp.type_desc END
	,'execute_as_principal'      = ssp.name
FROM
	(
		sys.server_triggers ssl_sql
		INNER JOIN
		sys.server_sql_modules sssm ON (ssl_sql.[object_id] = sssm.[object_id])
	)
	FULL OUTER JOIN
	(
		sys.server_triggers ssl_ass
		INNER JOIN
		sys.server_assembly_modules ssam ON (ssl_ass.[object_id] = ssam.[object_id])
	) ON (ssl_sql .[object_id] = ssl_ass.[object_id])
	LEFT OUTER JOIN
	sys.server_principals ssp ON (coalesce(sssm.execute_as_principal_id, ssam.execute_as_principal_id) = ssp.principal_id)
WHERE
	sssm.execute_as_principal_id IS NOT NULL
	OR ssam.execute_as_principal_id IS NOT NULL
ORDER BY
	coalesce(ssl_sql.type_desc, ssl_ass.type_desc)
	,coalesce(ssl_sql.[name], ssl_ass.[name])
	,CASE WHEN coalesce(sssm.execute_as_principal_id, ssam.execute_as_principal_id) = -2 THEN N'OWNER' ELSE ssp.type_desc END
	,ssp.name


PRINT 'DATABASE OWNERSHIP'
SELECT
	'database_name' = sd.[name]
	,'owner_type'   = ssp.type_desc
	,'owner_name'   = ssp.[name]
FROM
	sys.databases sd
	LEFT OUTER JOIN
	sys.server_principals ssp ON (sd.owner_sid = ssp.[sid])
ORDER BY
	sd.[name]


PRINT 'SQL AGENT JOB OWNERSHIP'
SELECT
	'job_name'    = mdsj.[name]
	,'owner_type' = ssp.type_desc
	,'owner_name' = ssp.[name]
FROM
	msdb.dbo.sysjobs mdsj
	LEFT OUTER JOIN
	sys.server_principals ssp ON (mdsj.owner_sid = ssp.[sid])
ORDER BY
	mdsj.[name]


PRINT 'SQL AGENT SCHEDULE OWNERSHIP'
SELECT
	'schedule_name' = mdss.[name]
	,'owner_type'   = ssp.type_desc
	,'owner_name'   = ssp.[name]
FROM
	msdb.dbo.sysschedules mdss
	LEFT OUTER JOIN
	sys.server_principals ssp ON (mdss.owner_sid = ssp.[sid])
ORDER BY
	mdss.[name]


PRINT 'SSIS PACKAGE OWNERSHIP'
IF ((SELECT [compatibility_level] FROM sys.databases WHERE [name] = N'msdb') = 90)
BEGIN
	SELECT
		'package_name' = mdsssisp.[name]
		,'owner_type'  = ssp.type_desc
		,'owner_name'  = ssp.[name]
	FROM
		msdb.dbo.sysdtspackages90 mdsssisp
		LEFT OUTER JOIN
		sys.server_principals ssp ON (mdsssisp.ownersid = ssp.[sid])
	ORDER BY
		mdsssisp.[name]
END
ELSE
BEGIN
	SELECT
		'package_name' = mdsssisp.[name]
		,'owner_type'  = ssp.type_desc
		,'owner_name'  = ssp.[name]
	FROM
		msdb.dbo.sysssispackages mdsssisp
		LEFT OUTER JOIN
		sys.server_principals ssp ON (mdsssisp.ownersid = ssp.[sid])
	ORDER BY
		mdsssisp.[name]
END


PRINT 'MAINTENANCE PLAN OWNERSHIP'
SELECT
	'plan_name'   = mdsdmp.plan_name
	,'owner_type' = isnull(ssp.type_desc, 'NOT_FOUND')
	,'owner_name' = mdsdmp.[owner]
FROM
	msdb.dbo.sysdbmaintplans mdsdmp
	LEFT OUTER JOIN
	sys.server_principals ssp ON (mdsdmp.[owner] = ssp.[name])
ORDER BY
	mdsdmp.plan_name

