--SQL Session-6 19.01.2023 Set Operators & Case Expression

---****SET operators


-- viev / join

CREATE VIEW sales_info as 
SELECT c.customer_id, c.first_name, c.city, o.order_id,oi.list_price, p.product_name
from sale.customer c 
inner JOIN sale.orders o  on c.customer_id = o.customer_id
INNER  JOIN sale.order_item oi on o.order_id = oi.order_id
INNER JOIN product.product p on oi.product_id = p.product_id

SELECT * FROM sales_info


alter VIEW sales_info as 
SELECT c.customer_id, c.first_name, c.city, o.order_id,oi.list_price, p.product_name
from sale.customer c 
full JOIN sale.orders o  on c.customer_id = o.customer_id
FULL JOIN sale.order_item oi on o.order_id = oi.order_id
full   JOIN product.product p on oi.product_id = p.product_id

SELECT * FROM sales_info

-------------------*****************-----------------------


SELECT p.product_name
from sale.customer c 
INNER JOIN sale.orders o  on c.customer_id = o.customer_id
inner   JOIN sale.order_item oi on o.order_id = oi.order_id
INNER   JOIN product.product p on oi.product_id = p.product_id
WHERE c.city = 'Charlotte'
UNION ALL 
SELECT p.product_name
from sale.customer c 
INNER JOIN sale.orders o  on c.customer_id = o.customer_id
inner  JOIN sale.order_item oi on o.order_id = oi.order_id
inner   JOIN product.product p on oi.product_id = p.product_id
WHERE c.city = 'Aurora'





SELECT p.product_name
from sale.customer c 
INNER JOIN sale.orders o  on c.customer_id = o.customer_id
inner   JOIN sale.order_item oi on o.order_id = oi.order_id
INNER   JOIN product.product p on oi.product_id = p.product_id
WHERE c.city = 'Charlotte'
UNION  
SELECT p.product_name
from sale.customer c 
INNER JOIN sale.orders o  on c.customer_id = o.customer_id
inner  JOIN sale.order_item oi on o.order_id = oi.order_id
inner   JOIN product.product p on oi.product_id = p.product_id
WHERE c.city = 'Aurora'

----- UNION ALL / UNION /// IN 

SELECT DISTINCT p.product_name
	FROM sale.customer c, sale.orders o, sale.order_item oi, product.product p
	WHERE c.customer_id=o.customer_id
		AND o.order_id=oi.order_id
		AND oi.product_id=p.product_id
		AND c.city IN ('Aurora', 'Charlotte') ;


SELECT p.product_name
from sale.customer c 
full JOIN sale.orders o  on c.customer_id = o.customer_id
FULL JOIN sale.order_item oi on o.order_id = oi.order_id
full   JOIN product.product p on oi.product_id = p.product_id
WHERE c.city in('Aurora','Charlotte')

SELECT *
 FROM product.brand

---Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')
SELECT first_name FROM sale.customer
        WHERE first_name = 'Thomas'
UNION ALL
SELECT last_name FROM sale.customer
        WHERE last_name = 'Thomas';

SELECT *
 from product.brand

SELECT brand_id
FROM product.product
WHERE model_year = 2018

INTERSECT
SELECT brand_id
FROM product.product
WHERE model_year = 2020


SELECT brand_name
FROM product.brand 
WHERE brand_id IN(
        SELECT brand_id
        FROM product.product
        WHERE model_year = 2018

        INTERSECT
        SELECT brand_id
        FROM product.product
        WHERE model_year = 2020)

with t1 as (
SELECT brand_id
        FROM product.product
        WHERE model_year = 2018

        INTERSECT
        SELECT brand_id
        FROM product.product
        WHERE model_year = 2020)

        -- QUESTION: Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.


SELECT first_name, last_name
 FROM sale.customer
 WHERE customer_id IN(

                        SELECT customer_id
                        FROM sale.orders
                        where YEAR(order_date) = 2018
                        INTERSECT
                        SELECT customer_id
                        FROM sale.orders
                        where YEAR(order_date) = 2019
                        INTERSECT
                        SELECT customer_id
                        FROM sale.orders
                        where YEAR(order_date) = 2020)

                        /*(CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir.
Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir.
CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.






:alarma:Bir tabloda meydana gelen sonucu başka bir tablo veya işlem için kullanmak için 3 yöntem:
 Subqueries
 Views
Common Table Expression (CTE's)*/

SELECT * 
from product.brand

SELECT brand_id
from product.product
 WHERE model_year = 2018
EXCEPT
SELECT brand_id 
from product.product
 WHERE model_year = 2019


SELECT brand_id, brand_name

 FROM product.brand
 WHERE brand_id IN(
        SELECT brand_id
        from product.product
        WHERE model_year = 2018
        EXCEPT
        SELECT brand_id 
        from product.product
        WHERE model_year = 2019)



-- QUESTION: Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)

SELECT * 
from   sale.orders
WHERE year(order_date) = 2019


SELECT product_name 
FROM product.product
WHERE product_id in(
                    SELECT oi.product_id
                    from   sale.orders o 
                    INNER JOIN sale.order_item oi on o.order_id = oi.order_id
                    WHERE year(order_date) = 2019
                    EXCEPT
                    SELECT oi.product_id
                    from   sale.orders o 
                    INNER JOIN sale.order_item oi on o.order_id = oi.order_id
                    WHERE year(order_date) <> 2019)




---- case

SELECT order_id, order_status
CASE order_status
    WHEN 1 THEN 'Pending'
    WHEN 2 THEN 'Processing'
    WHEN 3 THEN 'Rejected'
    WHEN 4 THEN 'Completed'
END order_status
from sale.orders

SELECT order_id, order_status,
    CASE 
        WHEN order_status = 1 THEN 'Pending'
        WHEN order_status = 2 THEN 'Processing'
        WHEN order_status = 3 THEN 'Rejected'
        WHEN order_status = 4 THEN 'Completed'
        ELSE 'Unknown'
    END order_status_description
FROM sale.orders;



SELECT email , first_name, 
CASE 
WHEN email LIKE '%@gmail.%' THEN 'Gmail'
WHEN email LIKE '%@hotmail.%' THEN 'Hotmail'
WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'

WHEN email is not null THEN 'other'
END as email_service
FROM sale.customer


-- QUESTION: Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.
-- (Aynı siparişte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariş veren müşterileri bulunuz)


SELECT *
FROM product.brand

SELECT *
FROM product.category

SELECT * 
FROM sale.order_item

SELECT * 
FROM sale.orders




SELECT c.customer_id, c.first_name, c.last_name, o.order_id, p.product_name, ca.category_name
    CASE WHEN ca.category_name = 'speakers' THEN 1 ELSE 0 END as spe ,
    CASE WHEN ca.category_name = 'Computer Accessories' THEN 1 ELSE 0 END as ca ,
    CASE WHEN ca.category_name = 'mp4 player' THEN 1 ELSE 0 END as mp4
FROM sale.customer c 
INNER JOIN sale.orders  o on c.customer_id = o.customer_id 
INNER JOIN sale.order_item oi on o.order_id = oi.order_id
INNER JOIN product.product p on oi.product_id = p.product_id
INNER JOIN product.category ca on p.category_id = ca.category_id


SELECT C.customer_id, first_name, last_name, A.order_id
FROM sale.order_item A, sale.orders B, sale.customer C, product.product D, product.category E
WHERE A.order_id = B.order_id
    AND C.customer_id = B.customer_id
    AND D.product_id = A.product_id
    AND E.category_id = D.category_id
    AND E.category_name IN ('computer accessories', 'speakers', 'mp4 player')
GROUP BY C.customer_id, first_name, last_name, A.order_id
HAVING COUNT(DISTINCT E.category_name) = 3;
