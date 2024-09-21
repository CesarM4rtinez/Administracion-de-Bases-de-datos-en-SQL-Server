--crear un perfil de correo en la base de datos
execute msdb.dbo.sysmail_add_profile_sp
@profile_name='volumetria',
@description='Este perfil es utilizado para mandar notificaciones utilizando Gmail'

--dar acceso a los usuarios a este perfil de correo
execute msdb.dbo.sysmail_add_principalprofile_sp
	@profile_name='volumetria',
	@principal_name='public',
	@is_default=1

	--crear una cuenta de correo en la base de datos
execute msdb.dbo.sysmail_add_account_sp
	@account_name='procesoVoumetria',
	@description='Cuenta de email utilizada para enviar notificaciones',
	@email_address='desarrollo.md01@megadirect.com.mx', --cuenta de correo electrónico del remitente
	@display_name='Notificaciones para reslpados de la BD',
	@mailserver_name='smtp.gmail.com',
	@port=587,
	@enable_ssl=1,
	@username='desarrollo.md01@megadirect.com.mx',--cuenta de correo electrónico del remitente
	@password='#P@ssw0rd#'--contraseña de la cuenta de correo electrónico del remitente

	--agregar la cuenta al perfil Notificaciones
execute msdb.dbo.sysmail_add_profileaccount_sp
	@profile_name='volumetria',
	@account_name='procesoVoumetria',
	@sequence_number=1

	select *
from msdb.dbo.sysmail_profile p 
join msdb.dbo.sysmail_profileaccount pa on p.profile_id = pa.profile_id 
join msdb.dbo.sysmail_account a on pa.account_id = a.account_id 
join msdb.dbo.sysmail_server s on a.account_id = s.account_id


declare @BODY varchar(max);
set @BODY='<!DOCTYPE html>
                <html lang="en">
                <head>
                <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width", initial-scale=1.0">
                </head>
                <body>
               
                </body>
                </html>';

	Exec msdb.dbo.sp_send_dbmail
		@profile_name='volumetria',
		@recipients='desarrollo.md01@megadirect.com.mx',--cuenta de correo electrónico del destinatario
		--@copy_recipients='alejandro.arizmendi@megadirect.com.mx; soporte.md01@megadirect.com.mx; josefedericoaguilar1991@gmail.com; desarrollo.tmk@megadirect.com.mx',
		@body=@BODY,
		@body_format='HTML',
		@subject='Notificasiones de correo desde SQL server mediante un job'

exec msdb.dbo.sp_send_dbmail
	@profile_name = 'DBA',
	@recipients ='desarrollo.md01@megadirect.com.mx',
	@copy_recipients='josefedericoaguilar1991@gmail.com', 
	@body ='respaldo de BD',
	@subject='Se ejecuto succesfull';

	RESTORE VERIFYONLY
	FROM DISK = 'C:\Data\ReporteInconcert.bak'