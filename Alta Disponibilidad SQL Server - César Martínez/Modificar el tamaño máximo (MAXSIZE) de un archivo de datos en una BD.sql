CREATE DATABASE Ventas
ON PRIMARY 
(NAME = 'Ventas', 
FILENAME = 'C:\VentasData.mdf', 
SIZE = 10, 
MAXSIZE = 50, 
FILEGROWTH = 5) 

LOG ON 
(NAME = 'VentasLog', 
FILENAME = 'C:\VentasLog.ldf', 
SIZE = 5, 
MAXSIZE = 25, 
FILEGROWTH = 5);

