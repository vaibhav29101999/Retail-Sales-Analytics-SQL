create database adventure_analysis ;
use adventure_analysis ;
select * from product ;
select * from region ;
select * from reseller ;
select * from sales ;
select * from salesperson ;
select * from salespersonregion ;
select * from targets ;

-- Certainly! The error you're encountering:
-- Error Code: 1366. Incorrect DECIMAL value: '0' for column '' at row -1
-- typically means MySQL is unable to convert some values in your Standard Cost column into the DECIMAL type. This is usually due to non-numeric or improperly formatted data in that column.
-- Let me explain step-by-step how to identify and fix this issue so your ALTER TABLE command works successfully.

-- Step 1: Identify problematic data in the Standard Cost column
-- Your goal is to find any rows where the Standard Cost value is not a valid number that can be converted to DECIMAL(10,2).
SELECT `Standard Cost`
FROM product
WHERE `Standard Cost` = ''
   OR `Standard Cost` IS NULL
   OR `Standard Cost` NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$';
-- Standard Cost = '' finds empty strings.

-- Standard Cost IS NULL finds NULL values.

-- NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$' finds any value not matching a decimal number pattern (e.g., it excludes strings like abc, $12.50, or 12..3).

-- Step 2: Clean empty or NULL values
-- If the above query returns rows with empty or NULL values, replace those with '0' (or another valid numeric default):
UPDATE product
SET `Standard Cost` = '0'
WHERE `Standard Cost` = '' OR `Standard Cost` IS NULL;

-- This replaces empty or NULL values with string '0' which can be converted into decimal.

-- Step 3: Remove unwanted characters
-- If some values contain non-numeric characters like $ or commas (e.g., $63.45 or 1,234.56), you need to remove them because they prevent conversion:
UPDATE product
SET `Standard Cost` = REPLACE(REPLACE(`Standard Cost`, '$', ''), ',', '')
WHERE `Standard Cost` LIKE '%$%' OR `Standard Cost` LIKE '%,%';
-- The inner REPLACE removes $.
-- The outer REPLACE removes commas.
-- The WHERE clause targets rows containing these characters.

-- Step 4: Convert cleaned strings to decimal (optional)
-- You can try to explicitly convert the values in Standard Cost to decimals to confirm no errors remain:
UPDATE product
SET `Standard Cost` = CAST(`Standard Cost` AS DECIMAL(10,2))
WHERE `Standard Cost` REGEXP '^[0-9]+(\.[0-9]{1,2})?$';
-- If this query runs without error, your data is ready for the type change.

-- Step 5: Verify no invalid data remains
-- Run this query again to check for any remaining problematic rows:
SELECT `Standard Cost`
FROM product
WHERE `Standard Cost` = ''
   OR `Standard Cost` IS NULL
   OR `Standard Cost` NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$';
-- If this returns zero rows, you’re ready for the next step.

-- Step 6: Alter the table column to DECIMAL
-- Now that all data is clean and convertible, you can safely run the alter statement:
ALTER TABLE product
CHANGE `Standard Cost` standard_cost DECIMAL(10,2),
CHANGE `Background Color Format` background_color_format VARCHAR(100),
CHANGE `Font Color Format` font_color_format VARCHAR(100);
-- Step	Purpose	Query / Action
-- 1 Find invalid values	SELECT ... WHERE NOT REGEXP
-- 2 Replace empty or NULL with '0'	UPDATE ... SET ... WHERE ...
-- 3 Remove $ and commas	UPDATE ... SET ... REPLACE ... WHERE ...
-- 4 Cast strings to decimals	UPDATE ... SET ... CAST(...) WHERE REGEXP ...
-- 5 Verify clean data	Same as step 1
-- 6 Change column type	ALTER TABLE ... CHANGE ... DECIMAL(10,2)
-- -----------------------------------------------------------------------
UPDATE sales
SET cost = REPLACE(REPLACE(cost, '$', ''), ',', '')
WHERE cost LIKE '%$%' OR cost LIKE '%,%';
UPDATE sales
SET cost = FLOOR(CAST(cost AS DECIMAL(10,2)))
WHERE cost REGEXP '^[0-9]+(\.[0-9]+)?$';
SELECT DISTINCT cost
FROM sales
WHERE cost NOT REGEXP '^[0-9]+$';
ALTER TABLE sales MODIFY cost INT;

update sales set sales = replace(replace(sales, '$', ''), ',', '')
where sales like '%$%' or sales like '%,%';
update sales set sales = floor(cast(sales as decimal(10, 2)))
where sales regexp '^[0-9]+(\.[0-9]+)?$' ;
select distinct sales from sales where sales not regexp '^[0-9]+$';
alter table sales modify sales INT ;

UPDATE sales
SET `Unit Price` = REPLACE(REPLACE(TRIM(`Unit Price`), '$', ''), ',', '')
WHERE `Unit Price` LIKE '%$%' OR `Unit Price` LIKE '%,%';
UPDATE sales
SET `Unit Price` = FLOOR(CAST(`Unit Price` AS DECIMAL(10,2)))
WHERE `Unit Price` REGEXP '^[0-9]+(\.[0-9]+)?$';
SELECT DISTINCT `Unit Price`
FROM sales
WHERE `Unit Price` NOT REGEXP '^[0-9]+$';
ALTER TABLE sales
MODIFY COLUMN `Unit Price` INT;
ALTER TABLE sales
CHANGE `Unit Price` `Unit_Price` VARCHAR(255);
ALTER TABLE sales
MODIFY COLUMN Unit_Price INT;

select sum(unit_price) from sales ;

select * from targets;
ALTER TABLE targets ADD COLUMN TargetMonth_clean DATE;
UPDATE targets SET TargetMonth_clean = STR_TO_DATE(TargetMonth, '%W, %M %e, %Y');
set sql_safe_updates = 0 ;
alter table targets drop column TargetMonth ;
alter table targtes change TargetMonth_clean Target_month date ;
ALTER TABLE targets CHANGE TargetMonth_clean TargetMonth DATE;
alter table Targets modify target varchar(255);
ALTER TABLE targets
ADD COLUMN target_clean DECIMAL(10,2);
UPDATE targets SET target_clean = CAST(REPLACE(target, '$', '') AS DECIMAL(10,2));
select distinct target from targets;
select * from targets;
UPDATE targets
SET target= CAST(
    REPLACE(REPLACE(target, '$', ''), ',', '') AS DECIMAL(10,2))
WHERE target REGEXP '^[\\$]?[0-9,]+(\\.[0-9]+)?$';
ALTER TABLE targets modify target DECIMAL(10,2);
alter table salesperson 
modify salesperson varchar (255),
modify Title varchar (100), 
modify UPN varchar (255) ;

ALTER TABLE sales ADD COLUMN OrderDate_new DATE;
UPDATE sales
SET OrderDate_new = STR_TO_DATE(OrderDate, '%W, %M %d, %Y');
SELECT OrderDate, OrderDate_new
FROM sales
WHERE OrderDate_new IS NULL;
ALTER TABLE sales DROP COLUMN OrderDate;
ALTER TABLE sales CHANGE OrderDate_new OrderDate DATE;
select * from sales;

alter table sales 
modify unit_price decimal(10, 2),
modify sales decimal(10, 2),
modify cost decimal(10, 2) ;

alter table reseller change `state-province` state_province varchar(255);
alter table reseller change `Country-Region` Country_Region varchar(255);
alter table reseller modify column `Business type` varchar(100);
alter table reseller 
modify column reseller varchar(255),
modify column city varchar(100);

alter table region 
modify column region varchar(100),
modify column country varchar(100),
modify column `Group` varchar(100);
ALTER TABLE region  
CHANGE COLUMN `Group` group_name VARCHAR(100);

ALTER TABLE product
CHANGE `Standard Cost` standard_cost DECIMAL(10,2),
CHANGE `Background Color Format` background_color_format VARCHAR(100),
CHANGE `Font Color Format` font_color_format VARCHAR(100);

SELECT `Standard Cost`
FROM product
WHERE `Standard Cost` NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$'
   OR `Standard Cost` IS NULL
   OR `Standard Cost` = '';
UPDATE product
SET `Standard Cost` = '0'
WHERE `Standard Cost` IS NULL OR `Standard Cost` = '';
ALTER TABLE product
CHANGE `Standard Cost` standard_cost DECIMAL(10,2),
CHANGE `Background Color Format` background_color_format VARCHAR(100),
CHANGE `Font Color Format` font_color_format VARCHAR(100);
UPDATE product
SET `Standard Cost` = '0'
WHERE `Standard Cost` = '' OR `Standard Cost` IS NULL;
UPDATE product
SET `Standard Cost` = REPLACE(`Standard Cost`, '$', '')
WHERE `Standard Cost` LIKE '%$%';
UPDATE product
SET `Standard Cost` = CAST(`Standard Cost` AS DECIMAL(10,2));
ALTER TABLE product
CHANGE `Standard Cost` standard_cost DECIMAL(10,2),
CHANGE `Background Color Format` background_color_format VARCHAR(100),
CHANGE `Font Color Format` font_color_format VARCHAR(100);
alter table sales modify column SalesOrderNumber varchar(100);

-- CONSTRAINS 
ALTER TABLE product ADD CONSTRAINT pk_product PRIMARY KEY (ProductKey);
ALTER TABLE region ADD CONSTRAINT pk_region PRIMARY KEY (SalesTerritoryKey);
ALTER TABLE reseller ADD CONSTRAINT pk_reseller PRIMARY KEY (ResellerKey);
-- ALTER TABLE sales ADD CONSTRAINT pk_sales PRIMARY KEY (SalesOrderNumber);
ALTER TABLE salesperson ADD CONSTRAINT pk_salesperson PRIMARY KEY (EmployeeKey);
ALTER TABLE salespersonregion ADD CONSTRAINT pk_salespersonregion PRIMARY KEY (EmployeeKey, SalesTerritoryKey);
ALTER TABLE targets ADD CONSTRAINT pk_targets PRIMARY KEY (EmployeeID, TargetMonth);


ALTER TABLE sales
ADD CONSTRAINT fk_sales_product FOREIGN KEY (ProductKey) REFERENCES product(ProductKey),
ADD CONSTRAINT fk_sales_reseller FOREIGN KEY (ResellerKey) REFERENCES reseller(ResellerKey),
ADD CONSTRAINT fk_sales_salesperson FOREIGN KEY (EmployeeKey) REFERENCES salesperson(EmployeeKey),
ADD CONSTRAINT fk_sales_region FOREIGN KEY (SalesTerritoryKey) REFERENCES region(SalesTerritoryKey);

ALTER TABLE salespersonregion
ADD CONSTRAINT fk_spr_salesperson FOREIGN KEY (EmployeeKey) REFERENCES salesperson(EmployeeKey),
ADD CONSTRAINT fk_spr_region FOREIGN KEY (SalesTerritoryKey) REFERENCES region(SalesTerritoryKey);

ALTER TABLE salesperson ADD UNIQUE (EmployeeID);
ALTER TABLE targets ADD CONSTRAINT fk_targets_employee
FOREIGN KEY (EmployeeID) REFERENCES salesperson(EmployeeID);
-- -------------------------------------------------------------------------------------------------------
-- Sales Analytics Queries (50)
-- 📊 Sales & Revenue Insights

-- 1. Total sales and total profit across all time
SELECT SUM(sales) AS total_sales, SUM(sales - cost) AS total_profit FROM sales;

-- 2. Monthly revenue trend
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS month, SUM(sales) AS monthly_sales FROM sales GROUP BY month ORDER BY month;

-- 3. Top 10 best-selling products by quantity
SELECT p.Product, SUM(s.Quantity) AS total_quantity FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product ORDER BY total_quantity DESC LIMIT 10;

-- 4. Top 10 products by revenue
SELECT p.Product, SUM(s.sales) AS total_revenue FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product ORDER BY total_revenue DESC LIMIT 10;

-- 5. Year-over-year revenue growth
SELECT YEAR(OrderDate) AS year, SUM(sales) AS yearly_sales FROM sales GROUP BY year ORDER BY year;

-- 6. Products with negative profit margin
SELECT p.Product, SUM(sales) AS revenue, SUM(cost) AS cost FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product HAVING SUM(sales) < SUM(cost);

-- 7. Sales by category and subcategory
SELECT Category, Subcategory, SUM(sales) AS total_sales FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY Category, Subcategory;

-- 8. Average order value per transaction
SELECT AVG(sales) AS avg_order_value FROM sales;

-- 9. Sales trend comparison: last year vs this year
SELECT YEAR(OrderDate) AS year, MONTH(OrderDate) AS month, SUM(sales) AS total_sales FROM sales WHERE YEAR(OrderDate) IN (YEAR(CURDATE()), YEAR(CURDATE()) - 1) GROUP BY year, month ORDER BY year, month;

-- 10. Highest single-day revenue
SELECT OrderDate, SUM(sales) AS total_sales FROM sales GROUP BY OrderDate ORDER BY total_sales DESC LIMIT 1;

-- Salesperson Performance
-- 11. Total sales by each salesperson
SELECT sp.salesperson, SUM(s.sales) AS total_sales FROM sales s JOIN salesperson sp ON s.EmployeeKey = sp.EmployeeKey GROUP BY sp.salesperson ORDER BY total_sales DESC;

-- 12. Target vs actual sales by month per salesperson
SELECT sp.salesperson, t.TargetMonth, t.target, SUM(s.sales) AS actual_sales FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID LEFT JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY sp.salesperson, t.TargetMonth, t.target;

-- 13. Salesperson(s) who exceeded their targets
SELECT sp.salesperson, t.TargetMonth, t.target, SUM(s.sales) AS actual_sales FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY sp.salesperson, t.TargetMonth, t.target HAVING actual_sales > t.target;

-- 14. Salesperson(s) with the most deals closed
SELECT sp.salesperson, COUNT(DISTINCT s.SalesOrderNumber) AS deals_closed FROM sales s JOIN salesperson sp ON s.EmployeeKey = sp.EmployeeKey GROUP BY sp.salesperson ORDER BY deals_closed DESC;

-- 15. Salesperson-wise average deal value
SELECT sp.salesperson, AVG(s.sales) AS avg_deal_value FROM sales s JOIN salesperson sp ON s.EmployeeKey = sp.EmployeeKey GROUP BY sp.salesperson;

-- 16. Top 5 underperforming salespersons (below target)
SELECT sp.salesperson, t.TargetMonth, t.target, IFNULL(SUM(s.sales), 0) AS actual_sales FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID LEFT JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY sp.salesperson, t.TargetMonth, t.target HAVING actual_sales < t.target ORDER BY actual_sales LIMIT 5;

-- 17. Monthly leaderboard of top salespeople
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS month, sp.salesperson, SUM(s.sales) AS monthly_sales FROM sales s JOIN salesperson sp ON s.EmployeeKey = sp.EmployeeKey GROUP BY month, sp.salesperson ORDER BY month, monthly_sales DESC;

-- 18. Cumulative sales by salesperson
SELECT sp.salesperson, SUM(s.sales) AS cumulative_sales FROM sales s JOIN salesperson sp ON s.EmployeeKey = sp.EmployeeKey GROUP BY sp.salesperson;

-- Regional Insights

-- 19. Sales by country and region
SELECT r.country, r.region, SUM(s.sales) AS total_sales FROM sales s JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey GROUP BY r.country, r.region;

-- 20. Region-wise average unit price
SELECT r.region, AVG(s.unit_price) AS avg_unit_price FROM sales s JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey GROUP BY r.region;

-- 21. Territory with highest profit margins
SELECT r.region, SUM(s.sales - s.cost) AS total_profit FROM sales s JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey GROUP BY r.region ORDER BY total_profit DESC LIMIT 1;

-- 22. Region-wise monthly sales trend
SELECT r.region, DATE_FORMAT(s.OrderDate, '%Y-%m') AS month, SUM(s.sales) AS monthly_sales FROM sales s JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey GROUP BY r.region, month ORDER BY r.region, month;

-- 23. Compare sales between two regions over time
SELECT r.region, DATE_FORMAT(s.OrderDate, '%Y-%m') AS month, SUM(s.sales) AS monthly_sales FROM sales s JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey WHERE r.region IN ('North America', 'Europe') GROUP BY r.region, month ORDER BY month;

-- Reseller Insights

-- 24. Top 10 resellers by revenue
SELECT re.reseller, SUM(s.sales) AS total_revenue FROM sales s JOIN reseller re ON s.ResellerKey = re.ResellerKey GROUP BY re.reseller ORDER BY total_revenue DESC LIMIT 10;

-- 25. Number of resellers per region
SELECT r.region, COUNT(DISTINCT re.ResellerKey) AS reseller_count FROM reseller re JOIN region r ON re.Country_Region = r.country GROUP BY r.region;

-- 26. Resellers with repeated orders
SELECT re.reseller, COUNT(DISTINCT s.SalesOrderNumber) AS order_count FROM reseller re JOIN sales s ON re.ResellerKey = s.ResellerKey GROUP BY re.reseller HAVING order_count > 1;

-- 27. Sales distribution by business type
SELECT re.`Business type`, SUM(s.sales) AS total_sales FROM reseller re JOIN sales s ON re.ResellerKey = s.ResellerKey GROUP BY re.`Business type`;

-- 28. Top performing reseller by state
SELECT state_province, reseller, SUM(sales) AS total_sales FROM reseller re JOIN sales s ON re.ResellerKey = s.ResellerKey GROUP BY state_province, reseller ORDER BY state_province, total_sales DESC;

-- Cost & Profit Analysis
-- 29. Product-wise profit
SELECT p.Product, SUM(s.sales - s.cost) AS profit FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product;

-- 30. Profit margin % by product
SELECT p.Product, ROUND((SUM(s.sales - s.cost) / SUM(s.sales)) * 100, 2) AS profit_margin_percent FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product;

-- 31. Products with high cost but low revenue
SELECT p.Product, SUM(s.sales) AS revenue, SUM(s.cost) AS cost FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product HAVING revenue < cost;

-- Target Tracking
-- 32. Monthly target fulfillment rate
SELECT t.TargetMonth, ROUND(SUM(s.sales)/SUM(t.target)*100, 2) AS fulfillment_rate FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY t.TargetMonth;

-- 33. Employees who consistently meet/exceed targets
SELECT sp.salesperson FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY sp.salesperson HAVING MIN(s.sales) >= MIN(t.target);

-- 34. Total sales vs total target over time
SELECT t.TargetMonth, SUM(t.target) AS total_target, SUM(s.sales) AS total_sales FROM targets t JOIN salesperson sp ON t.EmployeeID = sp.EmployeeID JOIN sales s ON sp.EmployeeKey = s.EmployeeKey AND DATE_FORMAT(s.OrderDate, '%Y-%m') = DATE_FORMAT(t.TargetMonth, '%Y-%m') GROUP BY t.TargetMonth;

-- Product Intelligence
-- 35. Most profitable product subcategory
SELECT Subcategory, SUM(s.sales - s.cost) AS profit FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY Subcategory ORDER BY profit DESC LIMIT 1;

-- 36. Average unit price by category
SELECT Category, AVG(unit_price) AS avg_price FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY Category;

-- 37. Fastest-growing product by sales
SELECT p.Product, SUM(sales) AS total_sales FROM sales s JOIN product p ON s.ProductKey = p.ProductKey GROUP BY p.Product ORDER BY total_sales DESC LIMIT 1;

-- 38. Products never sold
SELECT p.Product FROM product p LEFT JOIN sales s ON p.ProductKey = s.ProductKey WHERE s.SalesOrderNumber IS NULL;

-- Inventory-like logic
-- 39. Subcategories with no recent sales (e.g. last 6 months)
SELECT DISTINCT Subcategory FROM product WHERE ProductKey NOT IN (SELECT DISTINCT ProductKey FROM sales WHERE OrderDate > DATE_SUB(CURDATE(), INTERVAL 6 MONTH));

-- Time-Series and Trend
-- 40. Sales seasonality by month
SELECT MONTH(OrderDate) AS month, SUM(sales) AS total_sales FROM sales GROUP BY month ORDER BY month;

-- 41. Quarter-wise sales summary
SELECT QUARTER(OrderDate) AS quarter, YEAR(OrderDate) AS year, SUM(sales) AS total_sales FROM sales GROUP BY year, quarter ORDER BY year, quarter;

-- Order Insights
-- 42. Count of orders per month
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS month, COUNT(DISTINCT SalesOrderNumber) AS order_count FROM sales GROUP BY month;

-- 43. Orders with high quantity (bulk deals)
SELECT SalesOrderNumber, Quantity FROM sales WHERE Quantity >= 100;

-- 44. First and last order date per reseller
SELECT re.reseller, MIN(OrderDate) AS first_order, MAX(OrderDate) AS last_order FROM reseller re JOIN sales s ON re.ResellerKey = s.ResellerKey GROUP BY re.reseller;

-- Data Validation & Cleansing
-- 45. Sales rows where unit price or cost is NULL or 0
SELECT * FROM sales WHERE unit_price IS NULL OR unit_price = 0 OR cost IS NULL OR cost = 0;

-- 46. Inconsistencies: sales != quantity * unit_price
SELECT * FROM sales WHERE sales != quantity * unit_price;