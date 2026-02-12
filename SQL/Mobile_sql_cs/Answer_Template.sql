--SQL Advance Case Study


--Q1--BEGIN 

SELECT DISTINCT DL.State
FROM DIM_LOCATION AS DL
JOIN FACT_TRANSACTIONS  AS FT 
ON DL.IDLocation = FT.IDLocation
WHERE FT.Date >= '2005-01-01';






--Q1--END

--Q2--BEGIN

SELECT TOP 1 DL.State, SUM(FT.Quantity) AS TOTAL_Quantiy
FROM DIM_LOCATION AS DL
JOIN FACT_TRANSACTIONS  AS FT 
ON DL.IDLocation = FT.IDLocation
JOIN DIM_MODEL AS DM
ON DM.IDMODEL = FT.IDMODEL
WHERE DM.IDManufacturer = 12 AND DL.Country = 'US'
GROUP BY DL.State
ORDER BY TOTAL_Quantiy DESC









--Q2--END

--Q3--BEGIN      
SELECT
DM.Model_Name, 
DL.ZipCode, 
DL.State,
COUNT(*) AS COUNT_PER_MODEL
FROM DIM_MODEL AS DM
JOIN FACT_TRANSACTIONS AS FT 
ON DM.IDModel = FT.IDModel
JOIN DIM_LOCATION AS DL 
ON DL.IDLocation = FT.IDLocation
GROUP BY 
DM.Model_Name,
DL.ZipCode, 
DL.State
ORDER BY
DL.State,
DL.ZipCode,
DM.Model_Name;










--Q3--END

--Q4--BEGIN
SELECT IDModel,	Model_Name,	Unit_price	
FROM DIM_MODEL
WHERE Unit_price = ( SELECT MIN(Unit_price) AS MIN_price
FROM DIM_MODEL )






--Q4--END

--Q5--BEGIN


SELECT
       DM.Model_Name,
       AVG(DM.Unit_price) AS Avg_Price
FROM DIM_MODEL DM
WHERE DM.IDManufacturer IN (
        SELECT TOP 5
               DM2.IDManufacturer
        FROM FACT_TRANSACTIONS FT
        JOIN DIM_MODEL DM2
            ON FT.IDModel = DM2.IDModel
        GROUP BY DM2.IDManufacturer
        ORDER BY SUM(FT.Quantity) DESC
)
GROUP BY DM.Model_Name
ORDER BY Avg_Price DESC;











--Q5--END

--Q6--BEGIN



SELECT
DC.Customer_Name,
AVG(FT.TotalPrice) AS Avg_Amount_Spent
FROM DIM_CUSTOMER DC
JOIN FACT_TRANSACTIONS FT
ON DC.IDCustomer = FT.IDCustomer
WHERE FT.Date >= '2009-01-01'
AND FT.Date <  '2010-01-01'
GROUP BY DC.Customer_Name
HAVING AVG(FT.TotalPrice) > 500;










--Q6--END
	
--Q7--BEGIN  


SELECT *
FROM (
SELECT TOP 5 t1.IDModel
FROM FACT_TRANSACTIONS AS t1
WHERE Year(Date) = 2008
GROUP BY t1.IDModel, Year(Date)
ORDER BY SUM(Quantity) DESC ) AS A
INTERSECT
SELECT *
FROM (
SELECT TOP 5 t1.IDModel
FROM FACT_TRANSACTIONS AS t1
WHERE Year(Date) = 2009
GROUP BY t1.IDModel, Year(Date)
ORDER BY SUM(Quantity) DESC ) AS B
INTERSECT
SELECT *
FROM (
SELECT TOP 5 t1.IDModel
FROM FACT_TRANSACTIONS AS t1
WHERE Year(Date) = 2010
GROUP BY t1.IDModel, Year(Date)
ORDER BY SUM(Quantity) DESC ) AS C
	
















--Q7--END	
--Q8--BEGIN

WITH Manufacturer_Sales AS (
SELECT
MF.Manufacturer_Name,
YEAR(FT.Date) AS Sales_Year,
SUM(FT.TotalPrice) AS Total_sales
FROM FACT_TRANSACTIONS FT
JOIN DIM_MODEL DM
ON FT.IDModel = DM.IDModel
JOIN DIM_MANUFACTURER MF
ON DM.IDManufacturer = MF.IDManufacturer
WHERE YEAR(FT.Date) IN (2009, 2010)
GROUP BY
MF.Manufacturer_Name,
YEAR(FT.Date)
),
Ranked_Manufacturers AS (
SELECT
Manufacturer_Name,
Sales_Year,
Total_sales,
DENSE_RANK() OVER (
PARTITION BY Sales_Year
ORDER BY Total_sales DESC
) AS Sales_Rank
FROM Manufacturer_Sales
)
SELECT
Sales_Year,
Manufacturer_Name,
Total_sales
FROM Ranked_Manufacturers
WHERE Sales_Rank = 2
ORDER BY Sales_Year;















--Q8--END
--Q9--BEGIN

SELECT DISTINCT
MF.Manufacturer_Name
FROM FACT_TRANSACTIONS FT
JOIN DIM_MODEL DM
ON FT.IDModel = DM.IDModel
JOIN DIM_MANUFACTURER MF
ON DM.IDManufacturer = MF.IDManufacturer
WHERE FT.Date >= '2010-01-01'
AND FT.Date <  '2011-01-01'
EXCEPT
SELECT DISTINCT
MF.Manufacturer_Name
FROM FACT_TRANSACTIONS FT
JOIN DIM_MODEL DM
ON FT.IDModel = DM.IDModel
JOIN DIM_MANUFACTURER MF
ON DM.IDManufacturer = MF.IDManufacturer
WHERE FT.Date >= '2009-01-01'
  AND FT.Date <  '2010-01-01';

	

















--Q9--END

--Q10--BEGIN
	
SELECT *, ((avg_price - lag_price)/Lag_price) AS percentage_change 
FROM 
( SELECT *, LAG(avg_price,1) OVER (partition by idcustomer order by YEAR_ ) as Lag_price 
FROM(
SELECT IDCustomer, Year(date) AS YEAR_, AVG(TotalPrice) AS avg_price, SUM(Quantity) AS Qty
FROM FACT_TRANSACTIONS 
WHERE IDCustomer IN ( 
SELECT TOP 10 IDCustomer 
FROM FACT_TRANSACTIONS
GROUP BY IDCustomer
ORDER BY SUM(TotalPrice) DESC )
GROUP BY IDCustomer, YEAR(DATE)
) AS A 
 ) AS B

















--Q10--END
	
