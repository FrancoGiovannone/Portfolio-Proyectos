--Limpiando Datos del archivo 'Nashville Housing Data for Data Cleaning'

USE PortfolioProject

SELECT * FROM NashvilleCasas


--Convierto la columna SaleDate a formato Fecha estandarizada

--Comparo la columna SaleDate con SaleDateConvert
select SaleDate, CONVERT(Date,SaleDate) as SaleDateConvert 
from NashvilleCasas

--Agrego la columna SaleDateConvert
alter table NashvilleCasas
add SaleDateConvert Date

--Completo la columna SaleDateConvert con los datos de SaleDate en formato Date
update NashvilleCasas
set SaleDateConvert = CONVERT(Date, SaleDate)

select * from NashvilleCasas

--Completando los datos que faltan de la columna PropertyAddres

--Veo que propiedades coinciden en ParcelID, que es un valor único, y tienen datos nulos en PropertyAddress 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleCasas a
join NashvilleCasas b on a.ParcelID = b.ParcelID
where a.PropertyAddress is null and a.[UniqueID ]<>b.[UniqueID ]

--Relleno los datos nulos de PropertyAddress
update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleCasas a
join NashvilleCasas b on a.ParcelID = b.ParcelID
where a.PropertyAddress is null and a.[UniqueID ]<>b.[UniqueID ]

--Parto la columna PropertyAddress en Address y City
select PropertyAddress, 
       SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, len(PropertyAddress)) as City
from NashvilleCasas

--Agrego la columna PropertySplitAdrress que contiene solo la dirección
alter table NashvilleCasas
add PropertySplitAdrress nvarchar(255)

--Relleno PropertySplitAdrress
update NashvilleCasas
set PropertySplitAdrress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

--Agrego la columna PropertySplitCity que contiene solo la ciudad
alter table NashvilleCasas
add PropertySplitCity nvarchar(255)

--Relleno PropertySplitCity
update NashvilleCasas
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, len(PropertyAddress))

select * from NashvilleCasas

--Parto la columna OwnerAddress en Address, City y State
Select OwnerAddress,
       PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
       PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
       PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleCasas



ALTER TABLE NashvilleCasas
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleCasas
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleCasas
Add OwnerSplitCity Nvarchar(255);

Update NashvilleCasas
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleCasas
Add OwnerSplitState Nvarchar(255);

Update NashvilleCasas
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NashvilleCasas

-- Veo que valores tengo en el campo soldasvacant y cuantos de cada uno
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleCasas
Group by SoldAsVacant
order by 2

--Cambio las 'Y' por 'Yes' y las 'N' por 'No' en el campo SoldAsVacant
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleCasas


Update NashvilleCasas
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Confirmo que el cambio se hizo correctamente
--Select SoldAsVacant 
--from NashvilleCasas
--Where SoldAsVacant = 'N' or SoldAsVacant = 'Y'

--Remuevo filas duplicadas
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleCasas)
DELETE
From RowNumCTE
Where row_num > 1

--Veo si se removieron correctamente los duplicados
--WITH RowNumCTE AS(
--Select *,
--	ROW_NUMBER() OVER (
--	PARTITION BY ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 ORDER BY
--					UniqueID
--					) row_num

--From NashvilleCasas)
--Select *
--From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress

-- Delete Unused Columns



Select *
From NashvilleCasas
--Elimino columnas que no son útiles
ALTER TABLE NashvilleCasas
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


