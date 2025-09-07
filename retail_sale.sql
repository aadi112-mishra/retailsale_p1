create database sales;
use sales;
SELECT count(*) FROM retailsalesanalysis;
select * FROM retailsalesanalysis
where quantiy>10;
SET SQL_SAFE_UPDATES = 0;
-- Data Cleaning
DELETE FROM retailsalesanalysis
where ï»¿transactions_id is NULL
OR sale_date is null
OR sale_time is null
OR customer_id is null
OR gender is null
OR age is null
OR category is null
OR quantiy is null
OR price_per_unit is null
OR cogs is null
OR total_sale is null;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale from retailsalesanalysis;
-- How many customers we have?
SELECT COUNT(customer_id) AS total_customer from retailsalesanalysis;

-- Data Ananlysis key Problems

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retailsalesanalysis
WHERE sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * from retailsalesanalysis
WHERE category='Clothing' and quantiy>=4
and year(sale_date)='2022'and month(sale_date)='11'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.;
select * from retailsalesanalysis;
select sum(total_sale)as net_sale,category,count(*)as total_order from retailsalesanalysis
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age)as Avg_age,category from retailsalesanalysis
where category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retailsalesanalysis;
select * from retailsalesanalysis
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(ï»¿transactions_id)as transactions,gender,category from retailsalesanalysis
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM(
select extract( month from sale_date)as month,
extract( year from sale_date)as year,
avg(total_sale)as Avg_sale,
 RANK() OVER (PARTITION BY extract( year from sale_date) ORDER BY avg(total_sale) DESC) AS rnk
 from retailsalesanalysis
group by year,month
order by year,month
)AS T1
WHERE rnk=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
;
select customer_id as customer,sum(total_sale) as total_sales from retailsalesanalysis
group by customer_id
order by total_sales desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as uniquecustomer,category from retailsalesanalysis
group by category
order by uniquecustomer;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale as
(
SELECT *,
CASE
    WHEN EXTRACT(hour FROM sale_time)<12 then'Morning'
    WHEN EXTRACT(hour FROM sale_time)between 12 and 17 then'Afternoon'
    else 'Evening'
end as shift
from retailsalesanalysis
)
select shift,count(*) as total_oder
from hourly_sale
group by shift
