--------------------
--CONSULTAS BÁSICAS
--------------------
--Selecciona el id, account_id y occurred_at de la tabla orders.
select id, account_id, occurred_at from orders

--Muestra las primeras 15 filas de la tabla web_events
select top 15 * 
from web_events

--Muestra las primeras 10 ordenes registradas en la tabla orders
select top 10  * 
from orders 
order by occurred_at asc

--Muestra todos los eventos que se contactaron via 'organic' o 'adwords', usa la tabla web_events
select * 
from web_events
where channel in ('organic','adwords')

--Muestra el top 5 de ordenes en terminos de mayor cantidad de dinero gastado. Incluye el id, account_id y el total_amt_usd
select top 5 id, account_id, total_amt_usd
from orders 
order by 3 desc

--Muestra las 20 ordenes que menos dinero gastaron 
select top 20 id, account_id, total_amt_usd
from orders
order by 3 asc

--Muestra el id, account_id y el total_amt_usd para todas las ordenes. 
--Ordena por account_id (en orden ascendente) y luego por total_amt_usd (en orden descendente)
select id, account_id, total_amt_usd
from orders
order by account_id asc, total_amt_usd desc

--Muestra las primeras 5 filas de la tabla orders que tengan un gloss_amt_usd mayor o igual a 1000 
select top 5  * 
from orders 
where gloss_amt_usd >= 1000

--Muestra las primeras 10 filas de la tabla orders que tengan un total_amt_usd menor a 500
select top 10 *
from orders 
where total_amt_usd < 500

--Muestra la información de la tabla account perteneciente a la empresa 'Exxon Mobil'
select *
from accounts 
where name = 'Exxon Mobil'

--Crea una columna que divida el standard_amt_usd por standard_qty para averiguar el precio unitario de cada orden.
--Incluye el id y el account_id
select id, account_id, (standard_amt_usd/standard_qty) as 'Precio unitario'
from orders

--Muestra el porcentaje de ganancia de cada orden que proviene de la venta de poster paper
select id, account_id, round((poster_amt_usd/ total_amt_usd)* 100, 2) as '% de Ganancia por Vender Poster'
from orders 
where total_amt_usd <> 0

--Muestra todas las empresas que su nombre empiece con C
select *
from accounts
where name like 'C%'

--Muestra todas las empresas que contengan en su nombre el string 'one'
select *
from accounts 
where name like '%one%'

--Muestra todas las empresas que su nombre termina con s 
select * from accounts where name like '%s'

--Muestra name, primary_poc y sales_rep_id para Walmart, Target y Nordstrom
select name, primary_poc, sales_rep_id
from accounts 
where name in ('Walmart','Target','Nordstrom')

--Usa la tabla web_events para mostrar la información de los individuos contactados por channel 'organic' o 'adwords'
select *
from web_events
where channel in ('organic','adwords')

--Usa la tabla accounts para mostrar name, primary_poc, sales_rep_id de todas las empresas menos de Walmart, Target y Nordstrom 
select name, primary_poc, sales_rep_id
from accounts
where name NOT IN ('Walmart','Target', 'Nordstrom')

--Muestra todas las ordenes en las que standar_qty es mayor a 1000, poster_qty es 0 y gloss_qty es 0
select *
from orders
where standard_qty > 1000 and poster_qty = 0 and gloss_qty = 0

--Muestra todas las empresas que su nombre no empieza con C y termina con s
select name
from accounts
where name NOT LIKE 'C%' AND name LIKE '%s';

--Muestra todas las ordenes en las que gloss_qty esta entre 24 y 29
select *
from orders 
where gloss_qty between 24 and 29

--Muestra todos los web_events que se dieron en el año 2016 y que el canal fue 'organic' o 'adwords'. Ordenar por fecha, desde el más reciente al más antiguo
select *
from web_events
where channel in ('organic','adwords') and occurred_at between '2016-01-01' and '2016-12-31'
order by occurred_at desc

-- Muestra las ordenes donde se da que el standard_qty es cero y el gloss_qty es mayor a 1000 o el poster_qty es mayor a 1000
select *
from orders 
where standard_qty = 0 and (gloss_qty > 1000 or poster_qty > 1000)
	
--Muestra todas las empresas que comienzan con C o W, que su primary_poc contiene 'ana' o 'Ana' pero que no contiene 'eana'
select *
from accounts 
where (name like 'C%' or name like 'W%') and (primary_poc like '%ana%' or primary_poc like '%Ana%') and (primary_poc not like '%eana%')

















SELECT name FROM accounts
WHERE (name lIKE 'C%' OR name LIKE 'W%')
	AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
		AND primary_poc NOT LIKE '%eana%');