-- Limpieza de Datos utilizando MySQL
-- use world_layoffs

--  Importo el archivo csv "layoffs" sin aplicarles ningún cambio de tipo de dato

-- 1 Remover duplicados
-- 2 Estandarizar los datos
-- 3 Tratar los valores nulos o blancos
-- 4 Eliminar filas o columnas sin valor

select * 
from layoffs;

-- Creo una tabla igual a la original "layoffs" pero esta nueva tabla será de pruebas.
CREATE TABLE layoffs_pruebas
like layoffs;

select *
from layoffs_pruebas;

-- Relleno la tabla layoffs_pruebas con los datos de la tabla layoffs

INSERT INTO layoffs_pruebas
SELECT *
FROM layoffs;

select *
from layoffs_pruebas;

-- Reviso si hay datos duplicadas

select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, 
                  stage, country, funds_raised_millions order by company) as 'row_num'
from layoffs_pruebas;

WITH duplicados_CTE as 
(select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, 
                  stage, country, funds_raised_millions order by company) as 'row_num'
from layoffs_pruebas)
select *
from duplicados_CTE
where row_num > 1;

-- Observo que hay 5 filas duplicadas 

select *
from layoffs_pruebas
where company = 'Wildlife Studios';

-- Creo una tabla igual a la tabla layoffs_pruebas pero le agrego la columna 'row_num'. Uso el copy to clipboard --> create statement -->pego el código
CREATE TABLE `layoffs_pruebas2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_pruebas2;

INSERT INTO layoffs_pruebas2
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, 
                  stage, country, funds_raised_millions order by company) as 'row_num'
from layoffs_pruebas;

select *
from layoffs_pruebas2
where row_num > 1;

-- Elimino los datos duplicados de layoffs_pruebas2
DELETE
FROM layoffs_pruebas2
WHERE row_num > 1;

select *
from layoffs_pruebas2
where row_num > 1;

--  Estandarizo los datos

--  Elimino los espacios innecesarios
select company, trim(company)
from layoffs_pruebas2;

UPDATE layoffs_pruebas2
SET company = trim(company);

select company
from layoffs_pruebas2;

--  Veo si hay nombres distintos pero que se refieren a la misma industria
select distinct industry
from layoffs_pruebas2
order by 1 desc;

--  Encuentro que "Crypto", "CryptoCurrency" y "Crypto Currency" se refieren a la misma industria que seria "Crypto"
select distinct industry 
from layoffs_pruebas2
where industry LIKE "%Crypto%";

--  Actualizo la columna industry para que todos los valores que contengan la palabra Crypto sean igual "Crypto"
UPDATE layoffs_pruebas2
SET industry = "Crypto"
WHERE industry LIKE "%Crypto%";

select distinct industry
from layoffs_pruebas2;

--  Veo si hay nombres distintos pero que se refieren al mismo país
select distinct country
from layoffs_pruebas2
order by 1;
--  Encuentro que hay valores como "United States" y "United States.", actalizo para que queden los valores sin punto
UPDATE layoffs_pruebas2
SET country = "United States"
WHERE country LIKE "%United States%";

--  Transformo la columna date que esta en tipo texto para luego poder hacer el cambio a tipo Date
select `date`, STR_TO_DATE(`date` , "%m/%d/%Y")
from layoffs_pruebas2;

UPDATE layoffs_pruebas2
SET `date` = STR_TO_DATE(`date` , "%m/%d/%Y");

select `date`
from layoffs_pruebas2;

--  Cambio el tipo de dato de la columna date, de text a date
ALTER TABLE layoffs_pruebas2
MODIFY COLUMN `date` DATE;

--  Reemplazo los valores '' por NULL
UPDATE layoffs_pruebas2
set industry = null
where industry = '';

--  Veo como puedo rellenar los valores null en la columna industry
select t1.*, t2.industry
from layoffs_pruebas2 t1
join layoffs_pruebas2 t2 on t1.company = t2.company
where (t1.industry is null) and (t2.industry is not null);

--  Relleno los datos null de la columna industry
UPDATE layoffs_pruebas2 t1
join layoffs_pruebas2 t2 on t1.company = t2.company
SET t1.industry = t2.industry
where (t1.industry is null) and (t2.industry is not null);

--  Solo queda un dato null en la columna industry que hace referencia a la compania Bally's Interactive
select *
from layoffs_pruebas2
where industry is null;


select *
from layoffs_pruebas2
where total_laid_off is null and percentage_laid_off is null;

-- Elimino los registros que tienen NULL en total_laid_off y percentage_laid_off
DELETE 
from layoffs_pruebas2
where total_laid_off is null and percentage_laid_off is null;

--  Elimino la columna row_num
ALTER TABLE layoffs_pruebas2
DROP COLUMN row_num;


