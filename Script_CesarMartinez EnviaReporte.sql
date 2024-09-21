--Creado por: César Ovidio Martínez Chicas.
--Envio de reporte CSV por correo gmail
Exec msdb.dbo.sp_send_dbmail
@profile_name = 'DBA',
@recipients ='dbaservices.martinezcesar@gmail.com',
@copy_recipients='ovimynez8@gmail.com', 
@body ='Reporte del departamento de recursos humanos.',
@subject='Departamento de RR.HH',
@file_attachments='C:\Users\Administrator\Documents\reporteEmpleados.csv';