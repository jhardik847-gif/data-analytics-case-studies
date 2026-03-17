SELECT * FROM pizza_sales_csv

SELECT SUM(quantity*unit_price) as total_revenu
FROM pizza_sales_csv

SELECT SUM(quantity*unit_price)/COUNT( DISTINCT order_id) as average_order_value
FROM pizza_sales_csv

SELECT SUM(quantity) as total_count_pizza
FROM pizza_sales_csv

SELECT COUNT(DISTINCT order_id) as total_unique_order
FROM pizza_sales_csv

SELECT CAST(SUM(quantity) as decimal(10,2)) / CAST(COUNT(DISTINCT order_id) as decimal(10,2)) as avg_pizza_orders
FROM pizza_sales_csv

SELECT DATENAME(DW, order_date) as day_name, COUNT(DISTINCT order_id) as total_orders
FROM pizza_sales_csv
GROUP BY DATENAME(DW, order_date)

SELECT DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1) as date_month, COUNT(DISTINCT order_id) as total_orders
FROM pizza_sales_csv
GROUP BY DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1)
ORDER  BY DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1)


SELECT pizza_category, ROUND(SUM(total_price),4) as total_sales,
ROUND(SUM(total_price)*100 / (SELECT SUM(total_price) from pizza_sales_csv), 2) as category_pct
FROM pizza_sales_csv
GROUP BY pizza_category

SELECT pizza_size, ROUND(SUM(total_price),4) as total_sales,
ROUND(SUM(total_price)*100 / (SELECT SUM(total_price) from pizza_sales_csv), 2) as category_pct
FROM pizza_sales_csv
GROUP BY pizza_size
ORDER BY category_pct DESC

SELECT DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1) as date_month,
CAST(SUM(total_price) as decimal(10,2) ) as total_revenue
FROM pizza_sales_csv
GROUP BY DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1)
ORDER  BY DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1)

SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales_csv
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC


SELECT TOP 5 pizza_name, SUM(total_price) as total_revenue
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_revenue DESC

SELECT TOP 5 pizza_name, SUM(quantity) as total_quantity
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_quantity DESC

SELECT TOP 5 pizza_name, COUNT(order_id) as total_order
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_order DESC


SELECT TOP 5 pizza_name, SUM(total_price) as total_revenue
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_revenue 

SELECT TOP 5 pizza_name, SUM(quantity) as total_quantity
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_quantity 

SELECT TOP 5 pizza_name, COUNT(order_id) as total_order
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY total_order