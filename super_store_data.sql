CREATE TABLE super_store_data(
row_id int, 
order_id VARCHAR(20), 
order_date DATE, 
ship_date DATE, 
ship_mode VARCHAR(50),
customer_id VARCHAR(20), 
customer_name VARCHAR(100), 
segment VARCHAR(50),
country VARCHAR(50), 
city VARCHAR(50), 
state VARCHAR(50),
postal_code VARCHAR(10), 
region VARCHAR(50), 
product_id VARCHAR(30), 
category VARCHAR(50), 
sub_category VARCHAR(50),
product_name TEXT, 
sales DECIMAL(10,2)
);

select * from super_store_data;

--1. Total Sales:
select sum(sales) as total_sales from super_store_data;

--2. Total Orders:
select count(distinct order_id) as total_orders from super_store_data;

--3. Sales by Category:
select category, sum(sales) as total_sales from super_store_data
group by category
order by total_sales desc;

--4. Sales by Region:
select region,sum(sales) as total_sales  from super_store_data
group by region
order by total_sales desc;

--Top 10 Cities by Sales:
select city, sum(sales) as total_sales from super_store_data
group by city
order by city desc limit 10;

--6. Monthly Sales Trend:

select TO_CHAR(order_date, 'YYYY-MM') as month, sum(sales) as total_sales
from super_store_data
group by month
order by month desc;

--Average Delivery Time:
SELECT order_id,AVG(ship_date - order_date) AS avg_delivery_days
FROM super_store_data
group by order_id ;

--Late deliveries:
SELECT * FROM(SELECT order_id,AVG(ship_date - order_date) AS avg_delivery_days
FROM super_store_data
group by order_id 
)sub

WHERE avg_delivery_days >INTERVAL '5 days'
order by order_id desc;


--Late deliveries(with CTE):
With late_delivery as (
SELECT order_id,AVG(ship_date - order_date) AS avg_delivery_days
FROM super_store_data
group by order_id 
)

select * from late_delivery where avg_delivery_days > INTERVAL '5 days'
order by order_id desc;

--ADVANCED (VERY IMPORTANT 🔥)
-- Month-over-Month Growth
select 
	date_trunc('month',order_date) as month ,
	sum (sales) as total_sales ,
	lag (sum (sales)) over (order by date_trunc('month',order_date)) as prev_month
from super_store_data
group by month;

--use cte Month-over-Month Growth:
with monthly_data as
(
select TO_CHAR(order_date, 'YYYY-MM') as month, sum(sales) as total_sales
from super_store_data
group by month
)

select month,total_sales ,
lag (total_sales) over (order by month) as prev_month from monthly_data
order by month desc;
