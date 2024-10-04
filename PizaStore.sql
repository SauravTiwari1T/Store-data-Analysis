create database pizza_project;
use pizza_project;
select * from order_details;

-- Retrieve the total number of orders placed.
select  count(order_id) as total_count from orders;
-- total number of order placed 21350

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2)
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select * from pizzas
order by  price desc
limit 1 ;

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_id) AS total_oders
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size; 

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.pizza_type_id,
    SUM(od.quantity) AS numberoforders,
    pt.name
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name , pt.pizza_type_id
ORDER BY numberoforders DESC
limit 5
;

-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(time) AS hours, COUNT(order_id) as totaloders
FROM
    orders
GROUP BY hours
order by totaloders desc
;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_project.pizza_types
GROUP BY category
;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        o.date, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.date) AS orderavg;

-- Determine the top 3 most ordered pizza types based on revenue.
select pt.name , sum(od.quantity * p.price) as revenu from order_details as od
join pizzas as p on p.pizza_id = od.pizza_id
join pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by revenu desc limit 5
;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT   pt.category ,
 round(SUM(od.quantity * p.price) / (SELECT 
            round(SUM(od.quantity * p.price),2)
        FROM
            pizzas AS p
                JOIN
            order_details AS od ON p.pizza_id = od.pizza_id)*100,2) AS 
revenue FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
;

-- Analyze the cumulative revenue generated over time.
select  revenue.datebyDay, revenue.total ,   sum(revenue.total) over(order by  revenue.datebyDay)
 as cum_revenue
 from
(select o.date as datebyDay, sum(od.quantity*p.price) as total  from orders as o
join order_details as od on od.order_id = o.order_id
join pizzas as p on  od.pizza_id = p.pizza_id
group by datebyDay) as revenue
;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pt.category , pt.name , sum(od.quantity * p.price) as revenue from pizzas as p
join order_details as od  on od.pizza_id = p.pizza_id
join pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
group by pt.category , pt.name
order by revenue desc
limit 3
;

