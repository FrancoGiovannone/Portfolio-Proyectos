-- Analisis exploratorio de los Datos

-- use world_layoffs;

select *
from layoffs_pruebas2;

select *
from layoffs_pruebas2
where percentage_laid_off = 1;

select *
from layoffs_pruebas2
where percentage_laid_off = 1
order by funds_raised_millions desc;

--  Total de despidos por company
select company, sum(total_laid_off) as 'Total de Despidos'
from layoffs_pruebas2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_pruebas2;


--  Total despidos por industria
select industry, sum(total_laid_off) as 'Total despidos por industria'
from layoffs_pruebas2
group by industry
order by 2 desc;

--  Total de despidos por país
select country, sum(total_laid_off) as 'Total despidos por país'
from layoffs_pruebas2
group by country
order by 2 desc;

--  Total de despidos por año
select year(`date`) as 'Año', sum(total_laid_off) as 'Despidos por año'
from layoffs_pruebas2
group by 1
order by 2 desc;

--  Total despidos por mes
select substring(`date`,1,7) as 'Mes', sum(total_laid_off) as 'Despidos'
from layoffs_pruebas2
group by 1
order by 1;

--  Total de despidos por mes y total acumulado
select substring(`date`,1,7) as 'Fecha', sum(total_laid_off) as 'Despidos', 
       sum(sum(total_laid_off)) over(order by substring(`date`,1,7)) as 'Total acumulado de Despidos'
from layoffs_pruebas2
where substring(`date`,1,7) is not null
group by 1
order by 1;

--  Otra forma de hacer el total de despidos por mes y total acumulado
with rolling_total_mes as (select substring(`date`,1,7) as 'Fecha', sum(total_laid_off) as 'Despidos'
						from layoffs_pruebas2
                        where substring(`date`,1,7) is not null
						group by 1
						order by 1)
select *, sum(Despidos) over(order by Fecha) as 'Total Despidos'
from rolling_total_mes;

select company, year(`date`) as 'Año', sum(total_laid_off) as 'Despidos'
from layoffs_pruebas2
group by 1,2
order by 3 desc;

--  Top 5 de companias que más despidos hicieron por año
with company_year as (select company, year(`date`) as 'Año', sum(total_laid_off) as 'Despidos'
					  from layoffs_pruebas2
					  group by 1,2
					  order by 3 desc),
	company_Rank  as (select *, dense_rank() over(partition by Año order by Despidos desc) as Ranking
					 from company_year
					 where Año is not null)
select *
from company_rank
where Ranking <= 5;




