-- Advanced
SELECT * FROM products;
SELECT * FROM sales_transactions;

-- 1. Rank products within each category by total revenue generated, using a window function (RANK() or DENSE_RANK()).
SELECT category, p.product_name, SUM(net_amount), RANK() OVER(PARTITION BY p.category ORDER BY SUM(net_amount) desc) AS rnk FROM products AS p
INNER JOIN sales_transactions AS s 
ON s.product_id = p.product_id
GROUP BY category, p.product_name;

SELECT category, product_name, total_revenue, unity_sold
FROM (
	  SELECT p.category, p.product_name, sum(s.net_amount) AS total_revenue, sum(s.quantity) as unity_sold, dense_rank() over(partition by category ORDER BY sum(net_amount)) AS rnk
      FROM products AS p
      INNER JOIN sales_transactions AS s
      ON p.product_id = s.product_id
      GROUP BY p.category,p.product_name) AS ranked
WHERE rnk = 1;
-- 2 Using a CTE and ROW_NUMBER(), find the top-selling product (by quantity) in each store city.
select * from sales_transactions;
select * from products;

WITH top_selling AS
(SELECT s.store_city, p.product_name,p.product_id, SUM(S.quantity) AS total_qunatity, SUM(s.net_amount) as total_revenue FROM products as p 
INNER JOIN sales_transactions AS s 
ON p.product_id = s.product_id
GROUP BY s.store_city, p.product_name,p.product_id), ranked as
(SELECT *, rank() OVER(PARTITION BY store_city order by total_qunatity desc, total_revenue desc) AS rn from top_selling)
SELECT store_city,product_name , total_qunatity FROM RANKED WHERE rn <= 3
order by total_qunatity desc;

-- 3 Calculate the running (cumulative) monthly revenue for 2025 using a window function.
WITH running AS (SELECT sale_date, sum(net_amount) over(partition by month(sale_date) order by month(sale_date)) as total_revenue from sales_transactions where year(sale_date) = 2025)
SELECT Month(sale_date), total_revenue FROM running;

SELECT Month(sale_date),sum(net_amount) FROM sales_transactions WHERE YEAR(sale_date) = 2025
GROUP BY MONTH(sale_date)
order by month(sale_date);

WITH RUNNING AS (SELECT Month(sale_date) AS M,sum(net_amount) AS total FROM sales_transactions WHERE YEAR(sale_date) = 2025
GROUP BY MONTH(sale_date)), filter_m as 
(SELECT *, SUM(total) over(order by M) FROM RUNNING)
(SELECT * FROM FILTER_M);

-- 4 Identify customers whose total spend is higher than the average total spend across all customers (correlated/uncorrelated subquery).
SELECT customer_id, sum(net_amount) FROM sales_transactions
group by customer_id;

WITH customer_totals AS (
    SELECT customer_id, SUM(net_amount) AS total_spend
    FROM sales_transactions
    GROUP BY customer_id
)
SELECT COUNT(*) AS customers_above_avg,
       ROUND(SUM(total_spend) * 100 / (SELECT SUM(total_spend) FROM customer_totals), 2) AS combined_pct
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals);

-- Identify customers whose total spend is higher than the average total spend of customers in their own city.
select s1.customer_id, s1.customer_name,s1.customer_city, SUM(s1.net_amount) FROM sales_transactions as s1
group by s1.customer_id, s1.customer_name, s1.customer_city
having sum(s1.net_amount)>(select sum(s2.net_amount)/count(distinct s2.customer_id)
                           from sales_transactions as s2
                           where s2.customer_city = s1.customer_city);
                           
-- 5 Calculate month-over-month revenue growth percentage using LAG().
select distinct year(sale_date) from sales_transactions;
with grow_pct as(
SELECT MONTH(SALE_DATE) as months, sum(net_amount) as revenue FROM sales_transactions
group by month(sale_date)
order by month(sale_date))
select *,lag(revenue) over(order by months) as previous_sale, round((revenue-lag(revenue) over(order by months))*100/lag(revenue) over(order by months),2) as pct
from grow_pct;

-- 6. Identify products where current stock_quantity is below reorder_level, 
-- and rank them by restock priority based on how frequently they have sold (join products with an aggregated sales subquery).
SELECT * FROM sales_transactions;
SELECT * FROM products;

select product_id, count(*) from sales_transactions
group by product_id;	

SELECT s.product_id, s.product_name, s.category, s.stock_quantity, s.reorder_level, s.reorder_level -s.stock_quantity as shortfall, coalesce(time_sold,0)as time_sold,
rank() over(order by time_sold desc, s.reorder_level - s.stock_quantity desc) as ranks
FROM products	as s
left join (select product_id, count(*) as time_sold from sales_transactions
group by product_id) as p
on s.product_id = p.product_id
where s.stock_quantity<s.reorder_level
order by ranks;

-- 7 Segment customers into 'High', 'Medium' and 'Low' value tiers based on total spend using CASE combined with aggregation, then count customers per tier.
with count_amount as (
SELECT customer_id,customer_name, sum(net_amount) as total_spend,
                                  case when sum(net_amount)>60000 then 'high'
                                  when sum(net_amount) between 30000 and 60000 then 'medium'
                                  else 'low' end tier
from sales_transactions
group by customer_id, customer_name)
                select tier,sum(total_spend), count(*), round(sum(total_spend)*100/(select sum(total_spend) from count_amount),2) as pct from count_amount
                group by tier;
                
-- 8.Compare average monthly revenue during the festive period (October–December) against the rest of the year, for each store city.
select month(sale_date), avg(net_amount) from sales_transactions
WHERE MONTH(sale_date) between 10 and 12
group by month(sale_date)
order by month(sale_date);

with month_f as (
select store_city, month(sale_date), sum(net_amount) as revenue,case when month(sale_date) between 10 and 12 then'Festival' else 'rest of year' end as divid_month
from sales_transactions
group by store_city, month(sale_date), divid_month) select store_city, divid_month, avg(revenue) from month_f
group by store_city, divid_month;

-- Write a query using a CTE that returns, for every category, the best-selling month of the year by revenue.
with best_sale_m as (
SELECT month(s.sale_date) as months, p.category, sum(s.net_amount) as revenue
from sales_transactions as s
INNER JOIN products as p
ON p.product_id = s.product_id
group by month(s.sale_date), p.category
order by month(s.sale_date)) select category,max(revenue) from best_sale_m
							 group by category; 































