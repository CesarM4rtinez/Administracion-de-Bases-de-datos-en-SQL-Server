-- SCRIPT DE C�SAR OVIDIO MART�NEZ CHICAS | EJERCICCIO #2 | CLASE #3

/* Pregunta Reto: �C�mo podemos encontrar la Edad utilizando SQL?  */
SELECT 
    'C�sar Ovidio Mart�nez Chicas' AS nombre,
    DATEDIFF(YEAR, '2003-11-10', GETDATE()) - 
        IIF(MONTH('2003-11-10') > MONTH(GETDATE()) OR 
            (MONTH('2003-11-10') = MONTH(GETDATE()) AND DAY('2003-11-10') > DAY(GETDATE())), 1, 0) AS edad_exacta;

-- C�DIGO MEJORADO SIN CASE WHEN