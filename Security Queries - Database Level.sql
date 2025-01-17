/* 
 * Security Queries: Database-level
 * Released on 2013-10-24 by Greg Drake 
 * Compatible with SQL Server 2005+
 * 
 * This set of queries attempts to gather as much security-related information on a single database as possible.
 * How to use this script to compare multiple servers or environments...
 *     (1) Set "Results to text"
 *     (2) Execute the entire script as a single batch.
 *     (3) Save results in text files 
 *     (4) Use any common text file comparison/merge application (e.g. WinMerge, Beyond Compare)
 * Note that many result sets have columns commented out to make comparison easier. These columns (mostly dates) will always be different and generally aren't that useful.
 * 
 * Include querys
 
    Database roles
    Database users
    Database role membership
    Database role and user permissions
    Database-level SQL/Assembly module EXECUTE AS
    Schema ownership
    Individual ownership of database objects if not owned by schema
    Database users linked to server login
    Database users that were linked to server login, but are not anymore

 */


-- Runtime context
PRINT 'Executed by ' + quotename(suser_sname()) + ' on server ' + quotename(@@servername) + ' and database ' + quotename(db_name()) + ' at ' + convert(varchar(50), getdate(), 120) + '.' + (char(13) + char(10)) + (char(13) + char(10))


PRINT 'DATABASE ROLES'
SELECT
	'role_name' = sdp_r.[name]
	--,sdp_r.create_date
	--,sdp_r.modify_date
	,'owning_principal' = sdp_o.[name]
	,sdp_r.is_fixed_role
FROM
	sys.database_principals sdp_r
	LEFT OUTER JOIN
	sys.database_principals sdp_o ON (sdp_r.owning_principal_id = sdp_o.principal_id)
WHERE
	sdp_r.[type] = 'R'
ORDER BY
	sdp_r.[name]


PRINT 'DATABASE USERS'
SELECT
	'user_name' = sdp_u.[name]
	,sdp_u.type_desc
	,sdp_u.default_schema_name
	--,sdp_u.create_date
	--,sdp_u.modify_date
	,'owning_principal' = 'dbo'
FROM
	sys.database_principals sdp_u
WHERE
	sdp_u.[type] <> 'R'
ORDER BY
	sdp_u.[name]


PRINT 'DATABASE ROLE MEMBERSHIP'
SELECT
	'role_name'    = sdp_r.[name]
	,'member_type' = isnull(sdp_u.type_desc, N'<NO MEMBERS>')
	,'member_name' = isnull(sdp_u.[name], N'')
FROM
	sys.database_principals sdp_r
	LEFT OUTER JOIN
	(
		sys.database_role_members sdrm
		INNER JOIN
		sys.database_principals sdp_u ON (sdrm.member_principal_id = sdp_u.principal_id)
	) ON (sdp_r.principal_id = sdrm.role_principal_id)
WHERE
	-- A role can be a member of another role, so this query is general in terms of the member
	sdp_r.[type] = 'R'
ORDER BY
	sdp_r.[name]
	,sdp_u.type_desc
	,sdp_u.[name]


PRINT 'DATABASE ROLE AND USER PERMISSIONS'
SELECT
	'principal_type'   = sdp_ru.type_desc
	,'principal_name'  = sdp_ru.name
	,'class'           = isnull(sdper.class_desc, N'<NO_SECURABLES>')
	,'object_type'     = CASE
		WHEN (sdper.class = 1) THEN lookup_sao.type_desc
		WHEN (sdper.class = 4) THEN lookup_sdp.type_desc
		ELSE N''
	END
	,'object_name'     = isnull(CASE
		WHEN (sdper.class =  0) /* Database               */ THEN db_name()
		WHEN (sdper.class =  1) /* Object or Column       */ THEN (schema_name(lookup_sao.[schema_id]) + N'.' + lookup_sao.[name])
		WHEN (sdper.class =  3) /* Schema                 */ THEN schema_name(sdper.major_id)
		WHEN (sdper.class =  4) /* Database Principal     */ THEN lookup_sdp.[name]
	--	WHEN (sdper.class =  5) /* Assembly               */ THEN ???
		WHEN (sdper.class =  6) /* Type                   */ THEN (SELECT (schema_name(lookup_st.[schema_id]) + N'.' + lookup_st.[name]) FROM sys.types lookup_st WHERE sdper.major_id = lookup_st.user_type_id)
	--	WHEN (sdper.class = 10) /* XML Schema Collection  */ THEN ???
	--	WHEN (sdper.class = 15) /* Message Type           */ THEN ???
	--	WHEN (sdper.class = 16) /* Service Contract       */ THEN ???
	--	WHEN (sdper.class = 17) /* Service                */ THEN ???
	--	WHEN (sdper.class = 18) /* Remote Service Binding */ THEN ???
	--	WHEN (sdper.class = 19) /* Route                  */ THEN ???
	--	WHEN (sdper.class = 23) /* Full-Text Catalog      */ THEN ???
	--	WHEN (sdper.class = 24) /* Symmetric Key          */ THEN ???
	--	WHEN (sdper.class = 25) /* Certificate            */ THEN ???
	--	WHEN (sdper.class = 26) /* Asymmetric Key         */ THEN ???
		ELSE (N'<UNHANDLED_LOOKUP class=' + convert(nvarchar(20), sdper.class) + N', major_id=' + convert(nvarchar(20), sdper.major_id) + N', minor_id=' + convert(nvarchar(20), sdper.minor_id) + N'>')
	END, N'')
	,'permission_name' = isnull(sdper.permission_name, N'')
	,'state'           = isnull(sdper.state_desc, N'')
	--,'granted_by'      = (SELECT sdp2.[name] FROM sys.database_principals sdp2 WHERE sdp2.principal_id = sdper.grantor_principal_id)
FROM
	sys.database_principals sdp_ru
	LEFT OUTER JOIN
	sys.database_permissions sdper ON (sdp_ru.principal_id = sdper.grantee_principal_id)
	LEFT OUTER JOIN
	sys.all_objects lookup_sao ON (sdper.major_id = lookup_sao.[object_id])
	LEFT OUTER JOIN
	sys.database_principals lookup_sdp ON (sdper.major_id = lookup_sdp.principal_id)
ORDER BY
	sdp_ru.type_desc
	,sdp_ru.name
	,isnull(sdper.class_desc, N'<NO_SECURABLES>')
	,CASE
		WHEN (sdper.class = 1) THEN lookup_sao.type_desc
		WHEN (sdper.class = 4) THEN lookup_sdp.type_desc
		ELSE N''
	END
	,isnull(CASE
		WHEN (sdper.class =  0) /* Database               */ THEN db_name()
		WHEN (sdper.class =  1) /* Object or Column       */ THEN (schema_name(lookup_sao.[schema_id]) + N'.' + lookup_sao.[name])
		WHEN (sdper.class =  3) /* Schema                 */ THEN schema_name(sdper.major_id)
		WHEN (sdper.class =  4) /* Database Principal     */ THEN lookup_sdp.[name]
	--	WHEN (sdper.class =  5) /* Assembly               */ THEN ???
		WHEN (sdper.class =  6) /* Type                   */ THEN (SELECT (schema_name(lookup_st.[schema_id]) + N'.' + lookup_st.[name]) FROM sys.types lookup_st WHERE sdper.major_id = lookup_st.user_type_id)
	--	WHEN (sdper.class = 10) /* XML Schema Collection  */ THEN ???
	--	WHEN (sdper.class = 15) /* Message Type           */ THEN ???
	--	WHEN (sdper.class = 16) /* Service Contract       */ THEN ???
	--	WHEN (sdper.class = 17) /* Service                */ THEN ???
	--	WHEN (sdper.class = 18) /* Remote Service Binding */ THEN ???
	--	WHEN (sdper.class = 19) /* Route                  */ THEN ???
	--	WHEN (sdper.class = 23) /* Full-Text Catalog      */ THEN ???
	--	WHEN (sdper.class = 24) /* Symmetric Key          */ THEN ???
	--	WHEN (sdper.class = 25) /* Certificate            */ THEN ???
	--	WHEN (sdper.class = 26) /* Asymmetric Key         */ THEN ???
		ELSE (N'<UNHANDLED_LOOKUP class=' + convert(nvarchar(20), sdper.class) + N', major_id=' + convert(nvarchar(20), sdper.major_id) + N', minor_id=' + convert(nvarchar(20), sdper.minor_id) + N'>')
	END, N'')
	,isnull(sdper.permission_name, N'')
	,isnull(sdper.state_desc, N'')


PRINT 'DATABASE-LEVEL SQL/ASSEMBLY MODULE EXECUTE AS'
-- TODO: Test assemblies in this query
SELECT
	'object_type'                = coalesce(sao_sql.type_desc, sao_ass.type_desc)
	,'object_name'               = schema_name(coalesce(sao_sql.[schema_id], sao_ass.[schema_id])) + N'.' + coalesce(sao_sql.[name], sao_ass.[name])
	,'execute_as_principal_type' = CASE WHEN coalesce(sasm.execute_as_principal_id, sam.execute_as_principal_id) = -2 THEN N'OWNER' ELSE sdp.type_desc END
	,'execute_as_principal'      = sdp.[name]
FROM
	(
		sys.all_objects sao_sql
		INNER JOIN
		sys.all_sql_modules sasm ON (sao_sql.[object_id] = sasm.[object_id])
	)
	FULL OUTER JOIN
	(
		sys.all_objects sao_ass
		INNER JOIN
		sys.assembly_modules sam ON (sao_ass.[object_id] = sam.[object_id])
	) ON (sao_sql .[object_id] = sao_ass.[object_id])
	LEFT OUTER JOIN
	sys.database_principals sdp ON (coalesce(sasm.execute_as_principal_id, sam.execute_as_principal_id) = sdp.principal_id)
WHERE
	sasm.execute_as_principal_id IS NOT NULL
	OR sam.execute_as_principal_id IS NOT NULL
ORDER BY
	coalesce(sao_sql.type_desc, sao_ass.type_desc)
	,schema_name(coalesce(sao_sql.[schema_id], sao_ass.[schema_id])) + N'.' + coalesce(sao_sql.[name], sao_ass.[name])
	,CASE WHEN coalesce(sasm.execute_as_principal_id, sam.execute_as_principal_id) = -2 THEN N'OWNER' ELSE sdp.type_desc END
	,sdp.[name]


PRINT 'SCHEMA OWNERSHIP'
SELECT
	'schema'      = ss.[name]
	,'owner_type' = sdp.type_desc
	,'owner_name' = sdp.[name]
FROM
	sys.schemas ss
	LEFT OUTER JOIN
	sys.database_principals sdp ON (ss.principal_id = sdp.principal_id)
ORDER BY
	ss.[name]
	,sdp.type_desc
	,sdp.[name]


PRINT 'INDIVIDUAL OWNERSHIP OF DATABASE OBJECTS IF NOT OWNED BY SCHEMA'
SELECT
	owner_type
	,owner_name
	,object_type
	,[object_name]
FROM
	(
		(
			SELECT
				'owner_type'   = sdp.type_desc
				,'owner_name'  = sdp.name
				,'object_type' = sao.type_desc
				,'object_name' = schema_name(sao.[schema_id]) + N'.' + sao.[name]
			FROM
				sys.all_objects sao
				INNER JOIN
				sys.database_principals sdp ON (sao.principal_id = sdp.principal_id)
		)
		UNION ALL
		(
			SELECT
				'owner_type'   = sdp.type_desc
				,'owner_name'  = sdp.name
				,'object_type' = N'DATA_TYPE'
				,'object_name' = schema_name(st.[schema_id]) + N'.' + st.[name]
			FROM
				sys.types st
				INNER JOIN
				sys.database_principals sdp ON (st.principal_id = sdp.principal_id)
		)
	) derived
ORDER BY
	owner_type
	,owner_name
	,object_type
	,[object_name]


PRINT 'DATABASE USERS LINKED TO SERVER LOGIN'
-- Note that some server logins give access to all databases without showing up here. An example would be members of the sysadmin group.
SELECT
	'db_user_type_desc'      = sdp.type_desc
	,'db_user_name'          = sdp.[name]
	,'svr_login_type_desc'   = ssp.type_desc
	,'svr_login_name'        = ssp.[name]
	,'svr_login_is_disabled' = ssp.is_disabled
FROM
	sys.database_principals sdp
	INNER JOIN
	sys.server_principals ssp ON (sdp.[sid] = ssp.[sid])
ORDER BY
	sdp.type_desc
	,sdp.[name]
	,ssp.type_desc
	,ssp.[name]
	,ssp.is_disabled


PRINT 'DATABASE USERS THAT WERE LINKED TO DATABASE LOGIN, BUT ARE NOT ANYMORE'
SELECT
	'db_user_type_desc'      = sdp.type_desc
	,'db_user_name'          = sdp.[name]
FROM
	sys.database_principals sdp
WHERE
	sdp.[type] = 'S'
	AND sdp.[sid] IS NOT NULL
	AND sdp.[sid] <> 0x0
	AND len(sdp.[sid]) <= 16
	AND suser_sname(sdp.[sid]) IS NULL
ORDER BY
	sdp.type_desc
	,sdp.[name]

IF (@@rowcount > 0)
	PRINT 'NOTE: For information about unlinked users, review online documention for ''sp_change_users_login''.' + (char(13) + char(10))
