-- Create Table --

CREATE TABLE sales_store (
    transaction_id VARCHAR(15),
    customer_id VARCHAR(15),
    customer_name VARCHAR(30),
    customer_age INT,
    gender VARCHAR(15),
    product_id VARCHAR(15),
    product_name VARCHAR(15),
    product_category VARCHAR(15),
    quantiy INT,
    prce FLOAT,
    payment_mode VARCHAR(15),
    purchase_date VARCHAR(20),
    time_of_purchase TIME,
    status VARCHAR(15)
);

-- Check for Duplicates --

SELECT 
    transaction_id, COUNT(*)
FROM
    sales_store
GROUP BY transaction_id
HAVING COUNT(transaction_id) > 1;

-- Delete Duplicate Rows --

alter table sales_store
add column id int auto_increment primary key;

SELECT 
    *
FROM
    sales_store;

DELETE s1 FROM sales_store s1
        JOIN
    sales_store s2 ON s1.transaction_id = s2.transaction_id
        AND s1.id > s2.id;

CREATE TEMPORARY TABLE dup_ids AS
SELECT id
FROM (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY id) AS rn
    FROM sales_store
) t
WHERE rn > 1;

DELETE FROM sales_store
WHERE id IN (SELECT id FROM dup_ids);

SELECT transaction_id, COUNT(*) 
FROM sales_store
GROUP BY transaction_id
HAVING COUNT(*) > 1;

DROP TEMPORARY TABLE dup_ids;

-- Rename Column Names --

alter table sales_store
rename column quantiy to quantity;

alter table sales_store
rename column prce to price;

-- Check datatype of all columns --

desc sales_store;

-- Check Null --

SELECT 
    *
FROM
    sales_store
WHERE
    transaction_id IS NULL
        OR customer_id IS NULL
        OR customer_name IS NULL
        OR customer_age IS NULL
        OR gender IS NULL
        OR product_id IS NULL
        OR product_name IS NULL
        OR product_category IS NULL
        OR quantity IS NULL
        OR price IS NULL
        OR payment_mode IS NULL
        OR purchase_date IS NULL
        OR time_of_purchase IS NULL
        OR status IS NULL;

-- Update Table Entries --

SELECT 
    *
FROM
    sales_store
WHERE
    customer_name = 'Ehsaan Ram';

UPDATE sales_store 
SET 
    customer_id = 'CUST9494'
WHERE
    transaction_id = 'TXN977900';

SELECT 
    *
FROM
    sales_store
WHERE
    customer_name = 'Damini Raju';

UPDATE sales_store 
SET 
    customer_id = 'CUST1401'
WHERE
    transaction_id = 'TXN985663';

SELECT 
    *
FROM
    sales_store
WHERE
    customer_id = 'CUST1003';

-- Data Cleaning --

SELECT DISTINCT
    gender
FROM
    sales_store;

UPDATE sales_store 
SET 
    gender = 'M'
WHERE
    gender = 'Male';

SELECT DISTINCT
    payment_mode
FROM
    sales_store;

UPDATE sales_store 
SET 
    payment_mode = 'Credit Card'
WHERE
    payment_mode = 'CC';

update sales_store
set gender = 'F'
where gender = 'Female';

-- Data Analysis --

-- Find out the top 5 most selling products by quantity --

SELECT 
    product_name, SUM(quantity) AS total_quantity
FROM
    sales_store
GROUP BY product_name
ORDER BY total_quantity DESC;

-- Which products are the most frequently cancelled --

SELECT 
    product_name, COUNT(*) AS total_cancelled
FROM
    sales_store
WHERE
    status = 'cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC
LIMIT 5;

-- What time of the day has the highest number of purchases --

SELECT 
    CASE
        WHEN HOUR(time_of_purchase) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(time_of_purchase) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(time_of_purchase) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS total_purchases
FROM
    sales_store
GROUP BY time_of_day
ORDER BY total_purchases DESC
LIMIT 1;

-- Who are the top 5 highest spending customers --

SELECT 
    customer_id,
    customer_name,
    SUM(quantity * price) AS total_spend
FROM
    sales_store
GROUP BY customer_id , customer_name
ORDER BY total_spend DESC
LIMIT 5;

-- Which product categories generate the highest revenue --

SELECT 
    product_category, SUM(quantity * price) AS total_revenue
FROM
    sales_store
GROUP BY product_category
ORDER BY total_revenue DESC;

-- What is the return/cancellation rate per product category --

SELECT 
    product_category,
    ROUND(COUNT(CASE
                WHEN status = 'cancelled' THEN 1
            END) * 100 / COUNT(*),
            1) AS cancelled_rate_percent
FROM
    sales_store
GROUP BY product_category
ORDER BY cancelled_rate_percent DESC;

-- What is the most preffered payment method --

SELECT 
    payment_mode, COUNT(payment_mode) AS total_count
FROM
    sales_store
GROUP BY payment_mode
ORDER BY total_count DESC;

-- How does age group affect purchasing behaviour --

SELECT 
    CASE
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS customer_age_group,
    SUM(price * quantity) AS total_purchase
FROM
    sales_store
GROUP BY customer_age_group
ORDER BY total_purchase DESC;

-- Are certain genders buying more specific product categories? --

SELECT 
    gender,
    product_category,
    COUNT(product_category) AS total_purchase
FROM
    sales_store
GROUP BY gender , product_category
ORDER BY gender;




