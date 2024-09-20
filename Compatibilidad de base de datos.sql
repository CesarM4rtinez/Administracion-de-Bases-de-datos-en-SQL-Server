SELECT name,compatibility_level
, case compatibility_level
      when 80 then 'SQL Server 2000'
      when 90 then 'SQL Server 2005'
      when 100 then 'SQL Server 2008'
      when 110 then 'SQL Server 2012'
      when 120 then 'SQL Server 2014'
      when 130 then 'SQL Server 2016'
      when 140 then 'SQL Server 2017'
      when 150 then 'SQL Server 2019'
      when 160 then 'SQL Server 2022'
      else 'Inferior o desconocido'
      end 'Nivel de Compatibilidad'
from sys.databases