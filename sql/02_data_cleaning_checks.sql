/*
========================================================================================
Retail Market Basket Intelligence: Phase 2 - Data Cleaning & Quality Validation
========================================================================================
Author: Karthik Yelugam | Data Analyst

Environment Note: 
Executed in a restricted, read-only production environment. 
This script performs rigorous pre- and post-cleaning validation checks using standard SELECT operations and derived subqueries. No DDL/DML operations are executed.

Key Operations:
1. Missing Value Validation
2. Duplicate Record Identification
3. Logical Anomaly Detection (Quantities & Prices)
4. Text & Formatting Standardization Checks
5. Date Format Validation
6. Rare Product Frequency Filtering
7. Comprehensive Data Quality Summary
========================================================================================
*/

-- =====================================================================================
-- 1. MISSING VALUE VALIDATION
-- =====================================================================================

-- 1.1: Comprehensive Missing Value Summary
-- Identifies critical gaps in transaction features (Itemname) and shopper tracking (CustomerID)
SELECT
    SUM(CASE WHEN Itemname IS NULL OR Itemname = '' THEN 1 ELSE 0 END) AS missing_itemnames,
    SUM(CASE WHEN CustomerID IS NULL OR CustomerID = '' THEN 1 ELSE 0 END) AS missing_customerids
FROM mytable;


-- =====================================================================================
-- 2. DUPLICATE RECORD IDENTIFICATION
-- =====================================================================================

-- 2.1: Exact Duplicate Row Count
-- Utilizing a derived subquery to isolate rows that are completely identical, 
-- which would falsely inflate support and confidence metrics in the Apriori algorithm.
SELECT SUM(occurrence_count - 1) AS total_duplicate_rows 
FROM (
    SELECT COUNT(*) as occurrence_count
    FROM mytable
    GROUP BY BillNo, Itemname, Quantity, Present_Date, Price, CustomerID, Country
    HAVING COUNT(*) > 1
) AS DuplicateRecords;


-- =====================================================================================
-- 3. LOGICAL ANOMALY DETECTION (QUANTITIES & PRICES)
-- =====================================================================================

-- 3.1: Invalid or Cancelled Quantities
-- Identifies records with zero or negative quantities (returns or errors).
-- These must be filtered out as returns do not represent basket co-occurrence.
SELECT COUNT(*) AS invalid_quantities
FROM mytable
WHERE Quantity <= 0;

-- 3.2: Invalid Pricing
-- Identifies records where the unit price is zero or negative (adjustments/freebies).
SELECT COUNT(*) AS invalid_prices
FROM mytable
WHERE Price <= 0;


-- =====================================================================================
-- 4. TEXT & FORMATTING STANDARDIZATION CHECKS
-- =====================================================================================

-- 4.1: Unformatted Country Names
-- Checks for leading or trailing whitespace that could disrupt geographic grouping.
SELECT COUNT(*) AS unformatted_country_names
FROM mytable
WHERE Country <> TRIM(Country);


-- =====================================================================================
-- 5. DATE FORMAT VALIDATION
-- =====================================================================================

-- 5.1: String-to-Date Conversion Test
-- Verifies that the raw Present_Date string can be successfully parsed into a standard 
-- datetime format without generating NULL outputs (using a sample of 10 rows).
SELECT 
    Present_Date AS raw_date_string,
    STR_TO_DATE(Present_Date, '%d-%m-%Y %H:%i') AS parsed_datetime
FROM mytable
LIMIT 10;


-- =====================================================================================
-- 6. RARE PRODUCT FREQUENCY FILTERING
-- =====================================================================================

-- 6.1: Identify Products with Low Purchase Frequency
-- For Market Basket Analysis, ultra-rare products create noise and weak association rules.
-- This query identifies how many products were purchased fewer than 100 times.
SELECT COUNT(*) AS rare_products_count
FROM (
    SELECT Itemname, COUNT(*) AS purchase_count
    FROM mytable
    WHERE Itemname != '' AND Itemname IS NOT NULL
    GROUP BY Itemname
    HAVING COUNT(*) < 100
) AS ProductFrequencies;

-- 6.2: Preview Top Frequently Purchased Products
-- Validates the items that will form the strongest foundations for the Apriori matrix.
SELECT Itemname, COUNT(*) AS purchase_count
FROM mytable
WHERE Itemname != '' AND Itemname IS NOT NULL
GROUP BY Itemname
ORDER BY purchase_count DESC
LIMIT 10;


-- =====================================================================================
-- 7. COMPREHENSIVE DATA QUALITY SUMMARY
-- =====================================================================================

-- 7.1: Final Pre-Cleaning Overview
-- A single macro-level view of dataset health before Python transformation pipelines begin.
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Itemname IS NULL OR Itemname = '' THEN 1 ELSE 0 END) AS missing_itemnames,
    SUM(CASE WHEN CustomerID IS NULL OR CustomerID = '' THEN 1 ELSE 0 END) AS missing_customerids,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantities,
    SUM(CASE WHEN Price <= 0 THEN 1 ELSE 0 END) AS invalid_prices
FROM mytable;