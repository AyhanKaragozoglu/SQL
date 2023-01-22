--RDB&SQL Assignment-2 

/*
1. Product Sales
You need to create a report on whether customers who purchased the product named 
'2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

To generate this report, you are required to use the appropriate 
SQL Server Built-in functions or expressions as well as basic SQL knowledge.
*/

select c.customer_id, c.first_name, c.last_name
from product.product p
INNER join sale.order_item oi
        ON p.product_id=oi.product_id
INNER JOIN sale.orders o
        ON oi.order_id=o.order_id
INNER JOIN sale.customer c
        on  o.customer_id=c.customer_id
 WHERE p.product_name='2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
AND EXISTS(    

            select e.customer_id, e.first_name, e.last_name
            from product.product a, sale.order_item b, sale.orders d, sale.customer e
            where a.product_id=b.product_id
                and b.order_id=d.order_id
                and d.customer_id=e.customer_id
                and a.product_name !='Polk Audio - 50 W Woofer - Black') 
                                        

        









/* 
2. Conversion Rate
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.

*/






/*
a.    Create above table (Actions) and insert values, */

CREATE TABLE ECommerce (	Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,	Adv_Type VARCHAR (255) NOT NULL,	Action1 VARCHAR (255) NOT NULL);
INSERT INTO ECommerce (Adv_Type, Action1)VALUES ('A', 'Left'),('A', 'Order'),('B', 'Left'),('A', 'Order'),('A', 'Review'),('A', 'Left'),('B', 'Left'),('B', 'Order'),('B', 'Review'),('A', 'Review');


/*
b.    Retrieve count of total Actions and Orders for each Advertisement Type,*/


SELECT *
FROM ECommerce


SELECT Action1,Adv_Type,
count(Action1) visit
from ECommerce
WHERE Action1 = 'Order'
GROUP by Action1 ,Adv_Type


 

/*
c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
*/
/*
-- CAST Syntax:  
CAST ( expression AS data_type [ ( length ) ] )  
  
-- CONVERT Syntax:  
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

ROUND(numeric_expression , length [ ,function ])
*/
SELECT Adv_Type, COUNT(*) adv 
FROM ECommerce
GROUP by Adv_Type


WITH t1 as
(
SELECT Adv_Type,
count(Adv_Type) count_adv
from ECommerce
GROUP by Adv_Type
	), 
    t2  as (
	SELECT Adv_Type,
count(Action1) count_order
from ECommerce
WHERE Action1 = 'Order'
GROUP by Adv_Type 
)

SELECT t1.Adv_Type, CAST (ROUND (1.0 * t2.count_order / t1.count_adv, 2) AS numeric (3,2)) AS Conversion_Rate 
from t1, t2
where t1.Adv_Type = t2.Adv_Type

/*
WITH trn_1 as
(
	select s.store_name, sum(list_price * quantity * (1-discount)) as turnover
	from sale.order_item oi, sale.orders o, sale.store s
	where oi.order_id=o.order_id
		and o.store_id=s.store_id
	group by s.store_name
	), 
trn_2 as
	(select avg(turnover) as avg_trn
	from trn_1)
select * 
from trn_1, trn_2
where trn_1.turnover < trn_2.avg_trn*/