/*
===============================================================================
DDL Script: Create processed Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'processed' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of raw Tables
===============================================================================
*/

-- ============================================================================
-- 1. processed_DIM_USER
-- Transformation: Standardized gender from numeric code (1.0 or 2.0) to descriptive labels (Male or Female)
-- Extracted DATE format from TIMESTAMP columns
-- ============================================================================

CREATE OR REPLACE TABLE `ecommerce-growth.processed_data.dim_user` AS (
  SELECT 
      user_id,
      user_name,
      CASE 
        WHEN CAST(gender AS STRING) = '1' THEN 'Female'
        WHEN CAST(gender AS STRING) = '2' THEN 'Male'
        ELSE 'Unknown'
      END AS gender,
      birthday,
      last_login_datetime,
      DATE(last_login_datetime) AS last_login_date,
      registration_datetime,
      DATE(registration_datetime) AS registration_date,
      default_delivery_address_state,
      default_delivery_address_city
  FROM `ecommerce-growth.raw_data.raw_dim_user`
); 


-- ============================================================================
-- 2. processed_LOGIN_EVENT
-- Transformation: Converted 'grass_date' (bigint) into proper DATE format 
-- Standardized login_datetime.
-- ============================================================================

CREATE OR REPLACE TABLE `ecommerce-growth.processed_data.dwd_login_event` AS (
  SELECT
    user_id,
    -- Standardizing date formats for easier time-series analysis
    PARSE_DATE('%Y%m%d', CAST(grass_date AS STRING)) AS grass_date,
    DATE(login_datetime) AS login_date, 
    login_platform
  FROM `ecommerce-growth.raw_data.dwd_login_event`
  WHERE user_id IS NOT NULL 
  QUALIFY ROW_NUMBER() OVER(
    PARTITION BY user_id, DATE(login_datetime) 
    ORDER BY grass_date DESC
  ) = 1
);


-- ============================================================================
-- 3. processed_ORDER_ITEM_MART
-- Transformation: Translated multiple Integer flags (is_web_checkout, 
-- is_official_shop, etc.) into descriptive categorical strings
-- ============================================================================

CREATE OR REPLACE TABLE `ecommerce-growth.processed_data.order_item_mart` AS (
  SELECT
    order_id,
    item_id,
    model_id,
    buyer_id,
    checkout_channel AS checkout_platform,

    CASE 
      WHEN CAST(is_web_checkout AS STRING) = '1' THEN 'Web Checkout'
      WHEN CAST(is_web_checkout AS STRING) = '0' THEN 'Non-Web Checkout'
      ELSE 'Unknown'
    END AS is_web_checkout,

    DATE(create_datetime) AS create_date,
    DATE(complete_datetime) AS complete_date,
    DATE(release_datetime) AS release_date,
    DATE(cancel_datetime) AS cancel_date,

    CASE
      WHEN CAST(is_net_order AS STRING) = '1' THEN 'successful'
      WHEN CAST(is_net_order AS STRING) = '0' THEN 'cancelled'
      ELSE 'Unknown'
    END AS is_net_order,
    
    shop_id,
    shop_name,

    CASE
      WHEN CAST(is_official_shop AS STRING) = '1' THEN 'official'
      WHEN CAST(is_official_shop AS STRING) = '0' THEN 'unofficial'
      ELSE 'Unknown'
    END AS is_official_shop,

    CASE
      WHEN CAST(is_cb_shop AS STRING) = '1' THEN 'cross-border'
      WHEN CAST(is_cb_shop AS STRING) = '0' THEN 'non cross-border'
      ELSE 'Unknown'
    END AS is_cb_shop,

    seller_id,
    seller_name,
    seller_shipping_address_state,
    seller_shipping_address_city,
    buyer_shipping_address_state,
    buyer_shipping_address_city,
    gmv_usd,
    item_amount,
    main_category,
    estimate_shipping_fee_usd,
    buyer_paid_shipping_fee_usd,
    estimate_shipping_rebate_amt_usd,
    voucher_rebate_usd,
    fsv_promotion_id,
    pv_promotion_id
  FROM `ecommerce-growth.raw_data.order_item_mart`
); 
-- ============================================================================
-- 2. processed_LOGIN_EVENT
-- Transformation: Converted 'grass_date' (bigint) into proper DATE format 
-- Standardized login_datetime.
-- ============================================================================

CREATE OR REPLACE TABLE `ecommerce-growth.processed_data.dwd_login_event` AS (
  SELECT
    user_id,
    -- Standardizing date formats for easier time-series analysis
    PARSE_DATE('%Y%m%d', CAST(grass_date AS STRING)) AS grass_date,
    DATE(login_datetime) AS login_date, -- Renamed to login_date for clarity
    login_platform
  FROM `ecommerce-growth.raw_data.dwd_login_event`
  WHERE user_id IS NOT NULL 
  QUALIFY ROW_NUMBER() OVER(
    PARTITION BY user_id, DATE(login_datetime) 
    ORDER BY grass_date DESC
  ) = 1
);


-- ============================================================================
-- 3. processed_ORDER_ITEM_MART
-- Transformation: Translated multiple Integer flags (is_web_checkout, 
-- is_official_shop, etc.) into descriptive categorical strings
-- ============================================================================

CREATE OR REPLACE TABLE `ecommerce-growth.processed_data.order_item_mart` AS (
  SELECT
    order_id,
    item_id,
    model_id,
    buyer_id,
    checkout_channel AS checkout_platform,

    CASE 
      WHEN CAST(is_web_checkout AS STRING) = '1' THEN 'Web Checkout'
      WHEN CAST(is_web_checkout AS STRING) = '0' THEN 'Non-Web Checkout'
      ELSE 'Unknown'
    END AS is_web_checkout,

    DATE(create_datetime) AS create_datetime,
    DATE(complete_datetime) AS complete_datetime,
    DATE(release_datetime) AS release_datetime,
    DATE(cancel_datetime) AS cancel_datetime,

    CASE
      WHEN CAST(is_net_order AS STRING) = '1' THEN 'successful'
      WHEN CAST(is_net_order AS STRING) = '0' THEN 'cancelled'
      ELSE 'Unknown'
    END AS is_net_order,
    
    shop_id,
    shop_name,

    CASE
      WHEN CAST(is_official_shop AS STRING) = '1' THEN 'official'
      WHEN CAST(is_official_shop AS STRING) = '0' THEN 'unofficial'
      ELSE 'Unknown'
    END AS is_official_shop,

    CASE
      WHEN CAST(is_cb_shop AS STRING) = '1' THEN 'cross-border'
      WHEN CAST(is_cb_shop AS STRING) = '0' THEN 'non cross-border'
      ELSE 'Unknown'
    END AS is_cb_shop,

    seller_id,
    seller_name,
    seller_shipping_address_state,
    seller_shipping_address_city,
    buyer_shipping_address_state,
    buyer_shipping_address_city,
    gmv_usd,
    item_amount,
    main_category,
    estimate_shipping_fee_usd,
    buyer_paid_shipping_fee_usd,
    estimate_shipping_rebate_amt_usd,
    voucher_rebate_usd,
    fsv_promotion_id,
    pv_promotion_id
  FROM `ecommerce-growth.raw_data.order_item_mart`
); 
