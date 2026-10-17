# urbanmart-retail-sql-analysis
SQL analysis of a retail dataset: 6,000 transactions, 90 products, 9 cities (MySQL)
# UrbanMart Retail Sales Analysis (MySQL)

SQL analysis of one year (Jan–Dec 2025) of sales for a fictional Indian retail chain.
This is a practice case study, not real company data.

## Dataset
- `products`: 90 products in 6 categories
- `sales_transactions`: 6,000 transactions, 350 customers, 9 store cities

## Skills used
JOINs, GROUP BY / HAVING, correlated and uncorrelated subqueries, CTEs,
window functions (RANK, ROW_NUMBER, LAG, running totals), CASE segmentation.

## Key findings
- Revenue is ₹1.75 crore. Electronics (33.9%) and Fashion (25.5%) bring 59% of it.
- December is the peak month (14.3% of revenue) and October–December brings 35.4% of the year.
- Average monthly revenue rises 64.5% in the festive months, and every city gains.
- Customers are spread widely: the top 5 bring only 3% of revenue, and 166 of 350 customers spend above average.
- Only one product, Besan 1kg, is below its reorder level.

## Files
- `sql/schema_and_load.sql`: creates the database and tables
- `sql/01...04`: queries by level (beginner, intermediate, advanced, percentage)
- `report/UrbanMart_Insight_Report.pdf`: full findings and recommendations

## How to run
1. Run `sql/schema_and_load.sql` in MySQL Workbench.
2. Load the two CSV files from `data/` with the Table Data Import Wizard.
3. Run the query files in order.

Author: Punam Vijay Dupade
