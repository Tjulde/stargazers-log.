-- ======================================================================
-- THE BROKEN BASKET: NIGERIAN RETAIL SALES ANALYTICS
-- MySQL Star Schema - Expanded Portfolio Dataset
-- IMPORTANT: Sales/customer data are synthetic portfolio data.
-- They are NOT official Nigerian retail statistics.
-- Date range: 2025-01-01 through 2026-08-31
-- ======================================================================
CREATE DATABASE IF NOT EXISTS retail_broken_basket_db;
USE retail_broken_basket_db;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_inflation_context;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS dim_stores;
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_date;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE dim_stores (
    store_key INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL UNIQUE,
    supermarket_name VARCHAR(100) NOT NULL,
    retail_model VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    location_type VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dim_products (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    tier ENUM('Premium','Essential') NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    base_cost DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dim_customers (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    gender VARCHAR(10) NOT NULL,
    income_bracket VARCHAR(20) NOT NULL,
    loyalty_status VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    is_weekend VARCHAR(3) NOT NULL,
    month_start DATE NOT NULL
) ENGINE=InnoDB;

-- This is deliberately a separate table so official NBS CPI/food inflation
-- data can be loaded later. The project should not invent official inflation data.
CREATE TABLE dim_inflation_context (
    month_start DATE PRIMARY KEY,
    inflation_source VARCHAR(100) NOT NULL,
    food_inflation_rate DECIMAL(6,2) NULL,
    note VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE fact_sales (
    sale_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ticket_id VARCHAR(50) NOT NULL,
    date_key DATE NOT NULL,
    store_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    gross_revenue DECIMAL(14,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    cost_of_goods_sold DECIMAL(14,2) GENERATED ALWAYS AS (quantity * cost_price) STORED,
    gross_profit DECIMAL(14,2) GENERATED ALWAYS AS ((quantity * unit_price) - (quantity * cost_price)) STORED,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_key) REFERENCES dim_stores(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key),
    INDEX idx_ticket (ticket_id),
    INDEX idx_date_store (date_key, store_key),
    INDEX idx_customer_date (customer_key, date_key),
    INDEX idx_product_date (product_key, date_key)
) ENGINE=InnoDB;
