/*
   SOLUCIONAR ERROR 14262 DE ELIMINAR JOB DE LOG SHIPPING EN SQL SERVER

   Siga el siguiente procedimiento.....

Paso 1: Servidor primario Ejecuto las siguientes consultas.

Nota: aquí MyDB es el nombre de su base de datos.

1)eliminar de msdb.dbo.log_shipping_primaries donde primary_database_name = 'MyDB'

2)eliminar de msdb.dbo.log_shipping_monitor_primary donde primary_database= 'MyDB'

3)eliminar de msdb.dbo.log_shipping_primary_databases donde primary_database= 'MyDB'

4)eliminar de msdb.dbo.log_shipping_primary_secondaries donde secondary_database= 'MyDB'

Paso 2: Servidor secundario Ejecuto las siguientes consultas.

1)eliminar de msdb.dbo.log_shipping_secondary donde primary_database='MyDB';

2)eliminar de msdb.dbo.log_shipping_monitor_secondary donde primary_database='MyDB';

3)eliminar de msdb.dbo.log_shipping_secondary_databases where secondary_database='MyDB';
*/

-- SERVER PRIMARIO
select*from msdb.dbo.log_shipping_primaries where
primary_database_name = 'SISTEMA_BANCARIO'

DELETE from msdb.dbo.log_shipping_monitor_primary WHERE
primary_database= 'SISTEMA_BANCARIO'

SELECT*FROM msdb.dbo.log_shipping_primary_databases WHERE
primary_database= 'SISTEMA_BANCARIO'

DELETE FROM msdb.dbo.log_shipping_primary_databases WHERE
primary_database= 'SISTEMA_BANCARIO'

DELETE FROM msdb.dbo.log_shipping_primary_secondaries WHERE
secondary_database= 'SISTEMA_BANCARIO'

-- SERVER SECUNDARIO

delete from msdb.dbo.log_shipping_secondary where primary_database='sistema_bancario';

delete from msdb.dbo.log_shipping_monitor_secondary where primary_database='sistema_bancario';

delete from msdb.dbo.log_shipping_secondary_databases where secondary_database='sistema_bancario';
