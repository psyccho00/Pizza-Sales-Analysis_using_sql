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

### 1. What is the total revenue generated?

```sql
SELECT ROUND(SUM(od.quantity * p.price), 2) AS Total_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

*Insight:* Calculates the total revenue by summing the product of quantity and price for all orders.

### 2. What is the average order value?

```sql
SELECT ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS Avg_Order_Value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

*Insight:* Determines the average revenue per order, helping to understand customer spending behavior.

### 3. Which pizzas are the top 5 bestsellers?

```sql
SELECT pt.name, SUM(od.quantity) AS Total_Quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY Total_Quantity DESC
LIMIT 5;
```

*Insight:* Identifies the most popular pizzas, aiding inventory and marketing strategies.

### 4. What is the distribution of sales by pizza size?

```sql
SELECT p.size, SUM(od.quantity) AS Total_Sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY Total_Sold DESC;
```

*Insight:* Helps in understanding customer preferences regarding pizza sizes.

### 5. When are the peak hours for sales?

```sql
SELECT strftime('%H', time) AS Hour, COUNT(DISTINCT order_id) AS Order_Count
FROM orders
GROUP BY Hour
ORDER BY Hour;
```

*Insight:* Determines the busiest hours, which can inform staffing and promotional efforts.

### 6. What days of the week have the highest sales?

```sql
SELECT strftime('%w', order_date) AS DayOfWeek, COUNT(*) AS Order_Count
FROM orders
GROUP BY DayOfWeek
ORDER BY Order_Count DESC;
```

*Insight:* Identifies the most active days, assisting in scheduling and resource allocation.


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


*Happy Analyzing! 🍕*
