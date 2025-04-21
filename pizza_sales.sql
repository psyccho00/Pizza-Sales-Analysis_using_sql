CREATE TABLE IF NOT EXIST orders (
	order_id INT PRIMARY KEY,
	order_date DATE,
	order_time time
);


CREATE TABLE IF NOT EXISTS order_details (
	order_details_id INT PRIMARY KEY,
	order_id INT,
	pizza_id VARCHAR(20),
	quantity INT
);


CREATE TABLE IF NOT EXISTS pizzas(
	pizza_id VARCHAR(20),
	pizza_type_id VARCHAR(20),
	size VARCHAR(5),
	price FLOAT
); 


CREATE TABLE IF NOT EXISTS pizza_types(
	pizza_type_id varchar(20),
	name varchar(100),
	category varchar(20),
	ingredients varchar(100)
);




-- Basic:
-- 1. Retrieve the total number of orders placed.
SELECT 
	COUNT(order_id) as total_orders
FROM orders;


-- 2. Calculate the total revenue generated from pizza sales.
SELECT
	SUM(od.quantity * pi.price) as total_sales
FROM order_details as od
JOIN pizzas as pi 
ON od.pizza_id = pi.pizza_id;


-- 3. Identify the highest-priced pizza.
SELECT 
	pt.name,
	pi.price
FROM pizzas as pi
JOIN pizza_types as pt
ON pi.pizza_type_id = pt.pizza_type_id
ORDER BY 2 DESC LIMIT 1;


-- 4. Identify the most common pizza size ordered.
SELECT
	pi.size AS size,
	pi.pizza_type_id AS pizza_type,
	SUM(od.quantity) AS total_quantity
FROM order_details as od
JOIN pizzas as pi
ON od.pizza_id = pi.pizza_id
GROUP BY 2,1
ORDER BY 3 DESC LIMIT 1;


-- 5. List the top 5 most ordered pizza types along with their quantities.
SELECT
	pi.pizza_type_id AS pizza_type,
	pi.size AS size,
	SUM(od.quantity) AS total_quantity_ordered
FROM order_details as od
JOIN pizzas as pi
ON od.pizza_id = pi.pizza_id
GROUP BY 2,1
ORDER BY 3 DESC LIMIT 5;


-- Intermediate:
-- 6. Determine the distribution of orders by hour of the day.
SELECT 
	 EXTRACT(HOUR FROM order_time) as hour,
	 COUNT(order_id)	 
FROM orders
group by 1
order by 1 ;


-- 7. Join relevant tables to find the category-wise distribution of pizzas.
SELECT
	category,
	COUNT(name)
FROM pizza_types
GROUP BY 1 
ORDER BY 2 DESC;


-- 8. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT
	ROUND(AVG(summ),2) AS Average
	FROM(
SELECT 
	ord.order_date,
	SUM(od.quantity) AS summ
FROM order_details AS od
JOIN orders AS ord
ON od.order_id = ord.order_id
GROUP BY 1) AS t1; 


-- 9. Determine the top 3 most ordered pizza types based on revenue.
SELECT
	pi.pizza_type_id,
	SUM(pi.price*od.quantity) AS revenue
FROM pizzas AS pi
JOIN order_details AS od
ON pi.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC LIMIT 3;

	
-- Advanced:
-- 10. Calculate the percentage contribution of each pizza type to total revenue.
SELECT
	pi.pizza_type_id,
	(SUM(pi.price*od.quantity)/(SELECT
		SUM(od.quantity * pi.price) AS total_sales
		FROM order_details as od
		JOIN pizzas as pi 
		ON od.pizza_id = pi.pizza_id ) * 100) AS revenue
FROM pizzas AS pi
JOIN order_details AS od
ON pi.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC;


-- 11. Analyze the cumulative revenue generated over time.
SELECT 
	order_date,
	SUM(revenue) OVER(ORDER BY order_date) as cum_revenue
FROM
(SELECT 
	ord.order_date,
	SUM(pi.price*od.quantity) AS revenue
FROM order_details AS od
JOIN pizzas AS pi
ON pi.pizza_id = od.pizza_id
JOIN orders as ord
ON ord.order_id = od.order_id
GROUP BY 1) AS t1;


-- 12. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT
	name,
	revenue
FROM(
	SELECT 
		category,
		name,
		revenue,
		RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
	FROM(
		SELECT 
			pt.category,
			pt.name,
			SUM((od.quantity) * pi.price ) AS revenue
		FROM pizza_types AS pt
		JOIN pizzas AS pi
		ON pt.pizza_type_id = pi.pizza_type_id
		JOIN order_details AS od
		ON od.pizza_id = pi.pizza_id
		GROUP BY 1,2
	)	AS t1 
)	AS t2
WHERE rn <=3;

