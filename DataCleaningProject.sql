/** 
Data Cleaning In SQL Queries

**/


select *
from DataCleaningSQL..NashvilelHousing

-- Standardzie Date Formart

SELECT SaleDateConverted, CONVERT( Date, SaleDate)
from DataCleaningSQL..NashvilelHousing

UPDATE NashvilelHousing
SET SaleDate =CONVERT( Date, SaleDate)


ALTER TABLE  NashvilelHousing
Add SaleDateconverted Date

UPDATE NashvilelHousing
set SaleDateconverted= CONVERT(date, SaleDate)

--Populate	Property Data


SELECT *
from DataCleaningSQL..NashvilelHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from DataCleaningSQL..NashvilelHousing a
JOIN DataCleaningSQL..NashvilelHousing b
   on a.ParcelID = b.ParcelID
   and a. [UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 --updating table

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from DataCleaningSQL..NashvilelHousing a
JOIN DataCleaningSQL..NashvilelHousing b
   on a.ParcelID = b.ParcelID
   and a. [UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 
 --Breaking Out Address Into Individual Coloumns (Address, City , State)

 SELECT PropertyAddress
from DataCleaningSQL..NashvilelHousing
--where PropertyAddress is null
--order by ParcelID

select
    SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress )-1) as Address
	
   , SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress )+1, LEN(PropertyAddress)) as Address
from DataCleaningSQL..NashvilelHousing



--creating new colounms



ALTER TABLE  NashvilelHousing
Add PropertySliptAddress nvarchar(255)

UPDATE NashvilelHousing
set PropertySliptAddress =  SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress )-1)  



ALTER TABLE  NashvilelHousing
Add PropertySliptCity nvarchar (255) 

UPDATE NashvilelHousing
set PropertySliptCity= SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress )+1, LEN(PropertyAddress)) 


SELECT *
from DataCleaningSQL..NashvilelHousing



SELECT OwnerAddress
from DataCleaningSQL..NashvilelHousing

select 
PARSENAME(replace( OwnerAddress, ','  ,'.' ),3),
PARSENAME(replace( OwnerAddress, ','  ,'.' ),2),
PARSENAME(replace( OwnerAddress, ','  ,'.' ),1)
from DataCleaningSQL..NashvilelHousing



--creating new coloumn

ALTER TABLE  NashvilelHousing
Add  OwnerSliptAddress nvarchar(255)

UPDATE NashvilelHousing
set OwnerSliptAddress =  PARSENAME(replace( OwnerAddress, ','  ,'.' ),3)

ALTER TABLE  NashvilelHousing
Add OwnerSliptCity nvarchar (255) 

UPDATE NashvilelHousing
set OwnerSliptCity= PARSENAME(replace( OwnerAddress, ','  ,'.' ),2)

ALTER TABLE  NashvilelHousing
Add OwnerSliptState nvarchar (255) 

UPDATE NashvilelHousing
set OwnerSliptState= PARSENAME(replace( OwnerAddress, ','  ,'.' ),1)

SELECT *
from DataCleaningSQL..NashvilelHousing



--Change Y and N to Yes and No in "Sold as Vacant) field 


select Distinct (SoldAsVacant), count (SoldAsVacant)
from DataCleaningSQL..NashvilelHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end
from DataCleaningSQL..NashvilelHousing 


update NashvilelHousing
set SoldAsVacant =   Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end
from DataCleaningSQL..NashvilelHousing 


--Removing Duplicate




;with RowNumCTE AS (
select* ,
      ROW_NUMBER() over (
      partition by 
               ParcelID, 
	           PropertyAddress,
	           SalePrice, 
	           SaleDate,
	           LegalReference
			   order by 
			   UniqueID
			   )row_num
from DataCleaningSQL..NashvilelHousing
--order by  ParcelID
)
DELETE 
FROM RowNumCTE 
WHERE row_num >1
--ORDER BY PropertyAddress


--Delete Unwanted Coloumn



SELECT *
from DataCleaningSQL..NashvilelHousing

ALTER TABLE DataCleaningSQL..NashvilelHousing
DROP COLUMN	OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE DataCleaningSQL..NashvilelHousing
DROP COLUMN	SaleDate