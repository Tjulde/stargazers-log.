-- ======================================================================
-- THE BROKEN BASKET
-- SYNTHETIC NIGERIA INFLATION CONTEXT FOR PORTFOLIO ANALYSIS
-- ======================================================================
--
-- IMPORTANT:
-- These inflation figures are FABRICATED/SYNTHETIC values created only for
-- a portfolio case study. They are NOT official Nigerian inflation data.
--
-- Do NOT describe these numbers as NBS statistics.
--
-- The purpose is to create a controlled analytical scenario so that the
-- project can demonstrate:
--   Inflation/price pressure -> basket behavior -> product abandonment
--
-- Official Nigerian CPI uses a rebased framework with 2024 as the price
-- reference period. If you later want a factual version of this project,
-- replace this synthetic table with monthly NBS data.
-- ======================================================================

USE retail_broken_basket_db;

-- Add fields needed for the analytical scenario.
ALTER TABLE dim_inflation_context
    ADD COLUMN headline_inflation_rate DECIMAL(6,2) NULL AFTER inflation_source,
    ADD COLUMN food_price_index DECIMAL(8,2) NULL AFTER food_inflation_rate,
    ADD COLUMN headline_price_index DECIMAL(8,2) NULL AFTER food_price_index,
    ADD COLUMN price_pressure_level VARCHAR(20) NULL AFTER headline_price_index;

-- Remove any previous placeholder rows.
DELETE FROM dim_inflation_context;

-- ----------------------------------------------------------------------
-- SYNTHETIC MONTHLY INFLATION SCENARIO
-- Period: January 2025 - August 2026
--
-- The pattern is intentionally designed to represent a high-price-pressure
-- environment with changing food-price pressure. It is NOT a reconstruction
-- of official NBS data.
-- ----------------------------------------------------------------------

INSERT INTO dim_inflation_context
(
    month_start,
    inflation_source,
    headline_inflation_rate,
    food_inflation_rate,
    food_price_index,
    headline_price_index,
    price_pressure_level,
    note
)
VALUES
('2025-01-01','Synthetic portfolio scenario',28.40,34.20,100.00,100.00,'High',
 'Synthetic baseline; not official NBS data'),

('2025-02-01','Synthetic portfolio scenario',28.90,34.80,101.70,100.90,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-03-01','Synthetic portfolio scenario',29.40,35.60,103.50,101.80,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-04-01','Synthetic portfolio scenario',30.10,36.40,105.40,102.80,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-05-01','Synthetic portfolio scenario',30.80,37.10,107.40,103.90,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-06-01','Synthetic portfolio scenario',31.20,37.90,109.50,105.00,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-07-01','Synthetic portfolio scenario',31.80,38.60,111.70,106.10,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-08-01','Synthetic portfolio scenario',32.40,39.20,114.00,107.20,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-09-01','Synthetic portfolio scenario',33.00,39.90,116.40,108.30,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-10-01','Synthetic portfolio scenario',33.50,40.50,118.90,109.40,'High',
 'Synthetic scenario for portfolio analysis'),

('2025-11-01','Synthetic portfolio scenario',34.10,41.20,121.50,110.50,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2025-12-01','Synthetic portfolio scenario',34.70,42.00,124.20,111.70,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2026-01-01','Synthetic portfolio scenario',34.20,41.30,126.40,112.80,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2026-02-01','Synthetic portfolio scenario',33.80,40.70,128.50,113.80,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2026-03-01','Synthetic portfolio scenario',33.40,40.10,130.60,114.80,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2026-04-01','Synthetic portfolio scenario',33.00,39.50,132.70,115.80,'Very High',
 'Synthetic scenario for portfolio analysis'),

('2026-05-01','Synthetic portfolio scenario',32.70,38.90,134.80,116.80,'High',
 'Synthetic scenario for portfolio analysis'),

('2026-06-01','Synthetic portfolio scenario',32.40,38.30,136.90,117.80,'High',
 'Synthetic scenario for portfolio analysis'),

('2026-07-01','Synthetic portfolio scenario',32.10,37.80,139.00,118.80,'High',
 'Synthetic scenario for portfolio analysis'),

('2026-08-01','Synthetic portfolio scenario',31.80,37.30,141.00,119.80,'High',
 'Synthetic scenario for portfolio analysis');

-- ----------------------------------------------------------------------
-- BASIC VALIDATION
-- ----------------------------------------------------------------------

SELECT
    MIN(month_start) AS first_month,
    MAX(month_start) AS last_month,
    COUNT(*) AS months_loaded
FROM dim_inflation_context;

SELECT
    month_start,
    headline_inflation_rate,
    food_inflation_rate,
    food_price_index,
    headline_price_index,
    price_pressure_level
FROM dim_inflation_context
ORDER BY month_start;

-- ----------------------------------------------------------------------
-- QUERY 1: Join inflation context to monthly retail sales
-- ----------------------------------------------------------------------

SELECT
    d.month_start,
    ROUND(SUM(f.gross_revenue),2) AS total_revenue,
    COUNT(DISTINCT f.ticket_id) AS transactions,
    ROUND(SUM(f.quantity) / COUNT(DISTINCT f.ticket_id),2) AS items_per_basket,
    ROUND(SUM(f.gross_revenue) / COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value,
    i.headline_inflation_rate,
    i.food_inflation_rate,
    i.food_price_index
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
JOIN dim_inflation_context i
    ON d.month_start = i.month_start
GROUP BY
    d.month_start,
    i.headline_inflation_rate,
    i.food_inflation_rate,
    i.food_price_index
ORDER BY d.month_start;

-- ----------------------------------------------------------------------
-- QUERY 2: Calculate a synthetic "basket pressure" indicator
--
-- This is NOT an official economic indicator.
-- It is simply a portfolio metric combining:
--   food inflation + change in items per basket.
-- ----------------------------------------------------------------------

WITH monthly_basket AS
(
    SELECT
        d.month_start,
        ROUND(SUM(f.quantity) / COUNT(DISTINCT f.ticket_id),2) AS items_per_basket
    FROM fact_sales f
    JOIN dim_date d
        ON f.date_key = d.date_key
    GROUP BY d.month_start
)
SELECT
    b.month_start,
    b.items_per_basket,
    i.food_inflation_rate,
    ROUND(
        i.food_inflation_rate /
        NULLIF(b.items_per_basket,0),
        2
    ) AS synthetic_basket_pressure
FROM monthly_basket b
JOIN dim_inflation_context i
    ON b.month_start = i.month_start
ORDER BY b.month_start;

-- ----------------------------------------------------------------------
-- QUERY 3: Compare early vs later period
-- ----------------------------------------------------------------------

SELECT
    CASE
        WHEN d.month_start < '2026-01-01' THEN '2025'
        ELSE '2026'
    END AS analysis_period,
    ROUND(SUM(f.gross_revenue),2) AS total_revenue,
    COUNT(DISTINCT f.ticket_id) AS transactions,
    ROUND(SUM(f.quantity) / COUNT(DISTINCT f.ticket_id),2) AS items_per_basket,
    ROUND(SUM(f.gross_revenue) / COUNT(DISTINCT f.ticket_id),2) AS avg_basket_value,
    ROUND(AVG(i.food_inflation_rate),2) AS avg_food_inflation
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
JOIN dim_inflation_context i
    ON d.month_start = i.month_start
GROUP BY
    CASE
        WHEN d.month_start < '2026-01-01' THEN '2025'
        ELSE '2026'
    END
ORDER BY analysis_period;

-- ----------------------------------------------------------------------
-- PORTFOLIO NOTE
-- ----------------------------------------------------------------------
-- When publishing this project:
--
-- "Inflation context is synthetic and was created to simulate a Nigerian
-- high-price-pressure retail environment. Sales/customer data are also
-- synthetic. The project demonstrates analytical methodology rather than
-- reporting official Nigerian economic statistics."
-- ======================================================================
