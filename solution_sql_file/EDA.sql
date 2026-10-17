-- Beginner 

USE urbanmart_retail;
SELECT * FROM products;
SELECT * FROM sales_transactions;

-- 1.List all products that belong to the 'Electronics' category.
SELECT * FROM products 
WHERE category = 'Electronics';

-- 2 Display all transactions made using the 'UPI' payment mode.
SELECT * FROM sales_transactions
WHERE payment_mode = 'UPI';

-- 3 Find the distinct list of cities where UrbanMart has store locations (store_city).
SELECT DISTINCT store_city FROM sales_transactions;

-- 4 List all products priced above ₹2,000, sorted by selling_price in descending order.
SELECT * FROM products 
where selling_price>2000
ORDER BY selling_price DESC;

-- 5 Find all transactions where the discount given was greater than 15%.
SELECT * FROM sales_transactions
WHERE discount_amount>15;

-- 6 Display the product name, brand and category for products supplied from 'Pune'.
SELECT product_name, brand, category FROM products
WHERE supplier_city = 'Pune';

-- 7 Count the total number of transactions recorded in the sales_transactions table.
SELECT COUNT(*) AS total_transactions FROM sales_transactions;










