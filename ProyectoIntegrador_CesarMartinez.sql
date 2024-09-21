/* 
======================================================================
Elaborado por: César Ovidio Martínez Chicas
Fecha creación: 07/07/2024
Ejercicio: Trabajo Integrador - Reportes csv con sp_sendmail y jobs

Módulo #2: Administrador de Base de datos con SQL Server
======================================================================
*/

--Reporte 
USE AdventureWorks2019
GO

CREATE PROCEDURE USP_RpteHumanResources
AS
BEGIN
/*
	Mostrar a todos los empleados pertenecientes al departamento de Manufactura y de Aeguramiento de calidad.
*/
	select
		e.BusinessEntityID, e.*,
		d.Name
	from HumanResources.Employee e
	inner join HumanResources.EmployeeDepartmentHistory h on h.BusinessEntityID = e.BusinessEntityID
	inner join HumanResources.Department d on d.DepartmentID = h.DepartmentID 
	ORDER BY e.BusinessEntityID DESC
END
GO
--EXEC USP_RpteHumanResources


--Genrar el reporte reporte en .CSV utilizando el comando BCP.
--bcp "EXEC AdventureWorks2019.dbo.USP_RpteHumanResources" queryout "c:\Users\Administrator\Documents\RPTE_RRHH.csv" -c -T -S PC-CESAR


--Enviar reporte por correo con sp_sendmail.
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'DBA',
@recipients = 'aprendedb@gmail.com',
@copy_recipients = 'dbaservices.martinezcesar@gmail.com',
@body = '
Creador por: César Martínez.
Programa: Especialización en base de datos con SQL Server.
Módulo: Administrador de base de datos con SQL Sever.
Actividad: Proyecto Integrador.
-
Documento: Reporte de empleados del depto. de manufactura y aseguramiento de calidad de base de datos AdventureWorks2019.
',
@subject = 'Proyecto Integrador de Aprende Consulting -RE: [Actividades y Ejercicios del Módulo 2 (ABD)]',
@file_attachments = 'c:\Users\Administrator\Documents\RPTE_RRHH.csv'