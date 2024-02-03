exec sp_configure 'show advanced options',1;
sp_configure 'max server memory', 8192;
Reconfigure

select [name],[value],[value_in_use]
from sys.configurations
where [name] = 'max serer memory (mb)' or [name] = 'min server memory (mb)'