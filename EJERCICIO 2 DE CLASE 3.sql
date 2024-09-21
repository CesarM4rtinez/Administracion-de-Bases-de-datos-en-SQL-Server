-- SCRIPT DE CÉSAR OVIDIO MARTÍNEZ CHICAS | EJERCICCIO #2 | CLASE #3

/* Pregunta Reto: ¿Cómo podemos encontrar la Edad utilizando SQL?  */
SELECT 
    'César Ovidio Martínez Chicas' AS nombre,
    DATEDIFF(YEAR, '2003-11-10', GETDATE()) - 
        IIF(MONTH('2003-11-10') > MONTH(GETDATE()) OR 
            (MONTH('2003-11-10') = MONTH(GETDATE()) AND DAY('2003-11-10') > DAY(GETDATE())), 1, 0) AS edad_exacta;

-- CÓDIGO MEJORADO SIN CASE WHEN