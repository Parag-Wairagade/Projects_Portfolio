-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Selecting database
use  walmartSales;

-- Droping Table if any exists

drop table sales;
create table sales (
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10, 2) not null,
    quantity int not null,
    VAT float(6, 4) not null,
    total decimal(10, 2) not null,
    date date not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10, 2) not null,
	gross_margin_percentage float(11, 9) not null,
    gross_income decimal(10, 2) not null,
    rating float(2, 1) not null
);
-- Adding data from CSV file
select * from sales;

-- -----------adding new coloums----------------------------

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case
		when time between "00:00:00" and "12:00:00" then "morning"
        when time between "12:01:00" and "17:00:00" then "afternoon"
        else "evening"
	end
);
alter table sales add column day_name varchar(10);

update sales
set day_name = (dayname(date));

alter table sales add column month_name varchar(10);
update sales
set month_name = (monthname(date));

-- -------------------------Exploratory Data Analysis (EDA)--------------------------

--   ----------------Q1:How many unique cities does the data have?-------------

SELECT 
    COUNT(DISTINCT city)
FROM
    sales;
-- ------------------2. In which city is each branch?----------------

SELECT DISTINCT
    city, branch
FROM
    sales;

-- -----------------3. How many unique product lines does the data have?--------------

SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;
-- -------------------4.What is the most common payment method?------------------
SELECT 
    payment_method, COUNT(payment_method) AS count
FROM
    sales
GROUP BY payment_method
ORDER BY count DESC;

-- --------------------5.What is the most selling product line?----------------

SELECT 
    product_line, COUNT(product_line) AS count
FROM
    sales
GROUP BY product_line
ORDER BY count DESC;

-- -------------------6.What is the total revenue by month?------------------

SELECT 
    month_name, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name;

-- --------------------7.What month had the largest COGS?---------------------

SELECT 
    month_name, SUM(cogs) AS total_cogs
FROM
    sales
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1;

-- ---------------------8.What product line had the largest revenue?-------------

SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- -----------------9. What is the city with the largest revenue?-----------------

SELECT 
    city, SUM(total) AS total_revenue
FROM
    sales
GROUP BY city
ORDER BY total_revenue DESC
limit 1;

-- -----------------10.What product line had the largest VAT?------------

SELECT 
    product_line, SUM(VAT) AS total_vat
FROM
    sales
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- ------------------11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

 select
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
 
 -- ----------------12. What is the most common product line by gender?----------

SELECT 
    gender, product_line, COUNT(product_line)
FROM
    sales
GROUP BY gender , product_line
ORDER BY COUNT(product_line) DESC;

-- ------------------13.What is the average rating of each product line?----------

SELECT 
    product_line, AVG(rating)
FROM
    sales
GROUP BY product_line;

-- -----------------14. Number of sales made in each time of the day per weekday-------

SELECT 
    time_of_day, SUM(quantity) AS total_sales
FROM
    sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- -----------------15. Which of the customer types brings the most revenue?------------

SELECT 
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- ----------------16.Which city has the largest tax percent/ VAT (**Value Added Tax**)?----

SELECT 
    city, SUM(VAT) AS total_vat
FROM
    sales
GROUP BY city
ORDER BY total_vat DESC;

-- ----------------17.What is the gender of most of the customers?----------------

SELECT 
    gender, SUM(quantity) AS total_sales
FROM
    sales
GROUP BY gender
ORDER BY total_sales DESC;

-- ----------------18.What is the gender distribution per branch?--------------------

SELECT 
    branch, gender, SUM(quantity) AS total_sales
FROM
    sales
GROUP BY branch , gender
ORDER BY branch;

-- ----------------19.Which time of the day do customers give most ratings per branch?----

SELECT 
    branch, time_of_day, AVG(rating)
FROM
    sales
GROUP BY branch , time_of_day
ORDER BY branch;

-- -----------------20.Which day of the week has the best average ratings per branch?--------

SELECT 
    branch, day_name, AVG(rating)
FROM
    sales
GROUP BY branch , day_name
ORDER BY branch;

-- --------------------------------------------------------------------------------------------