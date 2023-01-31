
--Weekly_Agenda_17_Student.sql


----1. Select the least 3 products in stock according to stores.
		--Maðazalara göre stokta bulunan en az 3 ürünü seçin.

select top 3 store_id, product_name , sum(quantity) as amount
from product.stock s
join product.product p
on s.product_id = p.product_id

group by store_id, product_name 
order by amount asc;
----2. Return the average number of sales orders in 2020 sales
		--2020 satýþlarýndaki ortalama satýþ sipariþi sayýsýný getirin
select  YEAR(o.order_date), AVG(oi.quantity ) amount
--over(partition by  YEAR(o.order_date))
from sale.orders o
join sale.order_item oi 
on o.order_id = oi.order_id
where YEAR(o.order_date) = 2020
group by  YEAR(o.order_date)






----3. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.
		--Her markadaki liste fiyatýna göre her ürüne bir sýralama atayýn ve sýralamasý üçten küçük veya ona eþit olan ürünleri alýn.

		select p.product_name, p.list_price

		from 
		[product].[product] p


		where p.list_price <= 3




----4. Write a query that returns the highest daily turnover amount for each week on a yearly basis.
		--Yýllýk bazda her hafta için en yüksek günlük ciro miktarýný döndüren bir sorgu yazýn.
		select YEAR(o.order_date) years ,DATEPART(week,o.order_date) weeks, cast(SUM(oi.quantity * oi.list_price* (1-oi.discount))as numeric(18,2)) net_price
		from sale.orders o
		join sale.order_item oi
		on o.order_id = oi.order_id
		group by YEAR(o.order_date)


		WITH cte AS(
	SELECT
		DISTINCT
		DATEPART(YEAR, a.order_date) order_year,
		DATEPART(WEEK, a.order_date) order_week,
		DATEPART(day,a.order_date) order_day,
		SUM(b.quantity * b.list_price * (1-b.discount)) OVER(PARTITION BY a.order_date) daily_turnover
	FROM
		sale.orders a
		LEFT JOIN
		sale.order_item b ON a.order_id=b.order_id
)
SELECT
	DISTINCT
	order_year,order_week,order_day,
	MAX(daily_turnover) OVER(PARTITION BY order_year, order_week) highest_turnover
FROM
	cte
-----with group by
SELECT
	DISTINCT
	YEAR(a.order_date) order_year,
	DATEPART(ISOWW, a.order_date) order_week,
	FIRST_VALUE(SUM(b.quantity * b.list_price * (1-b.discount))) OVER(
			PARTITION BY YEAR(a.order_date), DATEPART(ISOWW, a.order_date)
			ORDER BY SUM(b.quantity * b.list_price * (1-b.discount)) DESC) highest_turnover
FROM
	sale.orders a
	LEFT JOIN
	sale.order_item b ON a.order_id=b.order_id
GROUP BY a.order_date


-------

SELECT
	DISTINCT
	YEAR(a.order_date) order_year,
	DATEPART(WEEK, a.order_date) order_week,
	FIRST_VALUE(SUM(b.quantity * b.list_price * (1-b.discount))) OVER(
			PARTITION BY YEAR(a.order_date), DATEPART(ISOWW, a.order_date)
			ORDER BY SUM(b.quantity * b.list_price * (1-b.discount)) DESC) highest_turnover
FROM
	sale.orders a
	LEFT JOIN
	sale.order_item b ON a.order_id=b.order_id
GROUP BY a.order_date

------
SELECT
	DISTINCT
	YEAR(a.order_date) order_year,
	DATEPART(WEEK, a.order_date) order_week,
	max(SUM(b.quantity * b.list_price * (1-b.discount))) OVER(
			PARTITION BY YEAR(a.order_date), DATEPART(ISOWW, a.order_date))
			--ORDER BY SUM(b.quantity * b.list_price * (1-b.discount)) DESC) highest_turnover
FROM
	sale.orders a
	LEFT JOIN
	sale.order_item b ON a.order_id=b.order_id
GROUP BY a.order_date

----5. Write a query that returns the cumulative distribution of the list price in product table by brand.
		--Ürün tablosundaki liste fiyatýnýn marka bazýnda kümülatif daðýlýmýný veren bir sorgu yazýnýz.
		SELECT
	brand_id, list_price,
	ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price), 3) cume_distr
FROM
	product.product




----6. Write a query that returns the relative standing of the list price in the product table by brand.
		--Ürün tablosundaki liste fiyatýnýn markaya göre göreli durumunu döndüren bir sorgu yazýn.


SELECT
	brand_id, list_price,
	FORMAT(ROUND(PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price), 3), 'P') percent_rnk
FROM
	product.product



----7. Divide customers into 5 groups based on the quantity of product they order.
		--Müþterileri sipariþ ettikleri ürün miktarýna göre 5 gruba ayýrýn.





----8. List customers whose have at least 2 consecutive orders are not shipped.
		--. Arka arkaya en az 2 sipariþi sevk edilmeyen müþterileri listeleyin.