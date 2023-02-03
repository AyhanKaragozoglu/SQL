--RDB&SQL E-Commerce Data Analysis Project (DS 13/22 EU)

USE ecommerce;

--E-Commerce Data and Customer Retention Analysis with SQL

/*An e-commerce organization demands some analysis of sales and shipping processes. 
Thus, the organization hopes to be able to predict more easily the opportunities and threats for the future.
Acording to this scenario, You are asked to make the following analyzes consistant with following the instructions given.
*/
    /*Introduction
- You have to create a database and import into the given csv file. (You should research how to import a .csv file)
- During the import process, you will need to adjust the date columns. You need to carefully observe the data types and how they should be.
*/
SELECT *
FROM dbo.e_commerce_data

SELECT YEAR(Order_Date)
FROM dbo.e_commerce_data

SELECT month(Order_Date)
FROM dbo.e_commerce_data

SELECT day(Order_Date)
FROM dbo.e_commerce_data

/*
- The data are not very clean and fully normalized. However, they don't prevent you from performing the given tasks.
- Manually verify the accuracy of your analysis.
*/
--Analyze the data by finding the answers to the questions below:

--1. Find the top 3 customers who have the maximum count of orders.

SELECT   DISTINCT Cust_ID
FROM e_commerce_data;


SELECT TOP 3  Cust_ID, count(Order_Quantity) as maximum_count_of_orders 
FROM e_commerce_data
GROUP by Cust_ID 
ORDER by maximum_count_of_orders  desc;


--2. Find the customer whose order took the maximum time to get shipping.

SELECT top 1 Cust_ID , MAX(DaysTakenForShipping) 
FROM e_commerce_data 
GROUP by Cust_ID
ORDER by MAX(DaysTakenForShipping) DESC;

-------------
SELECT top 1 DATEDIFF(day,Order_Date,Ship_Date) maximum_time
FROM e_commerce_data 
ORDER by maximum_time desc ;


SELECT *
FROM e_commerce_data
WHERE Cust_ID = 'Cust_1460'

--3. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
SELECT distinct Ord_ID
FROM e_commerce_data

SELECT count(distinct Cust_ID ) counts_customer,MONTH(Order_Date), DATENAME(month,Order_Date) as month
FROM e_commerce_data 
WHERE
  EXISTS (
    SELECT  Cust_ID
    FROM e_commerce_data
    WHERE MONTH(Order_Date) = 1  
    AND YEAR(Order_Date)=2011
	)
GROUP BY MONTH(Order_Date), datename(month,Order_Date) 
Order by month;

SELECT distinct Ord_ID,YEAR(Order_Date)
 FROM e_commerce_data 
 WHERE YEAR(Order_Date) = 2011


--4. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.


select Cust_ID,
	first_value(Order_Date) over(partition by YEAR(Order_Date), MONTH(Order_Date) order by Cust_ID)
from e_commerce_data
order by 1

select Cust_ID,  YEAR(order_date) years, MONTH(Order_Date) months,
	first_value(Order_Date) over(partition by YEAR(Order_Date), MONTH(Order_Date) order by Cust_ID)
from e_commerce_data
order by 1

SELECT	Cust_ID, Order_Date,
		ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS first_purchasing
FROM	e_commerce_data
GROUP BY Cust_ID, Order_Date

SELECT	Cust_ID, Order_Date,
		ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS Third_purchasing
FROM	e_commerce_data
GROUP BY Cust_ID, Order_Date


SELECT *, DATEDIFF(day, F.First_Purchase, T.Third_Purchase) AS ElapsedTimeFirstThird
FROM
(
SELECT	A.Cust_ID, A.Order_Date AS First_Purchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS Row#,
		Cust_ID,
		Order_Date
		FROM	e_commerce_data
		) AS A
WHERE	A.Row# = 1
) AS F,
(
SELECT	A.Cust_ID, A.Order_Date AS Third_Purchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS Row#,
		Cust_ID,
		Order_Date
		FROM	e_commerce_data
		) AS A
WHERE	A.Row# = 3
) AS T
WHERE	F.Cust_ID = T.Cust_ID
;

--5. Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.


SELECT distinct Customer_Name
FROM e_commerce_data 
WHERE Prod_ID = 'Prod_11' 
intersect

SELECT distinct Customer_Name
FROM e_commerce_data 
WHERE Prod_ID = 'Prod_14' 


SELECT *
FROM	e_commerce_data
WHERE Cust_ID IN
(
SELECT	DISTINCT Cust_ID
FROM	e_commerce_data
WHERE	Prod_ID = 'prod_11'
INTERSECT
SELECT	DISTINCT Cust_ID
FROM	e_commerce_data
WHERE	Prod_ID = 'prod_14'
)
ORDER BY Cust_ID


SELECT	DISTINCT Cust_ID, 
		COUNT(Prod_ID) OVER (PARTITION BY Cust_ID ORDER BY Cust_ID) AS Total_Product_Purchased,
		ROUND((2.0/(COUNT(Prod_ID) OVER (PARTITION BY Cust_ID ORDER BY Cust_ID))), 3) AS Ratio
FROM	e_commerce_data
WHERE Cust_ID IN
(
SELECT	DISTINCT Cust_ID
FROM	e_commerce_data
WHERE	Prod_ID= 'prod_11'
INTERSECT
SELECT	DISTINCT Cust_ID
FROM	e_commerce_data
WHERE	Prod_ID = 'prod_14'
)



--Customer Segmentation

---Categorize customers based on their frequency of visits. The following steps will guide you. If you want, you can track your own way.

--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

create or alter view vw_customers_visit
as
select Cust_ID, YEAR(Order_Date) years, MONTH(Order_Date) months
from e_commerce_data
group by Cust_ID, YEAR(Order_Date) , MONTH(Order_Date) 

--2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)

create or alter view vw_customers_visit_month
as
select Cust_ID, YEAR(Order_Date) years, DATENAME(month,order_date) months, count(MONTH(Order_Date)) count_months
from e_commerce_data
group by Cust_ID, YEAR(Order_Date)  ,DATENAME(month,order_date)
order by YEAR(Order_Date)


--3. For each visit of customers, create the next month of the visit as a separate column.


select Cust_ID, YEAR(Order_Date) years, count(MONTH(Order_Date)) count_months
from e_commerce_data
group by Cust_ID, YEAR(Order_Date)  
order by YEAR(Order_Date)


create or alter view vw_next_visit 
as

SELECT	*,
		LEAD(CURRENT_MONTH, 1) OVER (PARTITION BY Cust_ID ORDER BY Current_Month) Next_Visit_Month
FROM
	(SELECT *,
	DENSE_RANK() OVER(ORDER BY [years] , [months]) Current_Month
	FROM vw_customers_visit_month) t1


--4. Calculate the monthly time gap between two consecutive visits by each customer.

CREATE or ALTER VIEW time_gap As 

SELECT Cust_ID, Order_Date, 
s_order , 
DATEDIFF(MONTH,Order_Date,s_order) time_gap
FROM
	(SELECT  Cust_ID, 
          Order_Date,	
          MIN(Order_date) over(Partition by Cust_ID) first_order_date,	 
          lead(Order_Date, 1) over(partition by cust_ID order by order_date) s_order,
          DENSE_RANK() over(Partition by Cust_ID order by order_date) order_dates
  FROM e_commerce_data
	) T
WHERE DATEDIFF(MONTH,Order_Date,s_order) >0

select *
from time_gap

--5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.

SELECT Cust_ID, 
        AVG(time_gap) avg_time_gap
FROM time_gap
GROUP BY Cust_ID 
order by  avg_time_gap


SELECT Cust_ID, 
      avg_time_gap,
      CASE  WHEN avg_time_gap = 1 THEN 'periodic'
            WHEN avg_time_gap >= 2 and avg_time_gap < 5 THEN 'regular'
			WHEN avg_time_gap >= 5 and avg_time_gap < 10 THEN 'irregular'
			 WHEN avg_time_gap >= 10  THEN 'sometimes'
            ELSE 'UNKNOWN' 
            END customer_categorise
FROM (
     SELECT Cust_ID, 
        AVG(time_gap) avg_time_gap
      FROM time_gap
      GROUP BY Cust_ID 
) t1
order by avg_time_gap;




--For example:
/*o Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
o Labeled as regular if the customer has made a purchase every month. Etc.*/



--Month-Wise Retention Rate
--Find month-by-month customer retention ratei since the start of the business.
--There are many different variations in the calculation of Retention Rate. But we will try to calculate the month-wise retention rate in this project.
--So, we will be interested in how many of the customers in the previous month could be retained in the next month.
--Proceed step by step by creating “views”. You can use the view you got at the end of the Customer Segmentation section as a source.


--1. Find the number of customers retained month-wise. (You can use time gaps) 

select Cust_ID,  COUNT(Order_Date) month_wise
from time_gap
where time_gap = 1
group by Cust_ID



--2. Calculatethemonth-wiseretentionrate.

WITH customer_visits AS (
    SELECT 
        Cust_ID, 
        Year(Order_Date) AS Year, 
        Month(Order_Date) AS Month,
        COUNT(DISTINCT Order_Date) AS Visits
    FROM e_commerce_data
    GROUP BY Cust_ID, Year(Order_Date), Month(Order_Date)
),
monthly_retention AS (
    SELECT 
        Year,
        Month,
        COUNT(Cust_ID) AS Total_Customers,
        COUNT(CASE WHEN Visits > 1 THEN 1 ELSE NULL END) AS Retained_Customers
    FROM customer_visits
    GROUP BY Year, Month
)
SELECT 
    Year,
    Month,
   1.0 * Retained_Customers / Total_Customers AS Retention_Rate
FROM monthly_retention
ORDER BY Year, Month;

--Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month
--If you want, you can track your own way.

