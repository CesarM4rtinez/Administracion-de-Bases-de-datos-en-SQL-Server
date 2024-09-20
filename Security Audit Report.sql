/*
Security Audit Report -- Informe de auditoría de seguridad
1) Enumere todos los accesos proporcionados a un usuario de sql o usuario/grupo de Windows directamente
2) Enumere todos los accesos proporcionados a un usuario de sql o a un usuario/grupo de Windows a través de una función de base de datos o aplicación
3) Enumere todos los accesos proporcionados al rol público

Columnas devueltas:
Nombre de usuario: cuenta de usuario de SQL o Windows/Active Directory. Esto también podría ser un grupo de Active Directory.
UserType: el valor será 'Usuario de SQL' o 'Usuario de Windows'. Esto refleja el tipo de usuario definido para el
                   Cuenta de usuario de SQL Server.
DatabaseUserName: nombre del usuario asociado tal como se define en la cuenta de usuario de la base de datos. El usuario de la base de datos puede no ser el
                   igual que el usuario del servidor.
Función: el nombre de la función. Esto será nulo si los permisos asociados al objeto se definen directamente
                   en la cuenta de usuario; de lo contrario, este será el nombre del rol del que el usuario es miembro.
PermissionType: Tipo de permisos que tiene el usuario/rol sobre un objeto. Los ejemplos podrían incluir CONECTAR, EJECUTAR, SELECCIONAR
                   ELIMINAR, INSERTAR, ALTERAR, CONTROLAR, TOMAR PROPIEDAD, VER DEFINICIÓN, etc.
                   Es posible que este valor no se complete para todos los roles. Algunas funciones integradas tienen permiso implícito
                   definiciones
PermissionState: refleja el estado del tipo de permiso, los ejemplos podrían incluir GRANT, DENY, etc.
                   Es posible que este valor no se complete para todos los roles. Algunas funciones integradas tienen permiso implícito
                   definiciones
ObjectType : tipo de objeto sobre el que se asignan permisos al usuario/rol. Los ejemplos podrían incluir USER_TABLE,
                   SQL_SCALAR_FUNCTION, SQL_INLINE_TABLE_VALUED_FUNCTION, SQL_STORED_PROCEDURE, VISTA, etc.
                   Es posible que este valor no se complete para todos los roles. Algunas funciones integradas tienen permiso implícito
                   definiciones
ObjectName: nombre del objeto sobre el que se asignan permisos al usuario/rol.
                   Es posible que este valor no se complete para todos los roles. Algunas funciones integradas tienen permiso implícito
                   definiciones
ColumnName: nombre de la columna del objeto en el que se asignan permisos al usuario/rol. Este valor
                   solo se completa si el objeto es una tabla, una vista o una función de valor de tabla.                
*/

-- Enumere todos los accesos proporcionados a un usuario de sql o usuario/grupo de Windows directamente 
SELECT  
    [UserName] = CASE princ.[type] 
                    WHEN 'S' THEN princ.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE princ.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END,  
    [DatabaseUserName] = princ.[name],       
    [Role] = null,      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],       
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Usuario de la base de datos
    sys.database_principals princ  
LEFT JOIN
    --Iniciar sesión cuentas
    sys.login_token ulogin on princ.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permisos
    sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
LEFT JOIN
    --Columnas de la tabla
    sys.columns col ON col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE 
    princ.[type] in ('S','U')
UNION
--Enumere todos los accesos aprovisionados a un usuario de sql 
--o un usuario/grupo de Windows a través de una función de base de datos o aplicación
SELECT  
    [UserName] = CASE memberprinc.[type] 
                    WHEN 'S' THEN memberprinc.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE memberprinc.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END, 
    [DatabaseUserName] = memberprinc.[name],   
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],   
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Asociaciones de roles/miembros
    sys.database_role_members members
JOIN
    --Roles
    sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
JOIN
    --Miembros del rol (usuarios de la base de datos)
    sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
LEFT JOIN
    --Iniciar sesión cuentas
    sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permisos
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Columnas de la tabla
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
UNION
--Enumere todos los accesos proporcionados al rol público, que todos obtienen de forma predeterminada
SELECT  
    [UserName] = '{All Users}',
    [UserType] = '{All Users}', 
    [DatabaseUserName] = '{All Users}',       
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],  
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Roles
    sys.database_principals roleprinc
LEFT JOIN        
    --Permisos de rol
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Columnas de la tabla
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]                   
JOIN 
    --Todos los objetos  
    sys.objects obj ON obj.[object_id] = perm.[major_id]
WHERE
    --Solo roles
    roleprinc.[type] = 'R' AND
    --Solo función pública
    roleprinc.[name] = 'public' AND
    --Solo objetos nuestros, no los objetos MS.
    obj.is_ms_shipped = 0
ORDER BY
    princ.[Name],
    OBJECT_NAME(perm.major_id),
    col.[name],
    perm.[permission_name],
    perm.[state_desc],
    obj.type_desc --Perm.[class_desc] 