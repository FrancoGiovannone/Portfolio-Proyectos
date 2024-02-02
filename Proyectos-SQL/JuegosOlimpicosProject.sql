--use PortfolioProject;

--Cargar los datos del archivo csv "athlete_events"
-- pueden descargar el archivo del siguiente link:
--https://drive.google.com/file/d/1hiU5w_-EnXuk8Wlg51xMtffqsL9KdSXv/view?usp=sharing


--ACLARACI�N: LOS DATOS LLEGAN HASTA LOS JUEGOS DE R�O DE JANEIRO 2016
select * from athlete_events

--1)Cu�ntos juegos Ol�mpicos se han celebrado?(La informaci�n llega hasta R�o de Janeiro 2016)

select count(distinct Games) as 'Cantidad de Juegos celebrados'
from athlete_events

--2)Enumera todos los juegos ol�mpicos celebrados hasta ahora. (Los datos llegan hasta Rio 2016)
select distinct Games, Year
from athlete_events
order by year asc

--3)Menciona el n�mero total de naciones que participaron en cada juego ol�mpico.
select Games, count(distinct NOC) as 'Cantidad de paises participantes'
from athlete_events
group by Games
order by 2 asc

--4)En qu� a�o se vio el mayor n�mero de pa�ses participantes? y el menor?
--Juegos Ol�mpicos con mayor n�mero de pa�ses participantes.
select top 1 Games, count(distinct NOC) as 'Cantidad de paises participantes'
from athlete_events
group by Games
order by 2 desc

--Con menor n�mero de pa�ses participantes
select top 1 Games, count(distinct NOC) as 'Cantidad de paises participantes'
from athlete_events
group by Games
order by 2 asc

--5)Qu� pa�s participo en todos los juegos ol�mpicos?
with t1 as (select NOC, count(distinct Games) as 'Cantidad de Juegos en los que participo el Pa�s'
			from athlete_events
			group by NOC 
			)
select t1.NOC as 'Pa�ses que han participado en todos los juegos'
from t1
where t1.[Cantidad de Juegos en los que participo el Pa�s] = (select count(distinct Games) as 'Cantidad de Juegos celebrados'
                               from athlete_events)

--Otra forma de hacerlo
select NOC, count(distinct Games) as 'Cantidad de Juegos en los que participo el Pa�s'
from athlete_events
group by NOC 
having count(distinct Games) = (select count(distinct Games) as 'Cantidad de Juegos celebrados'
                               from athlete_events)



--select * from athlete_events order by year asc


--6)Deportes que han estado en todos los juegos de Verano.
select Sport, count(distinct Games) as "Cantidad de juegos en los que estuvo el deporte"
from athlete_events
where Season = 'Summer'
group by Sport
having count(distinct Games) = (select count(distinct Games) as 'Cantidad de juegos de verano'
                                from athlete_events
								where Season = 'Summer')

--7)N�mero de deportes que hubo en cada juego
select Games, count(distinct Sport) 'Deportes'
from athlete_events
group by Games
order by 2 asc

--select distinct Sport
--from athlete_events
--where Games = '2016 Summer'


--8)Proporci�n de atletas masculinos y femeninos del total de juegos.

select round(Total_Masculinos/Total_Atletas , 2)*100 as 'Porcentaje de Hombres', round(Total_Femeninos/Total_Atletas,2)*100 as 'Porcentaje de Mujeres'
from      (select CAST(count(*) as DECIMAL(10,2)) as 'Total_Atletas', 
		  sum(case when sex = 'M' then 1 else 0 end) as Total_Masculinos,
		  sum(case when sex = 'F' then 1 else 0 end) as Total_Femeninos
		  from athlete_events) as t1


select Games ,count(*) as Total_Atletas, 
       sum(case when sex = 'M' then 1 else 0 end) as Total_Masculinos,
	   sum(case when sex = 'F' then 1 else 0 end) as Total_Femeninos
from athlete_events
group by Games
order by 4 asc

--Porcentaje de hombres y mujeres en cada juego
select *, round(Total_Masculinos/Total_Atletas , 3)*100 as 'Porcentaje de Hombres',
          round(Total_Femeninos/Total_Atletas,3 )*100 as 'Porcentaje de Mujeres'
from (select Games ,round(CAST(count(*) as DECIMAL(10,2)),2) as Total_Atletas,
      sum(case when sex = 'M' then 1 else 0 end) as Total_Masculinos,
	  sum(case when sex = 'F' then 1 else 0 end) as Total_Femeninos
	  from athlete_events
	  group by Games
	  ) t
order by Games

--select distinct Games from athlete_events
--9) Top 5 atletas que ganaron m�s medallas de ORO, sin contar los juegos ol�mpicos intercalados de Atenas 1906

--El m�s ganador es Phelps con 23 pero luego los dem�s puestos tienen m�s de un atleta porque poseen 
--la misma cantidad de medallas doradas, el top 5 esta compuesto por los de ranking 1 y 2
select Name, Team, count(Medal) as 'Cantidad de doradas', DENSE_RANK() over(order by Count(Medal) desc) as Ranking
from athlete_events
where Medal = 'Gold' and Year != 1906
group by Name, Team
order by 3 desc

