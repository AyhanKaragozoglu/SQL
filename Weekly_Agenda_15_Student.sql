---- RDB&SQL Exercise-2 Student

----1. By using view get the average sales by staffs and years using the AVG() aggregate function.
SELECT *
FROM sale.staff

Select *
 FROM sale.orders

SELECT o.order_id, s.staff_id, AVG(i.quantity) 
FROM sale.orders o
INNER JOIN  sale.staff s 
            on s.staff_id = o.staff_id
INNER JOIN sale.order_item i 
            on o.order_id = i.order_id
GROUP BY o.order_date

SELECT year(o.order_date), s.staff_id, AVG(i.quantity)
FROM sale.orders o 
INNER JOIN sale.staff s 
on o.staff_id = s.staff_id
INNER JOIN sale.order_item i on o.order_id = i.order_id
GROUP by  year(o.order_date), s.staff_id 


----2. Select the annual amount of product produced according to brands (use window functions).

CREATE OR ALTER VIEW vw_product_product --view oluşturur.
AS 
SELECT p.brand_id,  i.order_id, i.product_id,YEAR(o.order_date) as y,sum(i.quantity) as a
FROM sale.order_item i 
LEFT JOIN sale.orders o ON i.order_id = o.order_id 
LEFT JOIN product.product p ON i.product_id = p.product_id
GROUP BY p.brand_id, i.order_id, i.product_id,YEAR(o.order_date)

------------
SELECT * from vw_product_product;

SELECT * 
FROM product.brand

SELECT * 
FROM product.product;



----3. Select the least 3 products in stock according to stores.
SELECT *
FROM product.stock

SELECT *
FROM product.product

SELECT top 3  p.product_name, s.quantity
From product.product p 
JOIN product.stock s on p.product_id = s.product_id
ORDER BY s.quantity DESC;



----4. Return the average number of sales orders in 2020 sales

SELECT *
FROM sale.order_item

SELECT *
FROM sale.orders

SELECT i.order_id, AVG(i.quantity) as AVG
from sale.order_item i 
JOIN sale.orders o on i.order_id = o.order_id
WHERE YEAR(o.order_date) = 2020
GROUP BY i.order_id ;




----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.

SELECT *
 FROM product.product 

SELECT b.brand_name , p.list_price
 FROM product.brand

SELECT  b.brand_name, p.list_price
from product.product p 
JOIN product.brand b 
        on p.brand_id = b.brand_id 

GROUP by b.brand_name , p.list_price
ORDER by p.list_price 
HAVING p.list_price < 4
