/*
Table: Customers
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/

-- How many total customers are there? 

select COUNT(Distinct customer_id) as total_customer
from Customers

-- How many duplicate customer_ids exist?

select count(customer_id) as duplicates_count
from (
SELECT customer_id
FROM Customers
GROUP BY customer_id
HAVING COUNT(customer_id) = 2
) as t

-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS id_missing,
    COUNT(CASE WHEN customer_name IS NULL THEN 1 END) AS name_missing,
    COUNT(CASE WHEN gender IS NULL THEN 1 END) AS gender_missing,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS age_missing,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS city_missing,
    COUNT(CASE WHEN state IS NULL THEN 1 END) AS state_missing,
    COUNT(CASE WHEN signup_date IS NULL THEN 1 END) AS date_missing
FROM customers;

-- Checking Data inconistency in Each Column 

select Distinct gender 
from customers
select Distinct city 
from customers
select Distinct state 
from customers

-- Inconsistency Data are present on Gender Column

-- Correcting Data in Gender Column
select 
case
when gender = 'F' then 'female'
when gender = 'M' then 'male'
else gender
end as gender
from customers

-- Selecting Only Those where CustomerName is present

SELECT *
FROM customers
WHERE customer_name IS NOT NULL


-- Creating Views to Further Analysis

CREATE VIEW customers_clean AS
WITH dedup AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) AS rn
FROM customers
)
SELECT customer_id, customer_name,
CASE
WHEN gender IN ('M','male','Male') THEN 'Male'
WHEN gender IN ('F','female','Female') THEN 'Female'
ELSE 'Unknown'
END AS gender, age, city, state, signup_date
FROM dedup
WHERE 
rn = 1               
AND customer_name IS NOT NULL




/*
Table: Orders
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/


-- How many duplicate order id exist?

select count(order_id) as duplicates_order_count
from (
SELECT order_id
FROM orders
GROUP BY order_id
HAVING COUNT(order_id) = 2
) as t


-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS id_missing,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS customer_missing,
    COUNT(CASE WHEN order_date IS NULL THEN 1 END) AS order_date_missing,
    COUNT(CASE WHEN ship_date IS NULL THEN 1 END) AS ship_missing,
    COUNT(CASE WHEN delivery_date IS NULL THEN 1 END) AS delivery_date_missing,
    COUNT(CASE WHEN order_status IS NULL THEN 1 END) AS order_status_missing
FROM orders;

-- Check How many order has been ordered

select count(distinct order_id) as total_orders
from orders


-- Checking Data inconistency in Each Column 

select Distinct order_status 
from orders

-- Order Status has Incosistent Data

SELECT 
    CASE 
        WHEN order_status IN ('Delivered','DELIVERED','delivered') THEN 'Delivered'
        WHEN order_status IN ('Canceled','Cancelled') THEN 'Cancelled'
        ELSE order_status
    END AS order_status_clean
FROM orders;


-- Selecting Only Those where CustomerName is present

select *
from orders
where order_id is not null


-- ship_date before order_date and delivery before shipping


SELECT *
FROM orders
WHERE ship_date > order_date and delivery_date > ship_date;


-- Creating views for Furthur Analysis 

CREATE VIEW orders_clean AS
WITH dedup AS (
SELECT *, ROW_NUMBER() OVER ( PARTITION BY order_id ORDER BY order_date DESC) AS rn
FROM orders
)
SELECT order_id, customer_id, order_date, ship_date, delivery_date,
CASE 
WHEN order_status IN ('Delivered','DELIVERED','delivered') THEN 'Delivered'
WHEN order_status IN ('Canceled','Cancelled') THEN 'Cancelled'
ELSE order_status
END AS order_status
FROM dedup
WHERE 
rn = 1   
AND order_id IS NOT NULL
AND customer_id IS NOT NULL
AND (ship_date IS NULL OR ship_date >= order_date)
AND (delivery_date IS NULL OR delivery_date >= ship_date)



/*
Table: Products
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/



-- How many Product are there

select COUNT(Distinct product_name) as total_product
from Products

-- How many duplicate customer_ids exist?

select COUNT(product_id) as duplicates_product_count
from (
SELECT product_id
FROM products
GROUP BY product_id
HAVING COUNT(product_id) = 2
) as t

-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS id_missing,
    COUNT(CASE WHEN product_name IS NULL THEN 1 END) AS customer_missing,
    COUNT(CASE WHEN category IS NULL THEN 1 END) AS order_date_missing,
    COUNT(CASE WHEN sub_category IS NULL THEN 1 END) AS ship_missing,
    COUNT(CASE WHEN cost_price IS NULL THEN 1 END) AS delivery_date_missing
FROM products;


-- Checking Data inconistency in Each Column 

select Distinct category 
from products
select Distinct sub_category 
from products

-- No Inconsistent Data are present

--- Creating Views for Further Analysis

CREATE VIEW products_clean AS
WITH dedup AS (
SELECT *, ROW_NUMBER() OVER ( PARTITION BY product_id ORDER BY product_id) AS rn
FROM products
)
SELECT product_id as product_id, product_name, UPPER(category) AS category, UPPER(sub_category) AS sub_category, 
CASE 
    WHEN CAST(cost_price AS float) < 0 THEN NULL
    ELSE CAST(cost_price AS float)  
END AS cost_price
FROM dedup
WHERE 
rn = 1                
AND product_id IS NOT NULL
AND product_name IS NOT NULL


/*
Table: Order_items
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/



-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN order_item_id IS NULL THEN 1 END) AS order_item_missing,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS order_id_missing,
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS product_id_missing,
    COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS quantity_missing,
    COUNT(CASE WHEN selling_price IS NULL THEN 1 END) AS sellingprice_missing,
    COUNT(CASE WHEN discount IS NULL THEN 1 END) AS discount_missing,
    COUNT(CASE WHEN profit IS NULL THEN 1 END) AS profit_missing
FROM order_items;

-- negative or zero quantity
SELECT *
FROM order_items
WHERE quantity <= 0;

-- unrealistic profit ❌
SELECT *
FROM order_items
WHERE profit < 0 OR profit > selling_price * quantity;


-- Creating View for Furthur  Analysis

CREATE VIEW order_items_clean AS
WITH dedup AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY order_item_id ORDER BY order_item_id) AS rn
FROM order_items
)
SELECT order_item_id, order_id, product_id, quantity, selling_price, discount , profit
FROM dedup
WHERE 
rn = 1                          
AND order_item_id IS NOT NULL   
AND quantity > 0                
AND selling_price IS NOT NULL
AND profit IS NOT NULL
AND profit >= 0
AND profit <= (selling_price * quantity);  



/*
Table: Region
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/



-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN region_id IS NULL THEN 1 END) AS region_id_missing,
    COUNT(CASE WHEN state IS NULL THEN 1 END) AS state_missing,
    COUNT(CASE WHEN region IS NULL THEN 1 END) AS region_missing,
    COUNT(CASE WHEN zone IS NULL THEN 1 END) AS zone_missing
FROM regions;



/*
Table: Payment
1. Missing Values Check
2. Duplicate Records
3. Data Type Issues
4. Inconsistent Values
*/

-- How many missing values in Each Column ?

SELECT
    COUNT(CASE WHEN payment_id IS NULL THEN 1 END) AS payment_id_missing,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS order_id_missing,
    COUNT(CASE WHEN payment_method IS NULL THEN 1 END) AS payment_missing,
    COUNT(CASE WHEN payment_status IS NULL THEN 1 END) AS status_missing,
    COUNT(CASE WHEN payment_value IS NULL THEN 1 END) AS value_missing
FROM payments;


-- Checking Data inconistency in Each Column 

select Distinct payment_method 
from payments
select Distinct payment_status 
from payments


-- Correcting Data Inconsistency in payment Method Column

select 
case
when payment_method = 'Credit Card' then 'Creditcard'
when payment_method = 'credit_card' then 'Creditcard'
when payment_method = 'CC' then 'Creditcard'
when payment_method = 'GPay' then 'Googlepay'
when payment_method = 'Google Pay' then 'Googlepay'
when payment_method = 'upi' then 'UPI'
else payment_method
end as payment_method
from payments


-- Creating View for Further Analysis

CREATE VIEW payments_clean AS
WITH dedup AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY payment_id) AS rn
FROM payments
)
SELECT
payment_id, order_id,
CASE
WHEN payment_method IN ('Credit Card','credit_card','CC') THEN 'CreditCard'
WHEN payment_method IN ('GPay','Google Pay') THEN 'GooglePay'
WHEN payment_method IN ('upi','UPI') THEN 'UPI'
ELSE payment_method
END AS payment_method,
CASE
WHEN payment_status IN ('Success','success','SUCCESS') THEN 'Success'
WHEN payment_status IN ('Failed','failed') THEN 'Failed'
ELSE payment_status
END AS payment_status,
CASE
WHEN payment_value <= 0 THEN NULL
ELSE payment_value
END AS payment_value
FROM dedup
WHERE 
rn = 1
AND payment_id IS NOT NULL
AND order_id IS NOT NULL;



