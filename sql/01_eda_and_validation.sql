/*
========================================================================================
Retail Market Basket Intelligence: Phase 1 - Exploratory Data Analysis & Validation
========================================================================================
Author: Karthik Yelugam | Data Analyst

Environment Note: 
Executed in a restricted, read-only production environment.
All data exploration, profiling, and validation are performed using standard SELECT operations and derived subqueries. No DDL/DML operations are executed.

Key Operations:
1. Database Context & Column Structure Understanding
2. Structural Profiling (Volume & Entity counts)
3. Data Quality & Anomaly Detection
4. Statistical Summaries
5. Behavioral & Geographic Profiling
========================================================================================
*/

-- =====================================================================================
-- 1. DATABASE CONTEXT & COLUMN STRUCTURE UNDERSTANDING
-- =====================================================================================

-- Conceptual Schema Overview:
-- The dataset contains 7 columns representing transactional retail data:
-- BillNo (Transaction ID), Itemname (Product), Quantity, Present_Date (Timestamp), 
-- Price (Unit Price), CustomerID (Shopper ID), Country (Geographic Location).

-- Retrieve a structural sample to understand data types, formats, and initial quality
SELECT * FROM mytable 
LIMIT 10;

-- Extract table metadata to verify schema structure (if INFORMATION_SCHEMA is accessible)
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'mytable';


-- =====================================================================================
-- 2. STRUCTURAL PROFILING & DATASET OVERVIEW
-- =====================================================================================

-- Verify the total scale of the raw dataset
SELECT COUNT(*) AS total_raw_records 
FROM mytable;

-- Assess the cardinality of distinct entities within the transaction matrix
SELECT 
    COUNT(DISTINCT BillNo) AS unique_transactions,
    COUNT(DISTINCT Itemname) AS unique_products,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT Country) AS unique_countries
FROM mytable;


-- =====================================================================================
-- 3. DATA QUALITY & ANOMALY DETECTION
-- =====================================================================================

-- 3.1: Hidden Missing Values Detection
-- Note: EDA reveals missing values are often stored as empty strings ('') rather than NULLs.
SELECT 
    SUM(CASE WHEN CustomerID = '' OR CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_customer_ids,
    SUM(CASE WHEN Itemname = '' OR Itemname IS NULL THEN 1 ELSE 0 END) AS missing_item_names
FROM mytable;

-- 3.2: Exact Duplicate Records Validation
-- Utilizing a derived subquery to isolate and count rows that are identical across all dimensions.
SELECT SUM(occurrence_count - 1) AS total_duplicate_rows 
FROM (
    SELECT 
        COUNT(*) as occurrence_count
    FROM mytable
    GROUP BY BillNo, Itemname, Quantity, Present_Date, Price, CustomerID, Country
    HAVING COUNT(*) > 1
) AS DuplicateRecords;

-- 3.3: Logical Anomalies - Negative Quantities
-- Identifies transactions representing product returns, cancellations, or system errors.
SELECT COUNT(*) AS negative_quantity_count
FROM mytable
WHERE Quantity <= 0;

-- 3.4: Logical Anomalies - Invalid Pricing
-- Identifies zero or negative prices (e.g., manual adjustments, freebies, or system errors).
SELECT COUNT(*) AS invalid_price_count
FROM mytable
WHERE Price <= 0;


-- =====================================================================================
-- 4. STATISTICAL SUMMARIES (NUMERICAL DISTRIBUTIONS)
-- =====================================================================================

-- Analyze the spread and central tendency of purchase quantities
SELECT 
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    ROUND(AVG(Quantity), 2) AS avg_quantity
FROM mytable;

-- Analyze the spread and central tendency of product pricing
SELECT 
    MIN(Price) AS min_price,
    MAX(Price) AS max_price,
    ROUND(AVG(Price), 2) AS avg_price
FROM mytable;


-- =====================================================================================
-- 5. BEHAVIORAL & GEOGRAPHIC PROFILING
-- =====================================================================================

-- 5.1: Top 5 High-Volume Products
-- Excludes missing item names and return transactions to find true demand.
SELECT Itemname, SUM(Quantity) AS total_volume_sold
FROM mytable
WHERE Itemname != '' AND Quantity > 0
GROUP BY Itemname
ORDER BY total_volume_sold DESC
LIMIT 5;

-- 5.2: Top 5 Most Active Customers
-- Identifies the most loyal/frequent buyers based on unique invoice counts.
SELECT CustomerID, COUNT(DISTINCT BillNo) AS total_transactions
FROM mytable
WHERE CustomerID != '' AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_transactions DESC
LIMIT 5;

-- 5.3: Geographic Distribution of Transactions
-- Identifies the primary markets driving transaction volume.
SELECT Country, COUNT(DISTINCT BillNo) AS total_transactions
FROM mytable
GROUP BY Country
ORDER BY total_transactions DESC
LIMIT 5;

-- 5.4: Transaction Basket Size Analysis
-- Utilizing a derived subquery to calculate items purchased per transaction.
SELECT 
    MAX(items_per_basket) AS max_basket_size,
    ROUND(AVG(items_per_basket), 2) AS avg_basket_size,
    MIN(items_per_basket) AS min_basket_size
FROM (
    SELECT BillNo, COUNT(Itemname) AS items_per_basket
    FROM mytable
    WHERE Quantity > 0 AND Itemname != ''
    GROUP BY BillNo
) AS BasketSizes;