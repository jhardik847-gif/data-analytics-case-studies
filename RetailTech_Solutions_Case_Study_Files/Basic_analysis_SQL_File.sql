

-- Who are the top 10 customers by total revenue? 

with cust_revenue as (
select c.customer_id, sum(ot.quantity * ot.selling_price) as total_revenue
from customers_clean as c
join orders_clean as o
on c.customer_id = o.customer_id
join order_items_clean as ot
on o.order_id = ot.order_id
group by c.customer_id
), 
ranking as (
select *,
DENSE_RANK() over (order by total_revenue desc) as ranking
from cust_revenue
)
select *
from ranking
where ranking <= 10


-- What is the average order value per customer? 

select c.customer_id, round(avg(ot.quantity * ot.selling_price),2) as avg_revenue
from customers_clean as c
join orders_clean as o
on c.customer_id = o.customer_id
join order_items_clean as ot
on o.order_id = ot.order_id
group by c.customer_id
order by avg_revenue desc


-- How many repeat customers do we have?

SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders_clean
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS repeat;

-- What % of customers are one-time buyers?

SELECT COUNT(*)*100 / (select COUNT(customer_id) from customers_clean) AS pct_not_repeat_customers
FROM (
    SELECT customer_id
    FROM orders_clean
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS repeat;


-- Customer distribution by region and ZONE

select r.region ,count(c.customer_id) as total_customer
from customers_clean as c
join regions as r
on c.state = r.state
group by r.region
order by total_customer desc

select r.zone ,count(c.customer_id) as total_customer
from customers_clean as c
join regions as r
on c.state = r.state
group by r.zone
order by total_customer desc


-- Customers with highest purchase frequency 

select c.customer_id, count(o.order_id) as purchase_frequency
from customers_clean as c
join orders as o
on c.customer_id = o.customer_id
group by c.customer_id
order by purchase_frequency desc

-- Total revenue generated overall 

select sum(quantity*selling_price) as total_revenue
from order_items_clean


-- Monthly revenue trend

select FORMAT(o.order_date, 'MM') as month_no, sum(ot.quantity*ot.selling_price) as total_revenue
from orders_clean as o
join order_items_clean as ot
on o.order_id = ot.order_id
group by FORMAT(o.order_date, 'MM')
order by FORMAT(o.order_date, 'MM')

-- Revenue by region 

select r.region, sum(ot.quantity*ot.selling_price) as total_revenue
from order_items_clean as ot
join orders_clean as o
on ot.order_id = o.order_id
join customers_clean as c
on c.customer_id = o.customer_id
join regions as r
on c.state = r.state
group by r.region

-- Revenue by payment method 

select p.payment_method ,sum(ot.quantity*ot.selling_price) as total_revenue
from order_items_clean as ot
join payments_clean as p
on ot.order_id = p.order_id
group by p.payment_method


-- Daily/weekly order trends 

SELECT 
    DATEPART(YEAR, order_date) AS year,
    DATEPART(WEEK, order_date) AS week_number,
    COUNT(order_id) AS total_orders
FROM orders_clean
GROUP BY 
    DATEPART(YEAR, order_date),
    DATEPART(WEEK, order_date)
ORDER BY 
    year, week_number;



-- Peak sales months 

select TOP 10 FORMAT(o.order_date, 'MM-yy') as month_no, round(sum(ot.quantity*ot.selling_price), 2 )as total_revenue
from orders_clean as o
join order_items_clean as ot
on o.order_id = ot.order_id
group by FORMAT(o.order_date, 'MM-yy')
order by total_revenue desc

-- Top 10 products by revenue 

select top 10 p.product_id , round(sum(ot.quantity*ot.selling_price), 2 )as total_revenue
from order_items_clean as ot
join products_clean as p
on ot.product_id = p.product_id
group by p.product_id
order by total_revenue desc


-- Top 10 products by profit 

select top 10 p.product_id , round(ot.profit, 2 ) as profit 
from order_items_clean as ot
join products_clean as p
on ot.product_id = p.product_id
order by ot.profit desc


-- Products generating losses
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.profit) AS total_profit
FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id
GROUP BY 
    p.product_id,
    p.product_name
HAVING 
    SUM(oi.profit) < 0
ORDER BY 
    total_profit ASC;


-- •	Profit margin by category 

SELECT 
    p.category,
    SUM(oi.profit) AS total_profit,
    SUM(oi.quantity * oi.selling_price) AS total_revenue,
    SUM(oi.profit) * 1.0 / 
    NULLIF(SUM(oi.quantity * oi.selling_price), 0) AS profit_margin

FROM order_items_clean oi
JOIN products_clean p
    ON oi.product_id = p.product_id

GROUP BY p.category
ORDER BY profit_margin DESC;



-- •	Category-wise revenue contribution 

Select p.category, round(sum(ot.quantity*ot.selling_price), 2 )as total_revenue
from order_items_clean as ot
join products_clean as p
on ot.product_id = p.product_id
group by p.category
order by total_revenue desc

-- •	Sub-category performance 

Select p.sub_category, round(sum(ot.quantity*ot.selling_price), 2 )as total_revenue
from order_items_clean as ot
join products_clean as p
on ot.product_id = p.product_id
group by p.sub_category
order by total_revenue desc


-- •	Discount vs Profit analysis (aggregated) 




-- •	What is the average discount given? 

SELECT AVG(TRY_CAST(discount AS float)) AS avg_discount
FROM order_items_clean;


-- •	Does higher discount lead to lower profit?

-- Query to find Correlation between Discount and Profit
SELECT 
    discount_bracket,
    AVG(CAST(profit AS float)) AS avg_profit,
    COUNT(*) AS total_orders
FROM (
    SELECT 
        -- Discount ko numeric mein badalna zaroori hai comparison ke liye
        CASE 
            WHEN TRY_CAST(discount AS float) <= 0.1 THEN 'Low (0-10%)'
            WHEN TRY_CAST(discount AS float) <= 0.2 THEN 'Medium (11-20%)'
            ELSE 'High (>20%)'
        END AS discount_bracket,
        -- Profit ko bhi safe convert karein
        TRY_CAST(profit AS float) as profit
    FROM order_items_clean
) AS subquery
WHERE profit IS NOT NULL
GROUP BY discount_bracket
ORDER BY avg_profit DESC;


/*
•	Profit for: 
o	discount < 10% 
o	discount 10–30% 
o	discount > 30%
*/


-- Query to find Correlation between Discount and Profit
SELECT 
    discount_bracket,
    sum(CAST(profit AS float)) AS avg_profit
FROM (
    SELECT 
        -- Discount ko numeric mein badalna zaroori hai comparison ke liye
        CASE 
            WHEN TRY_CAST(discount AS float) <= 0.1 THEN 'Low (0-10%)'
            WHEN TRY_CAST(discount AS float) <= 0.2 THEN 'Medium (11-20%)'
            ELSE 'High (>20%)'
        END AS discount_bracket,
        -- Profit ko bhi safe convert karein
        TRY_CAST(profit AS float) as profit
    FROM order_items_clean
) AS subquery
WHERE profit IS NOT NULL
GROUP BY discount_bracket
ORDER BY avg_profit DESC;

select *
from orders_clean

-- •	Average delivery time 

select avg(coalesce(datediff(day, ship_date, delivery_date),0 ))as avg_deliver_time
from orders_clean

-- •	Orders delivered late (>7 days) 

select order_id , coalesce(datediff(day, ship_date, delivery_date),0 )as deliver_time
from orders_clean
where coalesce(datediff(day, ship_date, delivery_date),0 ) > 7

-- •	Cancellation rate 
select count(order_id)*100/ (select count(order_id) from orders_clean) as Cancellation_rate
from orders_clean
where order_status = 'Cancelled'


-- •	Delivery performance by region

select r.region, avg(coalesce(datediff(day, ship_date, delivery_date),0 ))as avg_deliver_time
from orders_clean as o
join customers_clean as c
on o.customer_id = c.customer_id
join regions as r
on c.state = r.state
group by r.region

-- •	Most used payment method
select p.payment_method, count(o.order_id) as total_orders
from orders_clean as o
join order_items_clean as ot
on o.order_id = ot.order_id
join payments_clean as p
on p.order_id = o.order_id
group by p.payment_method

-- •	Revenue by payment type

select p.payment_method, sum(ot.quantity*ot.selling_price) as total_revenue
from orders_clean as o
join order_items_clean as ot
on o.order_id = ot.order_id
join payments_clean as p
on p.order_id = o.order_id
group by p.payment_method


-- •	Failed payment rate

select count(payment_id)*100 / (select count(payment_id) from payments_clean) as failed_rate
from payments_clean 
where payment_status = 'Failed'

-- •	Payment method vs cancellation rate 

SELECT 
    payment_method,
    COUNT(CASE WHEN payment_status = 'Failed' THEN 1 END) * 100.0 / COUNT(*) AS failed_rate_percentage
FROM payments_clean
GROUP BY payment_method
ORDER BY failed_rate_percentage DESC;


-- •	Rank customers by revenue (RANK)

with cust_revenue as (
select c.customer_id, sum(ot.quantity * ot.selling_price) as total_revenue
from customers_clean as c
join orders_clean as o
on c.customer_id = o.customer_id
join order_items_clean as ot
on o.order_id = ot.order_id
group by c.customer_id
), 
ranking as (
select *,
DENSE_RANK() over (order by total_revenue desc) as ranking
from cust_revenue
)
select *
from ranking


-- •	Top customer in each region
with cust_revenue as (
select r.region, c.customer_id, sum(ot.quantity*ot.selling_price) as revenue
from customers_clean as c
join orders_clean as o
on c.customer_id = o.customer_id
join regions as r
on c.state = r.state
join order_items_clean as ot
on o.order_id = ot.order_id
group by r.region, c.customer_id
),
ranking as (
select *,
DENSE_RANK() over (partition by region order by revenue desc) as ranking
from cust_revenue
)
select *
from ranking
where ranking <= 5


-- •	Running total of revenue (WINDOW FUNCTION) 

WITH daily_revenue AS (
SELECT CAST(o.order_date AS DATE) AS order_date, SUM(oi.quantity * oi.selling_price) AS revenue
FROM orders_clean o
JOIN order_items_clean oi
ON o.order_id = oi.order_id
GROUP BY CAST(o.order_date AS DATE)
)
SELECT order_date, revenue,
SUM(revenue) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM daily_revenue
ORDER BY order_date;



-- •	Monthly growth % (LAG function)

WITH monthly_revenue AS (
SELECT YEAR(o.order_date) AS year, MONTH(o.order_date) AS month, SUM(oi.quantity * oi.selling_price) AS revenue
FROM orders_clean o
JOIN order_items_clean oi
ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT year, month, revenue,
LAG(revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
(revenue - LAG(revenue) OVER (ORDER BY year, month)) * 1.0 /
NULLIF(LAG(revenue) OVER (ORDER BY year, month), 0) AS growth_percentage
FROM monthly_revenue
ORDER BY year, month;
