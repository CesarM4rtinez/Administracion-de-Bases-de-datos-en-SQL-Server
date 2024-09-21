CREATE DATABASE DB_CesarMartinez
ON PRIMARY
(
  NAME='DB_CesarMartinez_Primary', FILENAME='D:\Documentos\Trabajos\PERSONALES\Programa de Especializacion en Base de datos con SQL SERVER\DB_CesarMartinez.mdf',
  SIZE=8mb, FILEGROWTH=20%
),
FILEGROUP DATA DEFAULT
(
  NAME='DB_CesarMartinez_DataDefault', FILENAME='D:\Documentos\Trabajos\PERSONALES\Programa de Especializacion en Base de datos con SQL SERVER\DB_CesarMartinez.ndf',
  SIZE=8mb, FILEGROWTH=20%
)
LOG ON
(
  NAME='DB_CesarMartinez_log', FILENAME='D:\Documentos\Trabajos\PERSONALES\Programa de Especializacion en Base de datos con SQL SERVER\DB_CesarMartinez.ldf',
  SIZE=8mb, FILEGROWTH=20%
)
GO --SCRIPT DE CÉSAR MARTÍNEZ | CREACIÓN DE UNA BASE DE DATOS CON BUENAS PRÁCTICAS HACIENDO USO DE LOS FILEGROUPS

CREATE TABLE CellPhone(
   Imei             VARCHAR(20),

   Brand            VARCHAR(20),
   Model            VARCHAR(40),
   Imsi             VARCHAR(20),
   AreaCode         INT,
   CellPhoneNumber  INT,
   Status           CHAR(1),
   CreatedBy        VARCHAR(20),
   CreationDate     DATETIME2,
   UpdatedBy        VARCHAR(20),
   UpdateDate       DATETIME2,

   CONSTRAINT PK_CellPhone PRIMARY KEY (Imei),
)
GO

CREATE TABLE PCMCUser(
   UserId              INT,

   Title               VARCHAR(5),
   Name                VARCHAR(50),
   Surname             VARCHAR(50),
   Username            VARCHAR(20),
   Password            VARCHAR(100),
   Email               VARCHAR(60),
   Status              CHAR(1),
   IsBlocked           SMALLINT,
   SecretQuestion      VARCHAR(100),
   SecretAnswer        VARCHAR(100),
   LoginNumTries       INT,
   CreatedBy           VARCHAR(20),
   CreationDate        DATETIME2,
   UpdatedBy           VARCHAR(20),
   UpdateDate          DATETIME2,
   LastDatePasswordChange DATETIME2,
   IsSystem            CHAR(1),
   Imei                VARCHAR(20),

   CONSTRAINT PK_PCMCUser  PRIMARY KEY (UserId),
   CONSTRAINT FK_CellPhone FOREIGN KEY (Imei) REFERENCES CellPhone(Imei) ON DELETE CASCADE
)
GO


CREATE TABLE Role(
   RoleId           INT,
   
   Name             VARCHAR(20),
   Description      VARCHAR(80),
   Status           CHAR(1),
   CreatedBy        VARCHAR(20),
   CreationDate     DATETIME2,
   UpdatedBy        VARCHAR(20),
   UpdateDate       DATETIME2,

   CONSTRAINT PK_Role PRIMARY KEY (RoleId)
)
GO

CREATE TABLE UserRole(
   UserRoleId       INT,
   UserId           INT,
   RoleId           INT,

   CreatedBy        VARCHAR(20),
   CreationDate     DATETIME2,
   UpdatedBy        VARCHAR(20),
   UpdateDate       DATETIME2,

   CONSTRAINT PK_UserRole PRIMARY KEY (UserRoleId),
   CONSTRAINT FK_User FOREIGN KEY (UserId) REFERENCES PCMCUser(UserId),
   CONSTRAINT FK_Role FOREIGN KEY (RoleId) REFERENCES Role(RoleId)
)
GO


CREATE TABLE Module(
   ModuleId             INT,
   ParentId             INT,

   Name                 VARCHAR(40),
   Code                 VARCHAR(10),
   Url                  VARCHAR(50),
   OrderNo              INT,
   HasAccessAction      CHAR(1),
   HasQueryAction       CHAR(1),
   HasAddAction         CHAR(1),
   HasEditAction        CHAR(1),
   HasDeleteAction      CHAR(1),
   HasPostAction        CHAR(1),
   HasSpecial1Action    CHAR(1),
   HasSpecial2Action    CHAR(1),
   HasSpecial3Action    CHAR(1),
   HasSpecial4Action    CHAR(1),
   HasSpecial5Action    CHAR(1),
   HasSpecial6Action    CHAR(1),
   DefaultValueAccess   CHAR(1),
   DefaultValueQuery    CHAR(1),
   DefaultValueAdd      CHAR(1),
   DefaultValueEdit     CHAR(1),
   DefaultValueDelete   CHAR(1),
   DefaultValueSpecial1 CHAR(1),
   DefaultValueSpecial2 CHAR(1),
   DefaultValueSpecial3 CHAR(1),
   DefaultValueSpecial4 CHAR(1),
   DefaultValueSpecial5 CHAR(1),
   DefaultValueSpecial6 CHAR(1),
   AccessDescription    VARCHAR(20),
   QueryDescription     VARCHAR(60),
   AddDescription       VARCHAR(60),
   EditDescription      VARCHAR(60),
   DeleteDescription    VARCHAR(60),
   PostDescription      VARCHAR(60),
   Special1Description  VARCHAR(60),
   Special2Description  VARCHAR(60),
   Special3Description  VARCHAR(60),
   Special4Description  VARCHAR(60),
   Special5Description  VARCHAR(60),
   Special6Description  VARCHAR(60),
   Status               CHAR(1),
   HasSubModules        CHAR(1),
   DisplayFlag          CHAR(1),
   CreateBy             VARCHAR(20),
   CreationDate         DATETIME2,
   UpdatedBy            VARCHAR(20),
   UpdateDate           DATETIME2,

   CONSTRAINT PK_Module PRIMARY KEY (ModuleId),
   CONSTRAINT FK_Parent FOREIGN KEY (ParentId) REFERENCES Module(ModuleId)
)
GO

CREATE TABLE Permission(
   PermissionId     INT,
   RoleId           INT,
   ModuleId         INT,

   AccessAction     INT,
   QueryAction      INT,
   AddAction        INT,
   EditAction       INT,
   DeleteAction     INT,
   PostAction       INT,
   Special1Action   INT,
   Special2Action   INT,
   Special3Action   INT,
   Special4Action   INT,
   Special5Action   INT,
   Special6Action   INT,
   Status           CHAR(1),
   CreatedBy        VARCHAR(20),
   CreationDate     DATETIME2,
   UpdatedBy        VARCHAR(20),
   UpdateDate       DATETIME2,

   CONSTRAINT PK_Permission PRIMARY KEY (PermissionId),
   CONSTRAINT FK_Module     FOREIGN KEY (ModuleId) REFERENCES Module(ModuleId),
   CONSTRAINT FK_permissionRole FOREIGN KEY (RoleId)   REFERENCES Role(RoleId)
)
GO