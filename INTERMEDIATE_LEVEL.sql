-- Create Sales table

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10, 2)
);

-- Insert sample data into Sales table

INSERT INTO Sales (sale_id, product_id, quantity_sold, sale_date, total_price) VALUES
(1, 101, 5, to_date('2024-01-01','YYYY-MM-DD'), 2500.00),
(2, 102, 3, to_date('2024-01-02','YYYY-MM-DD'), 900.00),
(3, 103, 2,to_date('2024-01-02','YYYY-MM-DD'), 60.00),
(4, 104, 4, to_date('2024-01-03','YYYY-MM-DD'), 80.00),
(5, 105, 6, to_date('2024-01-03','YYYY-MM-DD'), 90.00);

-- Create Products table

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into Products table

INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);

------------------------------SQL INTERMEDIATE LEVEL -------------------------------------

--1. Calculate the total quantity_sold of products in the 'Electronics' category.
select sum(s.quantity_sold) as total_quantity_sold
from
Sales s
join
Products p
on s.PRODUCT_ID=p.PRODUCT_ID
where p.category='Electronics';

--2. Retrieve the product_name and total_price from the Sales table, calculating the total_price as quantity_sold multiplied by unit_price.
SELECT p.PRODUCT_NAME,s.QUANTITY_SOLD * p.UNIT_PRICE as total_pricee
from
Sales s
join
Products p
on s.product_id=p.product_id;

--3. Identify the Most Frequently Sold Product from Sales table
select product_id,count(SALE_ID) as sales_count
from SALES
group by PRODUCT_ID
order by sales_count desc
fetch first 1 row only;

--4. Find the Products Not Sold from Products table
select product_id,product_name
from Products
where product_id not in (select distinct product_id from sales);

--5. Calculate the total revenue generated from sales for each product category.
SELECT p.category, sum(s.TOTAL_PRICE) as total_revenue
from
Sales s
join
Products p
on s.product_id=p.product_id
group by p.category;

--6. Find the product category with the highest average unit price.
select category
from PRODUCTS
group by category
order by avg(UNIT_PRICE) desc
fetch first 1 row only;

--7. Identify products with total sales exceeding 30.
SELECT p.product_name
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(s.total_price) > 30;

--8. Count the number of sales made in each month.
SELECT to_char(s.sale_date, 'YYYY-MM') AS month, COUNT(*) AS sales_count
FROM Sales s
GROUP BY month;

--9. Retrieve Sales Details for Products with 'Smart' in Their Name
SELECT s.sale_id, p.product_name, s.total_price 
FROM Sales s 
JOIN Products p ON s.product_id = p.product_id 
WHERE p.product_name LIKE '%Smart%';

--10. Determine the average quantity sold for products with a unit price greater than $100.
select avg(s.QUANTITY_SOLD) as Avg_Quant_sold
from
sales s
JOIN
products p
on s.product_id=p.product_id
where  p.unit_price > 100;
--11.Retrieve the product name and total sales revenue for each product.
SELECT p.PRODUCT_NAME, sum(s.TOTAL_PRICE) as total_revenue
from
sales s
join
products p
on s.product_id=p.product_id
group by p.PRODUCT_name;

--12.List all sales along with the corresponding product names.
select s.sale_id,p.product_name
from 
sales s
left join
products p
on s.product_id=p.product_id;

--13.Retrieve the product name and total sales revenue for each product.
select p.PRODUCT_NAME,sum(s.TOTAL_PRICE) as total_revenue
from
sales s
join
products p
on s.product_id=p.product_id
group by p.product_name;

--14.Rank products based on total sales revenue.
select p.PRODUCT_NAME,sum(s.TOTAL_PRICE) as total_revenue,
 rank() over(order by sum(s.TOTAL_PRICE) desc) as revenue_rank
from
sales s
join
products p
on s.product_id=p.product_id
group by p.product_name;

--15.Calculate the running total revenue for each product category.
select p.PRODUCT_NAME,p.CATEGORY,s.SALE_DATE,
sum(s.TOTAL_PRICE) over (partition by p.CATEGORY order by s.SALE_DATE) as
running_total_revenue
from 
sales s
join
Products p
on s.product_id=p.product_id;

--16.Categorize sales as "High", "Medium", or "Low" based on total price (e.g., > $200 is High,
-- $100-$200 is Medium, < $100 is Low).
SELECT SALE_ID,
case
    when TOTAL_PRICE > 200 then 'High'
    when TOTAL_PRICE between 100 and 200 then 'medium'
    else 'Low'
    end as level_
from sales;

--17. Identify sales where the quantity sold is greater than the average quantity sold.

select *
from SALES
where QUANTITY_SOLD > (select avg(QUANTITY_SOLD) as Avg_Quant_sold
                       from sales);

--18.Extract the month and year from the sale date and count the 
--number of sales for each month.

--19. Calculate the number of days between the current date and the sale date for each sale.


SELECT sale_id, DATEDIFF(NOW(), sale_date) AS days_since_sale
FROM Sales;
