-- percentage question extra 
select * from sales_transactions;
select * from products;

select payment_mode, count(payment_mode), round(count(payment_mode)/(select count(payment_mode) from sales_transactions)*100,2) as pct
from sales_transactions
group by payment_mode; 

select payment_mode, count(*) as txt, round(count(*)/sum(count(*)) over()*100,2) as pct
from sales_transactions
group by payment_mode
order by pct desc;

select store_city, sum(net_amount), round(sum(net_amount)/sum(sum(net_amount)) over()* 100,2) as pct from sales_transactions
group by store_city
order by pct desc; 

WITH pctt as (SELECT s.store_city, p.category, s.net_amount from products as p
               inner join sales_transactions as s
               on s.product_id = p.product_id), t1 as
               (select store_city, category, sum(net_amount), sum(net_amount)/sum(sum(net_amount)) over(partition by category) *100 as pct
               from pctt
               group by store_city, category) select * from t1;

SELECT p.category,
       p.product_name,
       SUM(s.net_amount) AS product_revenue,
       ROUND(SUM(s.net_amount) * 100
             / SUM(SUM(s.net_amount)) OVER (PARTITION BY p.category), 2) AS pct_in_category
FROM products AS p
INNER JOIN sales_transactions AS s
  ON p.product_id = s.product_id
GROUP BY p.category, p.product_id, p.product_name
ORDER BY p.category, pct_in_category DESC;

WITH ctt AS (
SELECT store_city,quantity*unit_Price as each_price, discount_amount from sales_transactions)
select store_city,sum(discount_amount)/sum(each_price) *100 as pct from ctt
group by store_city;









