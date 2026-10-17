-- =====================================================================
-- URBANMART RETAIL ANALYTICS PROJECT
-- Schema creation + CSV load script (MySQL Workbench)
-- Prepared by: Aishwarya Mate
-- =====================================================================

DROP DATABASE IF EXISTS urbanmart_retail;
CREATE DATABASE urbanmart_retail;
USE urbanmart_retail;

-- ---------------------------------------------------------------------
-- 1. PRODUCTS TABLE
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id       VARCHAR(10)     PRIMARY KEY,
    product_name     VARCHAR(100)    NOT NULL,
    category         VARCHAR(50)     NOT NULL,
    brand            VARCHAR(50),
    cost_price       DECIMAL(10,2)   NOT NULL,
    selling_price    DECIMAL(10,2)   NOT NULL,
    stock_quantity   INT             NOT NULL,
    reorder_level    INT             NOT NULL,
    supplier_city    VARCHAR(50)
);

-- ---------------------------------------------------------------------
-- 2. SALES_TRANSACTIONS TABLE
-- ---------------------------------------------------------------------
CREATE TABLE sales_transactions (
    transaction_id   VARCHAR(10)     PRIMARY KEY,
    sale_date        DATE            NOT NULL,
    customer_id      VARCHAR(10)     NOT NULL,
    customer_name    VARCHAR(100)    NOT NULL,
    customer_city    VARCHAR(50),
    product_id       VARCHAR(10)     NOT NULL,
    store_city       VARCHAR(50),
    store_location    VARCHAR(50),
    quantity         INT             NOT NULL,
    unit_price       DECIMAL(10,2)   NOT NULL,
    discount_pct     INT             DEFAULT 0,
    discount_amount  DECIMAL(10,2)   DEFAULT 0,
    net_amount       DECIMAL(10,2)   NOT NULL,
    payment_mode     VARCHAR(20),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Helpful indexes for the analysis tasks
CREATE INDEX idx_sales_date ON sales_transactions(sale_date);
CREATE INDEX idx_sales_customer ON sales_transactions(customer_id);
CREATE INDEX idx_sales_store ON sales_transactions(store_city);

-- =====================================================================
-- LOADING THE CSV FILES (choose ONE method)
-- =====================================================================

-- ---------------------------------------------------------------------
-- METHOD A (Recommended for students): Table Data Import Wizard
-- In MySQL Workbench:
--   1. Run the CREATE TABLE statements above first (or let the wizard
--      create the table for you, then verify data types).
--   2. Navigator panel -> right-click "urbanmart_retail" -> Table Data
--      Import Wizard.
--   3. Browse to products.csv -> Next -> choose "Use existing table:
--      products" -> map columns (they match automatically since the
--      CSV headers equal the column names) -> Next -> Finish.
--   4. Repeat the wizard for sales_transactions.csv -> existing table
--      "sales_transactions".
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- METHOD B: LOAD DATA INFILE (faster, needs local_infile enabled and
-- file placed in MySQL's secure-file-priv directory, or use LOAD DATA
-- LOCAL INFILE from the file's actual path on your machine)
-- ---------------------------------------------------------------------

-- SET GLOBAL local_infile = 1;

-- LOAD DATA LOCAL INFILE 'products.csv'
-- INTO TABLE products
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS
-- (product_id, product_name, category, brand, cost_price, selling_price,
--  stock_quantity, reorder_level, supplier_city);

-- LOAD DATA LOCAL INFILE 'sales_transactions.csv'
-- INTO TABLE sales_transactions
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS
-- (transaction_id, sale_date, customer_id, customer_name, customer_city,
--  product_id, store_city, store_location, quantity, unit_price,
--  discount_pct, discount_amount, net_amount, payment_mode);

-- =====================================================================
-- QUICK VALIDATION AFTER LOADING
-- =====================================================================
-- SELECT COUNT(*) AS product_count FROM products;                 -- expect 90
-- SELECT COUNT(*) AS transaction_count FROM sales_transactions;    -- expect 6000
-- SELECT MIN(sale_date), MAX(sale_date) FROM sales_transactions;  -- expect 2025-01-01 to 2025-12-28
