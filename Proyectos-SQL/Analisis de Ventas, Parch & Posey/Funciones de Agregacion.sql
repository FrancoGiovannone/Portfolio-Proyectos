--------------------------
--FUNCIONES DE AGREGACI�N
--------------------------

--Encuentre la cantidad total de papel poster pedido en la tabla orders
select sum(poster_qty) as 'Cantidad total ordenada'
from orders 

--Encuentre la cantidad total de papel standar pedido en la tabla orders
select sum(standard_qty) as 'Cantidad total ordenada'
from orders

--Encuentre la suma total de total_amt_usd
select sum(total_amt_usd) as 'Total en dolares'
from orders

--Encuentre el monto total gastado en papel standard_amt_usd y gloss_amt_usd para cada pedido en la tabla de pedidos.
select *,(standard_amt_usd + gloss_amt_usd) as 'Total gastado en Standard + Gloss'
from orders

--Encuentra el precio unitario del papel de tipo standard.
select sum(standard_amt_usd)/sum(standard_qty) as 'Precio unitario del papel standard'
from orders

--Encuentre la cantidad media (PROMEDIO) gastada por pedido en cada tipo de papel, as� como
--la cantidad media de cada tipo de papel comprado por pedido.
select avg(standard_amt_usd) as 'Promedio Gastado en Standard', avg(poster_amt_usd) as 'Promedio Gastado en Poster', avg(gloss_amt_usd)as 'Promedio Gastado en Gloss', 
       avg(standard_qty) as 'Cantidad comprada promedio de standard', avg(poster_qty) as 'Cantidad comprada promedio de Poster',
	   avg(gloss_qty) as 'Cantidad comprada promedio de Gloss'
from orders

--�Qu� empresa realiz� la primera orden? la soluci�n debe tener el nombre de la cuenta y la fecha del pedido.
select top 1 a.name as 'Empresa', o.occurred_at as 'Fecha'
from orders o
join accounts a on a.id = o.account_id
order by 2 asc

--Encuentre las ventas totales en d�lares para cada cuenta. 
--Debe incluir dos columnas: las ventas totales de los pedidos de cada empresa en d�lares y el nombre de la empresa
select a.name as 'Empresa', sum(o.total_amt_usd) as 'Total en d�lares'
from orders o
join accounts a on a.id = o.account_id
group by a.name

--�A trav�s de qu� canal ocurri� el evento web m�s reciente (�ltimo), qu� cuenta estaba asociada con este evento web?
--Su consulta debe devolver solo tres valores: la fecha, el canal y el nombre de la cuenta.
select top 1 w.occurred_at as 'Fecha', w.channel as 'Canal', a.name as 'Empresa'
from web_events w
join accounts a on a.id = w.account_id
order by w.occurred_at desc

--Encuentre el n�mero total de veces que se utiliz� cada tipo de canal de web_events.
select channel as 'Canal', count(*) as 'Cantidad de veces que se utilizo el canal'
from web_events
group by channel
order by 2 desc

--Qui�n fue el sales rep asociado al primer evento web?
select top 1 w.occurred_at as 'Fecha', sr.name as 'Representante'
from web_events w
join accounts a on a.id = w.account_id
join sales_reps sr on sr.id = a.sales_rep_id
order by w.occurred_at asc

--Qui�n fue el primary_poc asociado al primer evento web?
select top 1 w.occurred_at as 'Fecha', a.primary_poc
from web_events w
join accounts a on a.id = w.account_id
order by w.occurred_at asc

--�Cu�l fue el pedido m�s peque�o realizado por cada cuenta en t�rminos de d�lares totales?
--Proporcione s�lo dos columnas: el nombre de la cuenta y el total en d�lares.
--Ordene desde la cantidad en d�lares m�s peque�a hasta la m�s grande.

select a.name as 'Empresa', min(o.total_amt_usd) as 'Cantidad gastada m�s peque�a'
from orders o
join accounts a on a.id = o.account_id
group by a.name
order by 2 asc

--NOTAR que la consulta anterior me devuelve 350 filas, osea que 350 empresas distintas han hecho al menos una orden
--pero en la tabla accounts tenemos 351 empresas distintas, quiere decir que hay una empresa en la tabla accounts que
--no ha realizado ninguna orden

select count(distinct name) as 'Cantidad de empresas'
from accounts

--La empresa que no ha realizado ninguna orden es 'Goldman Sachs Group'
select id, name
from accounts
where id not in (select distinct a.id
                 from accounts a 
                 join orders o on a.id = o.account_id)

--Comprobamos que esta consulta no devuelve ningun registro:
select *
from orders
where account_id = 1731

--Encuentre la cantidad de representantes de ventas en cada regi�n.
select r.name as 'Regi�n', count(*) as 'Cantidad de representantes por regi�n'
from sales_reps sr
join region r on r.id = sr.region_id
group by r.name
order by 2 desc

--Para cada cuenta, determine la cantidad promedio de cada tipo de papel que compraron en todos sus pedidos.
select a.name as 'Empresa', avg(o.standard_qty) as 'Promedio de Standard', avg(o.gloss_qty) as 'Promedio de Gloss',
       avg(o.Poster_qty) as 'Promedio de Poster'
from orders o 
join accounts a on a.id = o.account_id
group by a.name

--Para cada cuenta, determine la cantidad promedio gastada en cada tipo de papel
select a.name as 'Empresa', avg(o.standard_amt_usd) as 'Promedio de Standard', avg(o.gloss_amt_usd) as 'Promedio de Gloss',
       avg(o.poster_amt_usd) as 'Promedio de Poster'
from orders o 
join accounts a on a.id = o.account_id
group by a.name

--Determine la cantidad de veces que cada representante de ventas utiliz� cada canal.
select sr.name as 'Representante de ventas', w.channel as 'Canal', count(*) as 'Cantidad de veces que utilizo el canal'
from web_events w
join accounts a on a.id = w.account_id
join sales_reps sr on sr.id = a.sales_rep_id
group by sr.name, w.channel
order by sr.name, count(*) desc

--Determine la cantidad de veces que se us� un canal en particular en la tabla web_events para cada regi�n.
--Su tabla final debe tener tres columnas: el nombre de la regi�n, el canal y el n�mero de apariciones.
--Ordene primero su tabla con el mayor n�mero de apariciones
select r.name as 'Regi�n', w.channel as 'Canal', count(*) as 'Cantidad de apariciones'
from web_events w
join accounts a on a.id = w.account_id
join sales_reps sr on sr.id = a.sales_rep_id
join region r on r.id = sr.region_id
group by r.name, w.channel
order by r.name, count(*) desc

--Hay alg�n representante de ventas que trabaje para m�s de una empresa?
select sr.id as 'id', sr.name as 'Nombre' , count(*) as 'Cantidad de empresas'
from sales_reps sr
join accounts a on a.sales_rep_id = sr.id
group by sr.id, sr.name

--�Cu�ntos de los representantes de ventas administran m�s de 5 cuentas? rta = 34
select sr.id as 'id', sr.name as 'Nombre' , count(*) as 'Cantidad de empresas'
from sales_reps sr
join accounts a on a.sales_rep_id = sr.id
group by sr.id, sr.name
having count(*) > 5

select count(*) as 'Cantidad de representantes que administran m�s de 5 cuentas'
from (select sr.id as 'id', sr.name as 'Nombre' , count(*) as 'Cantidad de empresas'
from sales_reps sr
join accounts a on a.sales_rep_id = sr.id
group by sr.id, sr.name
having count(*) > 5) as t1

--Cu�ntas cuentas tienen m�s de 20 ordenes? rta = 120 empresas tienen m�s de 20 ordenes cada una
select a.name as 'Empresa', count(*) as 'Cantidad de ordenes'
from orders o
join accounts a on a.id = o.account_id
group by a.name
having count(*) > 20
order by count(*) desc

--Qu� empresa tiene la mayor cantidad de ordenes?
select top 1 a.name as 'Empresa', count(*) as 'Cantidad de ordenes'
from orders o
join accounts a on a.id = o.account_id
group by a.name
having count(*) > 20
order by count(*) desc

--Qu� empresas han gastado m�s de 30000 dolares teniendo en cuenta todas sus ordenes?
select a.name as 'Empresa', sum(o.total_amt_usd) as 'Total Gastado'
from orders o
join accounts a on a.id = o.account_id
group by a.name
having sum(o.total_amt_usd) > 30000
order by 'Total Gastado' desc

--Qu� empresas se han utilizado facebook como canal de contacto m�s de 6 veces?
select a.name as 'Empresa' , w.channel as 'Canal' , count(*) as 'Cantidad'
from web_events w
join accounts a on a.id = w.account_id
where w.channel = 'Facebook'
group by a.name, w.channel
having count(*) > 6
order by 'Cantidad' desc

--Cu�l es el canal m�s utilizado?
select top 1 channel as 'Canal', count(*) 'Cantidad de veces que se utilizo'
from web_events
group by channel
order by count(*) desc

--Muestra las ventas por a�o
SELECT DATEPART(YY,occurred_at) AS 'A�o' , SUM(total_amt_usd) AS 'Total vendido en dolares por a�o'
FROM orders
GROUP BY DATEPART(YY,occurred_at)
ORDER BY 2 DESC;


--Monto total vendido agrupado por mes, entre 2014 y 2016-12-31
SELECT DATEPART(MM,occurred_at) AS 'Meses' , SUM(total_amt_usd) AS 'Total vendido mes'
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATEPART(MM,occurred_at)
ORDER BY 2 DESC

--Escriba una consulta para mostrar la cantidad de pedidos en cada una de las tres categor�as, 
--seg�n la cantidad total de art�culos en cada pedido.
--Las tres categor�as son: 'Al menos 2000', 'Entre 1000 y 2000' y 'Menos de 1000'.
select Categoria , count(*) as 'Cantidad de pedidos'
from   (select case
		when total >= 2000 then 'Al menos 2000'
		when total >= 1000 and total < 2000 then 'Entre 1000 y 2000'
		else 'Menos de 1000'
		end as Categoria 
		from orders) as t
group by Categoria 


---Clasifica a los clientes seg�n el total que han gastado en todas sus ordenes.
SELECT accounts.name,SUM(total_amt_usd) AS 'Total Gastado',
	CASE
		WHEN SUM(total_amt_usd) > 20000000 THEN 'Top'
		WHEN SUM(total_amt_usd) >= 1000000 and SUM(total_amt_usd) <= 20000000 THEN 'Middle'
		ELSE 'Low'
	END AS Nivel_del_Cliente
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY 2 DESC


--Clasificando a los representantes de ventas seg�n su cantidad de ordenes efectuadas o su cantidad de dinero ganado
SELECT sales_reps.name as 'Representante', COUNT(*) as 'Cantidad de ordenes', SUM(total_amt_usd) as 'Total Generado en dolares', 
     CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 75000000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 50000000 THEN 'middle'
     ELSE 'low' END AS 'Nivel del representante'
FROM orders
JOIN accounts ON accounts.id = orders.account_id 
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY sales_reps.name
ORDER BY 3 DESC;
