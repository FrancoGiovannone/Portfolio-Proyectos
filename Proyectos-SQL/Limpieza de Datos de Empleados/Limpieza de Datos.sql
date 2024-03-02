--PROYECTO, LIMPIEZA DE DATOS

--Proyecto realizado en Microsoft SQL Server

--use portfolioproject
--Importo el archivo csv Limpieza
--select * from limpieza

--Modifico el nombre de la columna Id?empleado por Id_empleado
sp_rename 'limpieza.Id?empleado', 'Id_empleado', 'COLUMN';

--select * from limpieza

--Veo que existen 9 id_empleado duplicados 
select Id_empleado as 'Id duplicados' , count(*) as 'Cantidad de apariciones'
from limpieza
group by Id_empleado
having count(*) > 1



--Elimino los duplicados
with Duplicados_temp as 
     (select Id_empleado as 'Duplicados',row_number() over(partition by Id_empleado order by id_empleado) as 'RowNum'
      from Limpieza)
DELETE
from Duplicados_temp
where Duplicados_temp.RowNum > 1

--select * from limpieza luego de eliminar los 9 duplicados veo que pase de 22.223 registros a 22.214

--Modifico los nombres de la columna Name, Birth_date, salary, star_date, finish_date, promotion_date y type
sp_rename 'limpieza.Name', 'Nombre', 'COLUMN';
sp_rename 'limpieza.birth_date', 'Fecha_Nacimiento', 'COLUMN';
sp_rename 'limpieza.salary', 'Salario', 'COLUMN';
sp_rename 'limpieza.star_date', 'Fecha_Comienzo', 'COLUMN';
sp_rename 'limpieza.finish_date', 'Fecha_Finalizacion', 'COLUMN';
sp_rename 'limpieza.promotion_date', 'Fecha_Promocion', 'COLUMN';
sp_rename 'limpieza.type', 'Tipo', 'COLUMN';
 
--select * from limpieza

--Compruebo que no hay espacios innecesarios en las columnas Nombre y Apellido
--select Nombre
--from limpieza
--where len(nombre)>len(trim(nombre))

--select Apellido
--from limpieza
--where len(Apellido)>len(trim(Apellido))

--exec sp_help 'limpieza'  con este codigo veo los tipos de datos de todas las columnas, me realiza una descripción de la tabla


--Voy a cambiar los 0 y los 1 de la columna "Tipo", los 0 pasaran a ser "Hibrido" y los 1 "Remoto"
--Primero para poder hacer este cambio debo cambiar el tipo de dato de la columna "Tipo" de INT a VARCHAR(10)
ALTER TABLE dbo.Limpieza 
ALTER COLUMN Tipo VARCHAR(10);

--exec sp_help 'limpieza'

--Reemplazo los 0 y los 1 por "Hibrido" y "Remoto"
UPDATE Limpieza
SET Tipo = CASE 
           WHEN Tipo = 1 THEN 'Remoto'
		   WHEN Tipo = 0 THEN 'Hibrido'
		   ELSE 'Otro'
END;

--select * from limpieza

--Transformo los datos de la columna Salario para luego cambiarlos a tipo INT
UPDATE Limpieza
SET salario = CAST(replace(replace(salario, '$',''),',','') as DECIMAL(15,2))

--select * from limpieza
--exec sp_help 'limpieza'

--Vuelvo a transformar los datos de la columna Salario para luego cambiarlos a tipo INT
UPDATE Limpieza
SET salario = CAST(replace(salario,'.00','') as INT)

--Cambio el tipo de la columna salario a INT
ALTER TABLE dbo.Limpieza ALTER COLUMN Salario INT;
--select * from limpieza
--exec sp_help 'limpieza'


--Cambio las columnas de Fecha que estan en tipo nvarchar a tipo DATE

--select Id_empleado, Nombre, Apellido, area, Fecha_Nacimiento, Fecha_Comienzo, Fecha_Finalizacion,
--       CAST(Fecha_Nacimiento as DATE) as Fn, CAST(Fecha_Comienzo as DATE) as Fc, CAST(REPLACE(Fecha_Finalizacion,' UTC','') as DATE) as Ff,
--       CAST(Fecha_Promocion as DATE) as 'Fp'
--from limpieza
--where CAST(Fecha_Promocion as DATE) is not null

UPDATE Limpieza
SET Fecha_Nacimiento = CAST(Fecha_Nacimiento as DATE)

UPDATE Limpieza
SET Fecha_Comienzo = CAST(Fecha_Comienzo as DATE)

UPDATE Limpieza
SET Fecha_Finalizacion = CAST(REPLACE(Fecha_Finalizacion,' UTC','') as DATE)

UPDATE Limpieza
SET Fecha_Promocion = CAST(Fecha_Promocion as DATE)

--exec sp_help 'limpieza'
ALTER TABLE dbo.Limpieza ALTER COLUMN Fecha_Nacimiento DATE;
ALTER TABLE dbo.Limpieza ALTER COLUMN Fecha_Comienzo DATE;
ALTER TABLE dbo.Limpieza ALTER COLUMN Fecha_Finalizacion DATE;
ALTER TABLE dbo.Limpieza ALTER COLUMN Fecha_Promocion DATE;

--select * from Limpieza

--Creo una columna que almacene la edad de los empleados
ALTER TABLE Limpieza ADD Edad INT;

--1)Obtengo la diferencia en Años entre la fecha de hoy y la fecha de nacimiento
--2)Le sumo la diferencia en años que obtuve en --1 a la Fecha_Nacimiento y si la fecha que
-- obtengo es mayor a la fecha actual, GETDATE(), quiere decir que la persona no ha cumplido años
-- en este año aún entonces Resto 1, si la fecha no es mayor a GETDATE() no resto nada

--Ensayo
SELECT             --1
    DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()) - 
    CASE                   --2
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()), fecha_Nacimiento) > GETDATE() 
            THEN 1
        ELSE 0
    END AS Edad_Ensayo
FROM Limpieza

UPDATE Limpieza             --1
SET Edad =     DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()) - 
    CASE                   --2
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()), fecha_Nacimiento) > GETDATE() 
            THEN 1
        ELSE 0
    END 

--select * from limpieza

--Agrego una columna de Correo electrónico 
ALTER TABLE Limpieza ADD Email varchar(100);

--Relleno la columna Email
UPDATE Limpieza
SET Email = (concat(Nombre,'_',left(Apellido,2),'_',left(area,3),'@consulting.com'))

--Una vez realizada la limpieza de los datos selecciono los datos para exportarlos en formato csv.
select *
from Limpieza

