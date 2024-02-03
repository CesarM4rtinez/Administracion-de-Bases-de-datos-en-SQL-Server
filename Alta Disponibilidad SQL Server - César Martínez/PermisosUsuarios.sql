SELECT*FROM jubilaciones

REVOKE SELECT, INSERT, DELETE, UPDATE ON db_ISSS.dbo.jubilaciones TO dbaconsulta
REVOKE SELECT ON db_ISSS.dbo.acceso TO dbaconsulta

GRANT SELECT ON dbo.empleados TO dbaconsulta;

INSERT INTO acceso VALUES
('dbasysadmin', 'dba1'),
('dbaconsulta', 'dba2')

SELECT * FROM acceso
SELECT * FROM jubilaciones


-- COMPAÑIA TELEFONICA --
SELECT*FROM DEPARTAMENTO