--1)
SELECT COUNT(*) AS cnt FROM Customer
UNION
SELECT COUNT(*) AS cnt FROM prod_cat_info
UNION
SELECT COUNT(*) AS cnt FROM Transactions;

--2)
SELECT COUNT(DISTINCT(transaction_id)) AS tot_trans FROM Transactions
WHERE total_amt < 0;

-- 3 
SELECT CONVERT(DATE,tran_date, 105) AS Tran_dates FROM Transactions;

--4) 
SELECT DATEDIFF(YEAR,MIN(CONVERT(DATE,tran_date,105)),MAX(CONVERT(DATE,tran_date,105))) AS Diff_year,
DATEDIFF(MONTH,MIN(CONVERT(DATE,tran_date,105)),MAX(CONVERT(DATE,tran_date,105))) AS Diff_month,
DATEDIFF(DAY,MIN(CONVERT(DATE,tran_date,105)),MAX(CONVERT(DATE,tran_date,105))) AS Diff_days
From Transactions;

--5)
SELECT prod_cat, prod_subcat
FROM prod_cat_info
WHERE prod_subcat = 'DIY';

--DATA ANALYSIS


--1)
SELECT TOP 1 Store_type, COUNT(*) AS Count_channel
FROM Transactions
Group by Store_type
ORDER BY Count_channel DESC

--2)
SELECT Gender, COUNT(*) AS Count_gender
FROM Customer
WHERE  Gender is not null
GROUP BY Gender;

--3)
SELECT TOP 1 city_code, COUNT(*) AS Total_countBYcity
FROM Customer
GROUP BY city_code
ORDER BY Total_countBYcity DESC

--4)
SELECT distinct  prod_subcat
FROM prod_cat_info
WHERE prod_cat = 'Books'

--5)
SELECT prod_cat_code, MAX(qty) as Max_prod 
FROM Transactions
GROUP BY prod_cat_code

--6)
SELECT SUM(CAST(total_amt AS FLOAT )) AS Net_revenue
FROM prod_cat_info AS t1
JOIN Transactions AS t2
ON t1.prod_cat_code = t2.prod_cat_code AND t1.prod_sub_cat_code = t2.prod_subcat_code
WHERE prod_cat = 'Books' OR prod_cat = 'Electronics'

--7)

SELECT COUNT(*) AS Cust_plus_10
FROM (
SELECT cust_id, Count(distinct(transaction_id) ) AS total_count
FROM Transactions
where qty > 0
group by cust_id
Having Count(distinct(transaction_id) ) > 10 ) AS T


--8)
SELECT SUM(CAST(total_amt AS FLOAT)) AS com_revenue
FROM prod_cat_info AS t1
JOIN Transactions AS t2
ON t1.prod_cat_code = t2.prod_cat_code AND t1.prod_sub_cat_code = t2.prod_subcat_code
WHERE prod_cat IN ( 'Clothing', 'Electronics' ) AND Store_type = 'Flagship store';

--9)
SELECT prod_subcat, SUM(CAST(total_amt AS FLOAT)) AS Male_revenue
FROM prod_cat_info AS t1
JOIN Transactions AS t2
ON t1.prod_cat_code = t2.prod_cat_code AND t1.prod_sub_cat_code = t2.prod_subcat_code
JOIN Customer AS t3 
ON t2.cust_id = t3.customer_Id
WHERE Gender = 'M' AND prod_cat = 'Electronics'
GROUP BY prod_subcat

--10)
SELECT T5.prod_subcat, Percentage_sales, Percentage_returned
FROM (
SELECT TOP 5 prod_subcat,(SUM(CAST(total_amt AS FLOAT )) / 
( SELECT SUM(CAST(total_amt AS FLOAT)) AS 
TOTAL_SALES FROM Transactions WHERE Qty > 0 ) )  AS Percentage_sales
FROM prod_cat_info AS T1
JOIN Transactions AS t2
ON T1.prod_cat_code = t2.prod_cat_code AND T1.prod_sub_cat_code = t2.prod_subcat_code
WHERE Qty > 0
GROUP BY prod_subcat
ORDER BY Percentage_sales DESC ) AS T5
JOIN (
SELECT prod_subcat,(SUM(CAST(total_amt AS FLOAT )) / 
( SELECT SUM(CAST(total_amt AS FLOAT)) AS 
TOTAL_SALES FROM Transactions WHERE Qty < 0 ) )  AS Percentage_returned
FROM prod_cat_info AS T1
JOIN Transactions AS t2
ON T1.prod_cat_code = t2.prod_cat_code AND T1.prod_sub_cat_code = t2.prod_subcat_code
WHERE Qty < 0
GROUP BY prod_subcat ) AS T6
ON T5.prod_subcat = T6.prod_subcat

--11)
SELECT *
FROM (
SELECT *
FROM (
SELECT cust_id,
DATEDIFF(YEAR, DOB, Max_date) AS AGE, 
Total_revenue
FROM (
SELECT cust_id, DOB,
max(convert(date, tran_date, 105)) as Max_date,
SUM(CAST(T.total_amt AS FLOAT) )AS Total_revenue
FROM Customer AS C
JOIN  Transactions As T
On C.customer_Id = T.cust_id
WHERE Qty > 0
GROUP BY cust_id, DOB ) AS A ) AS B
WHERE AGE BETWEEN 25 AND 35 ) AS C
JOIN
( SELECT cust_id, Convert(date, tran_date, 105) AS Tran_date
FROM Transactions 
GROUP BY cust_id, Convert(date, tran_date, 105)
HAVING CONVERT(Date, tran_date, 105) >= 
( SELECT DATEADD(Day, -30, MAX(CONVERT(Date, tran_date, 105))) AS CUTOFF FROM Transactions)
) AS D
ON C.cust_id = D.cust_id

--12)
SELECT TOP 1 prod_cat_code, SUM(Returns) AS TOTAL_return 
FROM (
SELECT  prod_cat_code, Convert(date, tran_date, 105) AS Tran_date, SUM(CAST(Qty AS INT)) AS Returns
FROM Transactions 
WHERE Qty < 0
GROUP BY prod_cat_code, Convert(date, tran_date, 105)
HAVING CONVERT(Date, tran_date, 105) >= 
( SELECT DATEADD(Month, -3, MAX(CONVERT(Date, tran_date, 105))) AS CUTOFF FROM Transactions)
) AS A
GROUP BY prod_cat_code
ORDER BY TOTAL_return;

--13)
SELECT Store_type, SUM(total_amt) AS Total_sales, SUM(CAST(Qty AS INT)) AS Total_qty
FROM Transactions as t
WHERE Qty > 0
GROUP BY Store_type
ORDER BY Total_sales DESC, Total_qty DESC

--14)
SELECT prod_cat_code, AVG(total_amt) AS AVG_Revenue
FROM Transactions AS t
WHERE qty > 0
GROUP BY prod_cat_code
HAVING AVG(total_amt) > ( SELECT AVG(total_amt) AS AVG_overall
FROM Transactions
WHERE qty > 0 )

--15)
SELECT prod_subcat_code, AVG(total_amt) AS AVG_revenue, SUM(total_amt) AS Total_revenue
FROM Transactions
WHERE Qty > 0 AND prod_cat_code In ( SELECT TOP 5 prod_cat_code
FROM Transactions
WHERE Qty > 0
GROUP BY prod_cat_code
ORDER BY SUM(CAST(Qty AS INT)) DESC )
GROUP BY prod_subcat_code






