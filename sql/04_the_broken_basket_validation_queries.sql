USE retail_broken_basket_db;

-- ======================================================================
-- STEP 1 VALIDATION & BASELINE ANALYSIS
-- ======================================================================

-- 1. Row counts
SELECT 'Stores' AS table_name, COUNT(*) AS row_count FROM dim_stores
UNION ALL SELECT 'Products', COUNT(*) FROM dim_products
UNION ALL SELECT 'Customers', COUNT(*) FROM dim_customers
UNION ALL SELECT 'Dates', COUNT(*) FROM dim_date
UNION ALL SELECT 'Sales Lines', COUNT(*) FROM fact_sales;

-- 2. Date coverage
SELECT MIN(date_key) AS first_sale_date, MAX(date_key) AS last_sale_date,
       COUNT(DISTINCT date_key) AS selling_days, COUNT(DISTINCT ticket_id) AS tickets
FROM fact_sales;

-- 3. Referential integrity checks
SELECT COUNT(*) AS orphan_dates FROM fact_sales f LEFT JOIN dim_date d ON f.date_key=d.date_key WHERE d.date_key IS NULL;
SELECT COUNT(*) AS orphan_stores FROM fact_sales f LEFT JOIN dim_stores s ON f.store_key=s.store_key WHERE s.store_key IS NULL;
SELECT COUNT(*) AS orphan_products FROM fact_sales f LEFT JOIN dim_products p ON f.product_key=p.product_key WHERE p.product_key IS NULL;
SELECT COUNT(*) AS orphan_customers FROM fact_sales f LEFT JOIN dim_customers c ON f.customer_key=c.customer_key WHERE c.customer_key IS NULL;

-- 4. Executive sales baseline
SELECT
    ROUND(SUM(gross_revenue),2) AS total_revenue,
    ROUND(SUM(gross_profit),2) AS gross_profit,
    COUNT(DISTINCT ticket_id) AS total_tickets,
    SUM(quantity) AS total_units,
    ROUND(SUM(gross_revenue)/COUNT(DISTINCT ticket_id),2) AS avg_basket_value,
    ROUND(SUM(quantity)/COUNT(DISTINCT ticket_id),2) AS avg_items_per_basket
FROM fact_sales;

-- 5. Retailer comparison
SELECT s.supermarket_name, s.state,
       COUNT(DISTINCT f.ticket_id) AS tickets,
       SUM(f.quantity) AS units,
       ROUND(SUM(f.gross_revenue),2) AS revenue,
       ROUND(SUM(f.gross_revenue)/COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value,
       ROUND(SUM(f.quantity)/COUNT(DISTINCT f.ticket_id),2) AS avg_items_per_basket,
       ROUND(SUM(f.gross_profit)/SUM(f.gross_revenue)*100,2) AS gross_margin_pct
FROM fact_sales f JOIN dim_stores s ON f.store_key=s.store_key
GROUP BY s.supermarket_name, s.state
ORDER BY revenue DESC;

-- 6. Monthly basket trend
SELECT d.year, d.month, d.month_name,
       COUNT(DISTINCT f.ticket_id) AS tickets,
       SUM(f.quantity) AS units,
       ROUND(SUM(f.gross_revenue),2) AS revenue,
       ROUND(SUM(f.quantity)/COUNT(DISTINCT f.ticket_id),2) AS avg_items_per_basket,
       ROUND(SUM(f.gross_revenue)/COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value
FROM fact_sales f JOIN dim_date d ON f.date_key=d.date_key
GROUP BY d.year,d.month,d.month_name
ORDER BY d.year,d.month;

-- 7. Product/category basket penetration
WITH basket_counts AS (SELECT COUNT(DISTINCT ticket_id) AS total_tickets FROM fact_sales)
SELECT p.category, p.product_name,
       COUNT(DISTINCT f.ticket_id) AS baskets_with_product,
       ROUND(COUNT(DISTINCT f.ticket_id)/(SELECT total_tickets FROM basket_counts)*100,2) AS basket_penetration_pct,
       SUM(f.quantity) AS units, ROUND(SUM(f.gross_revenue),2) AS revenue
FROM fact_sales f JOIN dim_products p ON f.product_key=p.product_key
GROUP BY p.category,p.product_name
ORDER BY basket_penetration_pct DESC;

-- 8. Income/loyalty behavior
SELECT c.income_bracket, c.loyalty_status,
       COUNT(DISTINCT f.ticket_id) AS tickets,
       COUNT(DISTINCT f.customer_key) AS active_customers,
       ROUND(SUM(f.quantity)/COUNT(DISTINCT f.ticket_id),2) AS avg_items_per_basket,
       ROUND(SUM(f.gross_revenue)/COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value
FROM fact_sales f JOIN dim_customers c ON f.customer_key=c.customer_key
GROUP BY c.income_bracket,c.loyalty_status
ORDER BY c.income_bracket,c.loyalty_status;

-- 9. Weekend vs weekday behavior
SELECT d.is_weekend,
       COUNT(DISTINCT f.ticket_id) AS tickets,
       ROUND(SUM(f.quantity)/COUNT(DISTINCT f.ticket_id),2) AS avg_items_per_basket,
       ROUND(SUM(f.gross_revenue)/COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value
FROM fact_sales f JOIN dim_date d ON f.date_key=d.date_key
GROUP BY d.is_weekend;

-- 10. Retailer-specific diagnostic indicators
SELECT s.supermarket_name,
       ROUND(AVG(CASE WHEN p.category='Restaurant/Ready-Meals' THEN 1 ELSE 0 END)*100,2) AS ready_meal_line_share,
       ROUND(AVG(CASE WHEN p.category='Local Fresh Food' THEN 1 ELSE 0 END)*100,2) AS fresh_food_line_share,
       ROUND(SUM(CASE WHEN d.is_weekend='Yes' THEN f.gross_revenue ELSE 0 END)/SUM(f.gross_revenue)*100,2) AS weekend_revenue_share
FROM fact_sales f
JOIN dim_stores s ON f.store_key=s.store_key
JOIN dim_products p ON f.product_key=p.product_key
JOIN dim_date d ON f.date_key=d.date_key
GROUP BY s.supermarket_name;

-- NOTE: Do not claim inflation causality yet. Load official NBS inflation data into
-- dim_inflation_context before combining macroeconomic inflation with sales behavior.
