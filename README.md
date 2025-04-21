# 🍕 Pizza Sales Data Analysis Using SQL

![](https://github.com/psyccho00/Pizza-Sales-Analysis_using_sql/blob/main/pizza.png)

## 📌 Overview

This project presents a comprehensive analysis of a fictional pizza sales dataset using SQL. The primary objective is to extract meaningful business insights that can aid in decision-making processes related to sales, customer behavior, and product performance.

## 🎯 Objectives

- Analyze total revenue and average order value.
- Determine the most popular pizza types and sizes.
- Understand customer ordering patterns.
- Identify peak sales periods by time and day.
- Provide actionable insights for business strategy.

## 🗂️ Dataset

The dataset simulates real-world pizza sales data and includes the following tables:

- `orders`: Order information with timestamps.
- `order_details`: Specifics of each order item.
- `pizzas`: Pizza variants with size and price.
- `pizza_types`: Descriptions and categories of pizzas.

## 🧾 Schema

### Creating Table.

```sql
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    email TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TEXT,
    time TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_details_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    pizza_id TEXT,
    quantity INTEGER,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

CREATE TABLE pizzas (
    pizza_id TEXT PRIMARY KEY,
    pizza_type_id TEXT,
    size TEXT,
    price REAL,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

CREATE TABLE pizza_types (
    pizza_type_id TEXT PRIMARY KEY,
    name TEXT,
    category TEXT,
    ingredients TEXT
);
```

## 📈 Business Questions & SQL Solutions

### Basic:
### 1. Retrieve the total number of orders placed.

```sql
SELECT 
	COUNT(order_id) as total_orders
FROM orders;
```

### 2. Calculate the total revenue generated from pizza sales.
```sql
SELECT
	SUM(od.quantity * pi.price) as total_sales
FROM order_details as od
JOIN pizzas as pi 
ON od.pizza_id = pi.pizza_id;
```

### 3. Identify the highest-priced pizza.

```sql
SELECT 
	pt.name,
	pi.price
FROM pizzas as pi
JOIN pizza_types as pt
ON pi.pizza_type_id = pt.pizza_type_id
ORDER BY 2 DESC LIMIT 1;
```

### 4. Identify the most common pizza size ordered.

```sql
SELECT
	pi.size AS size,
	pi.pizza_type_id AS pizza_type,
	SUM(od.quantity) AS total_quantity
FROM order_details as od
JOIN pizzas as pi
ON od.pizza_id = pi.pizza_id
GROUP BY 2,1
ORDER BY 3 DESC LIMIT 1;
```

### 5. List the top 5 most ordered pizza types along with their quantities.

```sql
SELECT
	pi.pizza_type_id AS pizza_type,
	pi.size AS size,
	SUM(od.quantity) AS total_quantity_ordered
FROM order_details as od
JOIN pizzas as pi
ON od.pizza_id = pi.pizza_id
GROUP BY 2,1
ORDER BY 3 DESC LIMIT 5;
```

### Intermediate:
### 6. Determine the distribution of orders by hour of the day.

```sql
SELECT 
	 EXTRACT(HOUR FROM order_time) as hour,
	 COUNT(order_id)	 
FROM orders
group by 1
order by 1 ;
```

### 7. Join relevant tables to find the category-wise distribution of pizzas.

```sql
SELECT
	category,
	COUNT(name)
FROM pizza_types
GROUP BY 1 
ORDER BY 2 DESC;
```

### 8. Group the orders by date and calculate the average number of pizzas ordered per day.

```sql
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
```

### 9. Determine the top 3 most ordered pizza types based on revenue.

```sql
SELECT
	pi.pizza_type_id,
	SUM(pi.price*od.quantity) AS revenue
FROM pizzas AS pi
JOIN order_details AS od
ON pi.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC LIMIT 3;
```
	
### Advanced:
### 10. Calculate the percentage contribution of each pizza type to total revenue.

```sql
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
```

### 11. Analyze the cumulative revenue generated over time.

```sql
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
```

### 12. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

```sql
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
```


## 🛠️ Tools Used

- **Database:** SQLite
- **Language:** SQL
- **Visualization:** [Optional tools like Tableau or Power BI]

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/psyccho00/Pizza-Sales-Analysis_using_sql.git
   cd pizza-sales-sql
   ```

2. Import the `pizza_sales.sql` file into your SQL database.

3. Execute the queries provided in the analysis section to explore the data.


## 👨‍💻 Author

Made by [@psyccho00](https://github.com/psyccho00)

If you liked this, please ⭐ the repo!


*Happy Analyzing! 🍕*
