--------------------------------
--JOINS
--------------------------------
--Une la informaci�n de las tabla accounts y orders
select a.*, o.*
from accounts a
join orders o on o.account_id = a.id

--Muestra standard_qty, gloss_qty y poster_qty de la tabla orders y el website, primary_poc de la tabla accounts
select o.standard_qty, o.gloss_qty, o.poster_qty, a.website, a.primary_poc
from orders o
join accounts a on a.id = o.account_id

--Proporcionar una tabla para todos los web_events asociados con el nombre de cuenta de Walmart. Debe haber tres columnas. 
--Aseg�rese de incluir el primary_poc, la hora del evento y el canal para cada evento. 
--Adem�s, podr�a a�adir una cuarta columna para asegurarse de que s�lo se han elegido eventos de Walmart.

select a.primary_poc, w.occurred_at, w.channel, a.name
from web_events w
join accounts a on a.id = w.account_id
where a.name like '%walmart%'

--Proporcione una tabla que proporcione la regi�n para cada sales_rep junto con sus cuentas asociadas. 
--La tabla final debe incluir tres columnas: el nombre de la regi�n, el nombre del representante de ventas y el nombre de la cuenta.
--Ordene las cuentas alfab�ticamente (A-Z) seg�n el nombre de la cuenta.

select r.name as 'Regi�n', sr.name as 'Representante de la regi�n', a.name as 'Empresa'
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on a.sales_rep_id = sr.id
order by a.name asc

--Proporcione el nombre de cada regi�n para cada pedido, as� como el nombre de la cuenta y el precio unitario que pagaron 
--(total_amt_usd/total) por el pedido. La tabla final debe tener 3 columnas: nombre de la regi�n, nombre de la cuenta y precio unitario.
--Algunas cuentas tienen 0 para el total, as� que divid� por (total + 0.01) para asegurarme de no dividir por cero.

select r.name as 'Regi�n', a.name as 'Empresa', (o.total_amt_usd/o.total + 0.01) as 'Precio unitario'
from orders o
join accounts a on a.id = o.account_id
join sales_reps sr on sr.id = a.sales_rep_id
join region r on r.id = sr.region_id

--Proporcionar una tabla que proporcione la regi�n para cada sales_rep junto con sus cuentas asociadas. 
--Esta vez s�lo para la regi�n del Medio Oeste. La tabla final debe incluir tres columnas: 
--el nombre de la regi�n, el nombre del representante de ventas y el nombre de la cuenta. 
--Ordene las cuentas alfab�ticamente (A-Z) seg�n el nombre de la cuenta.

select r.name as 'Regi�n', sr.name as 'Representante de la regi�n', a.name as 'Empresa'
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on a.sales_rep_id = sr.id
where r.name = 'Midwest'
order by a.name asc

--Proporcionar una tabla que proporcione la regi�n para cada sales_rep junto con sus cuentas asociadas.
--Esta vez s�lo para las cuentas en las que el nombre del representante de ventas empiece por S y se encuentren en la regi�n del Medio Oeste.
--La tabla final debe incluir tres columnas: el nombre de la regi�n, el nombre del representante de ventas y el nombre de la cuenta. 
--Ordene las cuentas alfab�ticamente (A-Z) seg�n el nombre de la cuenta.

select r.name as 'Regi�n', sr.name as 'Representante de la regi�n', a.name as 'Empresa'
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on a.sales_rep_id = sr.id
where r.name = 'Midwest' and sr.name like 'S%'
order by a.name asc

--Proporcionar una tabla que proporcione la regi�n para cada sales_rep junto con sus cuentas asociadas. 
--Esta vez s�lo para las cuentas en las que el representante de ventas tenga un apellido que empiece por K y en la regi�n del Medio Oeste. 
--La tabla final debe incluir tres columnas: el nombre de la regi�n, el nombre del representante de ventas y el nombre de la cuenta. 
--Ordene las cuentas alfab�ticamente (A-Z) seg�n el nombre de la cuenta.

select r.name as 'Regi�n', sr.name as 'Representante de la regi�n', a.name as 'Empresa'
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on a.sales_rep_id = sr.id
where r.name = 'Midwest' and sr.name like '% k%'
order by a.name asc

--Proporcione el nombre de cada regi�n para cada pedido, as� como el nombre de la cuenta y el precio unitario que pagaron (total_amt_usd/total) por el pedido. 
--Sin embargo, s�lo debe proporcionar los resultados si la cantidad est�ndar del pedido es superior a 100. 
--La tabla final debe tener 3 columnas: nombre de la regi�n, nombre de la cuenta y precio unitario. 
--Para evitar un error de divisi�n por cero, a�adir .01 al denominador aqu� es �til total_amt_usd/(total+0.01).

select r.name as 'Region', a.name as 'Empresa', round((o.total_amt_usd/o.total + 0.01),2) as 'Precio Unitario'
from orders o
join accounts a on a.id = o.account_id
join sales_reps sr on sr.id = a.sales_rep_id
join region r on r.id = sr.region_id
where o.standard_qty > 100

--Proporcione el nombre de cada regi�n para cada pedido, as� como el nombre de la cuenta y el precio unitario que pagaron (total_amt_usd/total) por el pedido.
--Sin embargo, s�lo debe proporcionar los resultados si la cantidad del pedido est�ndar es superior a 100 
--y la cantidad de poster es superior a 50. 
--La tabla final debe tener 3 columnas: nombre de la regi�n, nombre de la cuenta y precio unitario. 
--Ordene primero por el precio unitario m�s bajo. 
--Para evitar un error de divisi�n por cero, es �til a�adir 0,01 al denominador (total_amt_usd/(total+0,01).

select r.name as 'Region', a.name as 'Empresa', round((o.total_amt_usd/o.total + 0.01),2) as 'Precio Unitario'
from orders o
join accounts a on a.id = o.account_id
join sales_reps sr on sr.id = a.sales_rep_id
join region r on r.id = sr.region_id
where o.standard_qty > 100 and o.poster_qty > 50
order by 3 asc

--�Cu�les son los diferentes channels utilizados por el account_id 1001? 
--La tabla final deber�a tener s�lo 2 columnas: el nombre de la cuenta y los diferentes canales.

select distinct a.name as 'Empresa', w.channel as 'Canales'
from web_events w
join accounts a on a.id = w.account_id
where a.id = 1001

--Busque todos los pedidos que se produjeron en 2015. 
--La tabla final debe tener 4 columnas: occurred_at, account name, order total y order total_amt_usd.

select o.occurred_at, a.name as 'Empresa', o.total as 'Total ordenado', o.total_amt_usd
from orders o
join accounts a on a.id = o.account_id
where o.occurred_at between '2015-01-01' and '2016-01-01'
order by 1 asc








