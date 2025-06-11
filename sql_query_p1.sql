-- Data Exploration
-- How many sales we have

SELECT
	COUNT(total_sale) AS total_sale
FROM
	retail_sales;
    
-- How many unique customers we have

SELECT
	COUNT(DISTINCT customer_id) AS no_of_customers
FROM
	retail_sales;
    
-- How many categories are there

SELECT
	COUNT(DISTINCT category) AS no_of_categories
FROM
	retail_sales;

-- DATA ANALYSIS

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT 
	*
FROM
	retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT
	*
FROM
	retail_sales
WHERE category = 'Clothing' 
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT
	category,
    SUM(total_sale) AS total_sales
FROM
	retail_sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
	ROUND(AVG(age), 2) AS avg_age
FROM
	retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT
	*
FROM
	retail_sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT
	gender,
    category,
    COUNT(transaction_id) AS no_of_transactions
FROM
	retail_sales
GROUP BY gender, category
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT
	year,
    month,
    avg_sale
FROM
(SELECT
	YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale)) AS avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS avg_rank
FROM
	retail_sales
GROUP BY year, month) AS t1
WHERE avg_rank = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT
	customer_id,
    total_sales
FROM
(SELECT
	customer_id,
    SUM(total_sale) as total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(total_sale) DESC) AS rank_num
FROM
	retail_sales
GROUP BY customer_id) AS t1
WHERE rank_num <= 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT
	category,
    COUNT(DISTINCT customer_id) AS customers
FROM
	retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH cte1 AS (SELECT
	*,
    CASE
    WHEN HOUR(sale_time) < 12 THEN 'Morning' WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' ELSE 'Night' END AS shift
FROM
	retail_sales)

SELECT
	shift,
    COUNT(*) AS total_orders
FROM
	cte1
GROUP BY shift;

-- end of project