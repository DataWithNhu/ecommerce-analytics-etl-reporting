-- ====================================================================
-- DATA QUALITY ASSURANCE SCRIPT
-- Purpose: Audit the processed data for Uniqueness, Integrity, and Logic
-- ====================================================================

-- 1. UNIQUENESS & PRIMARY KEY CHECKS
-- dim_user: user_id must be unique
SELECT user_id, COUNT(*) 
FROM `ecommerce-growth.raw_data.dim_user`
GROUP BY 1 HAVING COUNT(*) > 1;

-- order_item_mart: Composite PK (order + item + model) must be unique
SELECT order_id, item_id, model_id, COUNT(*) 
FROM `ecommerce-growth.raw_data.order_item_mart`
GROUP BY 1,2,3 HAVING COUNT(*) > 1;


-- 2. REFERENTIAL INTEGRITY 
-- Do all buyer_id in order_item_mart exist as a user_id in dim_user table?
SELECT fact.buyer_id
FROM `ecommerce-growth.raw_data.order_item_mart` fact
LEFT JOIN `ecommerce-growth.raw_data.dim_user` dim ON fact.buyer_id = dim.user_id
WHERE dim.user_id IS NULL AND fact.buyer_id IS NOT NULL;


-- 3. CATEGORICAL STANDARDIZATION
-- Checking for dirty strings in platform columns (e.g., 'App' vs 'app')
SELECT DISTINCT login_platform FROM `ecommerce-growth.raw_data.dwd_login_event`;
SELECT DISTINCT checkout_platform FROM `ecommerce-growth.raw_data.order_item_mart`;


-- 4. BUSINESS LOGIC CONSTRAINTS
-- Check 1: Negative GMV (Financial anomaly)
SELECT * FROM `ecommerce-growth.raw_data.order_item_mart` WHERE gmv_usd < 0;

-- Check 2: Chronological Integrity (Cancelled before Created?)
SELECT * FROM `ecommerce-growth.raw_data.order_item_mart` 
WHERE cancel_datetime < create_datetime;

-- Check 3: State Consistency (Cancelled orders shouldn't have a completion timestamp)
-- Assuming is_net_order = 0 means cancelled
SELECT * FROM `ecommerce-growth.raw_data.order_item_mart`
WHERE is_net_order = 0 AND complete_datetime IS NOT NULL;


-- 5. DATA COMPLETENESS (NULL SNAPSHOT)
SELECT 
    COUNT(*) AS total_rows,
    COUNTIF(buyer_id IS NULL) AS null_buyers,
    COUNTIF(gmv_usd IS NULL) AS null_gmv,
    COUNTIF(create_datetime IS NULL) AS null_dates,
    COUNTIF(default_delivery_address_city IS NULL) AS null_city 
FROM `ecommerce-growth.raw_data.order_item_mart` o
LEFT JOIN `ecommerce-growth.raw_data.dim_user` u ON o.buyer_id = u.user_id;
