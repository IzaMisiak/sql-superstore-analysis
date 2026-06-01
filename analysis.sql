-- OVERVIEW
-- What is the total sales and profit in the entire dataset?

SELECT 
	SUM(sales)		AS total_sales
	,SUM(profit) 	AS total_profit
FROM order_items
;

-- What is the total number of orders placed?

SELECT 
	COUNT(order_id) AS total_orders
FROM orders
;

-- PRODUCT ANALYSIS
-- What are the five most profitable products?

SELECT
	p.product_id
	,p.product_name
	,SUM(oi.profit) AS total_profit
FROM products p
JOIN order_items oi 
	ON p.product_id = oi.product_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5
;

-- Which products generate a loss?

SELECT
	p.product_id
	,p.product_name
	,SUM(oi.profit) AS total_profit
FROM products p
JOIN order_items oi 
	ON p.product_id = oi.product_id
GROUP BY 1,2
HAVING SUM(oi.profit) < 0
ORDER BY 3
;

-- What are the total sales by subcategories?

SELECT
	p.sub_category
	,SUM(oi.sales) AS total_sales
FROM products p
JOIN order_items oi
	ON p.product_id = oi.product_id
GROUP BY p.sub_category
ORDER BY SUM(oi.sales) DESC
;

-- What is the profit margin by category?

SELECT 
	p.category
	,ROUND(SUM(oi.profit)/SUM(oi.sales) * 100, 2) AS profit_margin
FROM products p 
JOIN order_items oi
	ON p.product_id = oi.product_id
GROUP BY 1

-- CUSTOMER ANALYSIS
-- Which customer segment generates the highest sales?

SELECT 
	c.segment
	,SUM(oi.sales) AS total_sales
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;

-- How many orders has each customer placed? 
-- Assign each of them to 3 categories: Loyal (more than 10 orders placed), Regular (more than 2 orders placed) or New (2 or fewer orders placed).

SELECT
	o.customer_id
	,o.nr_of_orders
	,CASE
		WHEN o.nr_of_orders > 10 THEN 'Loyal'
		WHEN o.nr_of_orders > 2 THEN 'Regular'
	ELSE 'New'
	END AS customer_type
FROM		
	(
	SELECT
		customer_id
		,COUNT(DISTINCT order_id) AS nr_of_orders
	FROM 
		orders
	GROUP BY 1
	) o
ORDER BY nr_of_orders DESC
;

-- Assign a global rank to all customers based on total sales in descending order.

WITH 
customer_sales AS
	(
    SELECT 
        c.customer_name
        ,SUM(oi.sales) AS total_sales
    FROM customers c 
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi 
        ON oi.order_id = o.order_id
    GROUP BY c.customer_name
    )
SELECT 
    customer_name
    ,total_sales
    ,ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS global_rank
FROM customer_sales;

-- Assign a rank to customers within each segment based on total sales in descending order.

WITH 
customer_sales AS 
	(
    SELECT 
        c.segment
        ,c.customer_name
        ,SUM(oi.sales) AS total_sales
    FROM customers c 
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi 
        ON oi.order_id = o.order_id
    GROUP BY c.segment, c.customer_name
    )
SELECT 
    segment
    ,customer_name
    ,total_sales
    ,ROW_NUMBER() OVER (PARTITION BY segment ORDER BY total_sales DESC) AS segment_rank
FROM customer_sales
;

-- RETURN ANALYSIS
-- Which products have the highest return rate?

SELECT
    oi.product_id
    ,COUNT(DISTINCT oi.order_id) 												AS total_orders_with_product
    ,ROUND(COUNT(DISTINCT r.order_id) / COUNT(DISTINCT oi.order_id), 2) * 100 	AS return_rate_pct
FROM order_items oi
LEFT JOIN returns r
    ON oi.order_id = r.order_id
GROUP BY oi.product_id
ORDER BY 3 DESC
;

-- Which customers have never returned any order?

SELECT c.customer_name
FROM customers c
WHERE NOT EXISTS 
	(
    SELECT o.customer_id
    FROM orders o
    JOIN returns r 
    	ON o.order_id = r.order_id
    WHERE o.customer_id = c.customer_id
    )
;

-- SHIPPING ANALYSIS
-- Which shipping mode generates the most returns?

SELECT 
	o.ship_mode
	,COUNT(r.return_id) AS nr_of_returns
FROM orders o
JOIN returns r
	ON o.order_id = r.order_id 
GROUP BY o.ship_mode
ORDER BY COUNT(r.return_id) DESC
;

-- What is the average shipping time by shipping mode?

SELECT
    ship_mode
    ,ROUND(AVG(DATEDIFF(ship_date, order_date))) AS avg_shipping_time
FROM orders
GROUP BY 1
ORDER BY 2 DESC
;

-- How many orders took longer than the average shipping time?

WITH 
order_times AS 
	(
    SELECT 
        order_id
        ,DATEDIFF(ship_date, order_date) 	AS shipping_days
    FROM orders
	),
avg_time AS 
	(
    SELECT 
    	ROUND(AVG(shipping_days)) 			AS avg_shipping_time
    FROM order_times
	)
SELECT 
    COUNT(*) 								AS orders_above_avg
FROM order_times ot
CROSS JOIN avg_time a
WHERE ot.shipping_days > a.avg_shipping_time
;