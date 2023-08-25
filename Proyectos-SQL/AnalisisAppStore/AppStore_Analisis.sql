--Combino las cuatro tablas appleStore_description en una sola tabla

CREATE TABLE appleStore_description_combined AS
SELECT * From appleStore_description1
union ALL
SELECT * FROM appleStore_description2
union ALL
SELECT * from appleStore_description3
union ALL
SELECT * from appleStore_description4

**EXPLORATORY DATA ANALYSIS**

-- Veo el número de apps distintas que hay en ambas tablas
SELECT count(DISTINCT(id)) as UniqueAppsID
FROM AppleStore

SELECT count(DISTINCT(id)) as UniqueAppsID
FROM appleStore_description_combined

-- Chequeo si falta algún valor en los campos clave
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null or user_rating is null or prime_genre is NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null

--Número de Apps por genero
SELECT prime_genre, count(prime_genre) AS NumApps
FROm AppleStore
group by prime_genre
Order by NumApps DESC

-- Viendo el rating de las Apps
SELECT min(user_rating) AS Min, max(user_rating) as Max, round(avg(user_rating),3) as Promedio
FRom AppleStore

**DATA ANALYSIS**

-- determinar si las aplicaciones de pago tienen mejores valoraciones que las gratuitas
SELECT CASE
           WHEN price > 0 then 'Paga'
           Else 'Gratis'
           end as AppType,
           round(avg(user_rating),3) AS RatingPromedio
From AppleStore
group by AppType
ORDER BY RatingPromedio desc

-- Ver si las Apps con más lenguajes de soporte tiene mejor rating
SELECT case 
          when lang_num < 10 then '<10 lenguajes'
          when lang_num BETWEEN 10 and 30 then  'entre 10 y 30 lenguajes'
          else '>30 lenguajes'
          end as CantidadLenguajes,
          round(avg(user_rating),3) as RatingPromedio
from AppleStore
group by CantidadLenguajes
order by RatingPromedio desc

-- ver que generos tienen menos rating
select prime_genre as genero, round(avg(user_rating),3) as RatingPromedio
from AppleStore
group by prime_genre
order by RatingPromedio asc
LIMIT 10

-- Ver si existe correlación entre la longitud de la descripción y el rating de la App
select case 
           when LENGTH(b.app_desc) < 500 then 'Corta'
           when LENGTH(b.app_desc) BETWEEN 500 and 1000 then 'Mediana'
           else 'Larga'
           end as Longitud_de_Descripcion,
           round(avg(a.user_rating),3) as RatingPromedio
from AppleStore a 
join appleStore_description_combined b on a.id = b.id
group by Longitud_de_Descripcion
Order by RatingPromedio desc

-- Apps con mejor rating por genero
SElect prime_genre, track_name, user_rating
FROM 
(select prime_genre, track_name, user_rating,
 RANK() OVER(PARTITION by prime_genre order by user_rating desc, rating_count_tot desc) 
 as Ranking
 FROM AppleStore) as a 
 where a.Ranking = 1
 

  







           

