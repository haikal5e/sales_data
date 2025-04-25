-- Show all databases available in the current MySQL server
SHOW DATABASES;

-- Create a new database named 'sales'
CREATE DATABASE sales;

-- Use the 'sales' database for subsequent operations
USE sales;

-- Show all tables in the current database
SHOW TABLES;

-- Describe the structure of the 'sales_info' table
DESCRIBE sales_info;

-- Select all records from the 'sales_info' table
SELECT * FROM sales_info;

-- Select distinct products from the 'sales_info' table
SELECT DISTINCT `Product` FROM `sales_info`;

-- Select distinct cities from the 'sales_info' table
SELECT DISTINCT city FROM sales_info;

-- Calculate the average price for each product and round it to 2 decimal places
SELECT 
    product, 
    ROUND(AVG(`Price Each`), 2) AS "price per each" 
FROM 
    sales_info
GROUP BY 
    product;

-- Remove unnecessary columns from the 'sales_info' table
ALTER TABLE sales_info DROP COLUMN `Order Date`;
ALTER TABLE sales_info DROP COLUMN `Purchase Address`;
ALTER TABLE sales_info DROP COLUMN `Month`;
ALTER TABLE sales_info DROP COLUMN `Hour`;

-- Select products with total sales less than or equal to 500,000
SELECT 
    product, 
    ROUND(SUM(sales), 2) AS total_sales 
FROM 
    sales_info
GROUP BY 
    product
HAVING 
    total_sales <= 500000;    

-- Count the number of products sold in each city and order by count in descending order
SELECT 
    city, 
    COUNT(product) 
FROM 
    sales_info
GROUP BY 
    city
ORDER BY 
    COUNT(product) DESC;

-- Select products, their quantity ordered, total sales prices, and city, ordered by quantity ordered
SELECT 
    product, 
    `Quantity Ordered`, 
    ROUND(`Sales`, 2) AS total_prices, 
    City
FROM 
    sales_info
ORDER BY 
    `Quantity Ordered` DESC;

-- Calculate total quantity ordered for each product and order by total quantity in descending order
SELECT 
    product, 
    SUM(`Quantity Ordered`) AS total_item_sales 
FROM 
    sales_info
GROUP BY 
    product
ORDER BY 
    total_item_sales DESC;

-- Select order details with ranking and first quantity ordered for each product
SELECT 
    `Order ID`, 
    `Product`, 
    `Quantity Ordered`, 
    `Price Each`, 
    `Sales`, 
    ROW_NUMBER() OVER (PARTITION BY `Product` ORDER BY `Quantity Ordered` DESC) AS RowNum,
    RANK() OVER (PARTITION BY `Product` ORDER BY `Quantity Ordered` DESC) AS Qrank,
    FIRST_VALUE(`Quantity Ordered`) OVER (PARTITION BY `Product` ORDER BY `Quantity Ordered` DESC) AS FirstQuant
FROM 
    sales_info;

-- Select all records from 'sales_info' where the city is 'New York City'
SELECT * 
FROM sales_info
WHERE City = 'New York City';

-- Calculate total sales for each city and order by total sales in descending order
SELECT 
    City, 
    ROUND(SUM(Sales), 2) AS TotalSales
FROM 
    sales_info
GROUP BY 
    City
ORDER BY 
    TotalSales DESC;

-- Select the top 5 products by total quantity ordered
SELECT 
    Product, 
    SUM(`Quantity Ordered`) AS TotalQuantity
FROM 
    sales_info
GROUP BY 
    Product
ORDER BY 
    TotalQuantity DESC
LIMIT 5;

-- Calculate the average price for each product
SELECT 
    Product, 
    ROUND(AVG(`Price Each`), 2) AS AvgPrice
FROM 
    sales_info
GROUP BY 
    Product;

-- Calculate total revenue for each product and order by total revenue in descending order
SELECT 
    Product, 
    ROUND(SUM(Sales), 2) AS TotalRevenue
FROM 
    sales_info
GROUP BY 
    Product
ORDER BY 
    TotalRevenue DESC;

-- Select records where quantity ordered is greater than 4, ordered by quantity ordered in descending order
SELECT * 
FROM sales_info
WHERE `Quantity Ordered` > 4
ORDER BY `Quantity Ordered` DESC;

-- Rank products by sales within each city
SELECT 
    City, 
    Product, 
    Sales,
    RANK() OVER (PARTITION BY City ORDER BY Sales DESC) AS SalesRank
FROM 
    sales_info;

-- Calculate total sales and total quantity ordered for each product in each city
SELECT 
    City, 
    Product, 
    SUM(Sales) AS TotalSales, 
    SUM(`Quantity Ordered`) AS TotalQuantity
FROM 
    sales_info
GROUP BY 
    City, Product
ORDER BY 
    City, TotalSales DESC;

-- Select the record with the highest sales
SELECT * 
FROM sales_info
ORDER BY Sales DESC
LIMIT 1;

-- Calculate profit and profit margin for each order
SELECT 
    `Order ID`, 
    Product, 
    Sales, 
    ROUND((Sales - Sales * 0.85), 2) AS Profit,  
    ROUND(((Sales - Sales * 0.85) / Sales), 2) * 100 AS ProfitMargin
FROM 
    sales_info;

-- Count the number of orders for each city and order by count in descending order
SELECT 
    City, 
    COUNT(*) AS OrderCount
FROM 
    sales_info
GROUP BY 
    City
ORDER BY 
    OrderCount DESC;

-- Select records with any NULL values in critical fields
SELECT * 
FROM sales_info
WHERE `Order ID` IS NULL 
   OR Product IS NULL 
   OR `Quantity Ordered` IS NULL 
   OR `Price Each` IS NULL 
   OR Sales IS NULL 
   OR City IS NULL;

-- Calculate total revenue from all sales
SELECT 
    ROUND(SUM(Sales), 2) AS TotalRevenue
FROM 
    sales_info;

-- Find the city and product with the maximum quantity ordered
SELECT 
    s1.City, 
    s1.Product, 
    s1.TotalQuantity
FROM (
    SELECT 
        City, 
        Product, 
        SUM(`Quantity Ordered`) AS TotalQuantity
    FROM 
        sales_info
    GROUP BY 
        City, Product
) AS s1
JOIN (
    SELECT 
        City, 
        MAX(TotalQuantity) AS MaxQuantity
    FROM (
        SELECT 
            City, 
            Product, 
            SUM(`Quantity Ordered`) AS TotalQuantity
        FROM 
            sales_info
        GROUP BY 
            City, Product
    ) AS sub
    GROUP BY 
        City
) AS s2
ON s1.City = s2.City AND s1.TotalQuantity = s2.MaxQuantity;