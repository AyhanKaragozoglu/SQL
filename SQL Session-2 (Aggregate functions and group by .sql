-- SQL SESSİON-2 12.01.2023 AGGREGATE FUNCTION AND GROUP BY CLAUSE

/* ORDER OPERATIONS:
 1. FROM
 2. JOIN
 3. WHERE
 4. GROUP BY
 5. HAVING 
 6. SELECT
 7. DISTINCT
 8. ORDER BY
 9. TOP N
 */

 -- COUNT 


    SELECT *
    FROM product.product

    SELECT COUNT(product_id) as num_of_product
    FROM product.product


 SELECT COUNT(*) as num_of_product
    FROM product.product

    SELECT COUNT(1)
    FROM product.product
    ---------------
--bad practise
SELECT COUNT(1)
FROM product.product;

SELECT COUNT('clarusway')
FROM product.product;

SELECT 1

SELECT product_name,1
FROM product.product;
----------------------

SELECT *
FROM sale.customer

SELECT COUNT(phone)
FROM sale.customer

SELECT COUNT(*)
FROM sale.customer
-- How many records have a null value in the phone column?
    SELECT COUNT(*)
FROM sale.customer
WHERE phone IS NULL

  SELECT COUNT(phone)
FROM sale.customer
WHERE phone IS NULL


-- How many customers are located in NY state?
  SELECT COUNT(*)
FROM sale.customer 
WHERE [state] = 'NY'

  SELECT COUNT(customer_id) AS NUM_OF_CUS
FROM sale.customer 
WHERE [state] = 'NY'

-- COUNT DISTINCT

SELECT COUNT(distinct city )
FROM[sale].[customer]


-- MİN MAX 

--What are the minimum and maximum model years of products?
SELECT min(model_year), MAX(model_year)
from product.product


--What are the min and max list prices for category id 5?
SELECT min(list_price), MAX(list_price)
from product.product 
WHERE category_id = 5


SELECT MAX(list_price)
from product.product 
WHERE category_id = 5


SELECT MAX(list_price)
from product.product 
WHERE category_id = 5

SELECT top 1 list_price as maxprice
from product.product 
WHERE category_id = 5 ORDER by list_price DESC

--SUM
--What is the total list price of the products that belong to category 6?


SELECT SUM(list_price)
from product.product 
WHERE category_id = 6 

--How many product sold in order_id 45?
SELECT *
from sale.order_item
WHERE order_id = 45


-- AVG 

/* Birden fazla satıra işlem yapan AVG, SUM, COUNT vs. kullanırken önüne bir sütun ismi yazmıyoruz. 
Çünkü yazarsak o sütunun bir satırına karşılık değer geleceği için tek satırı alır. 
Örnek; COUNT tek satır sonuç döndürdüğü için önüne yazacağın sütun için tek satırı alır. 
Aggragate fonsiyon kullanırken buna dikkat et. Ama MIN, MAX’ın önüne sütun ismi girebilirsin.*/


--What is the avg list price of the 2020 model products?
--float
SELECT * 
FROM product.product
WHERE model_year = 2020

SELECT AVG(list_price)
FROM product.product
WHERE model_year = 2020

SELECT AVG(quantity*1.0)
FROM sale.order_item
WHERE product_id=130
SELECT *
FROM sale.order_item 
WHERE product_id = 130 

SELECT AVG(quantity)
FROM sale.order_item 
WHERE product_id = 130 

/*Aggregate fonksiyonları yalnızca bir veri üretir. SUM ve AVG, yalnızca integer değerlere uygulanır.
:alarma: COUNT *, NULL dahil tüm satırları sayar.
COUNT (colum_name) şeklinde sütun ismi girilirse NULL’lar hariç satırları sayar.
:alarma:COUNT * hariç diğer hepsi (min, max vs.) Null ları göz ardı eder. Zaten MIN, MAX vs. de * ile kullanma şekli yok.
:heavy_check_mark:
4

New

:alarma:WHERE’i Aggregate fonksiyonundan önce çalıştırır ki önce sınırlayıp, sınırlanmış veriye fonksiyon işlemi uygulansın. Böylece sistemi yormamış oluyor.
GROUP BY da WHERE’den sonra çalıştırılıyor. Aynı nedenden dolayı. (edited) 

Yani hep WHERE önce!!?*/




SELECT SUM(quantity)
from sale.order_item
WHERE order_id = 45


-- SELECT’teki nonaggregate ifade (column_1), GROUP BY cümlesinde olmalı!!! 
--Yani neyi GROUP BY’ın yanına yazıp grupluyor isek aynen onu SELECT’in yanına yapıştır.

/* :alarma: Hatırlayın biz EDA yaparken hep verimizi gruplayıp bir aggregate uyguluyorduk. Çünkü genellikle verimizi kategorilere göre analiz etmek isteriz.
SQL'de, tıpkı Pandas'ın groupby() metodunda olduğu gibi GROUP BY ifadesi; aynı kategori value'suna sahip satırları özet satırlarında gruplandırır. 
Böylece daha iyi analiz için veriyi ayrı gruplara bölüp hesaplama yapabiliyoruz.*/

------------------------------------------------
--- GROUP BY 
----------------------------------------------
/* df.groupby("company")[[quantity]].mean()
--==
--SELECT company AVG(quantity) FROM bla-bla GROUPBY company;*/

SELECT *
FROM product.product

SELECT DISTINCT model_year 
FROM product.product
GROUP BY model_year

--count 


--How many products are in each model year?
SELECT model_year, COUNT(product_id)
FROM product.product 
GROUP by model_year


--Write a query that returns the number of products priced over $1000 by brands.

SELECT brand_id, COUNT(product_id) most_expensive
FROM product.product 
WHERE list_price > 1000
GROUP by brand_id 
ORDER by COUNT(product_id) DESC;

SELECT brand_id, COUNT(product_id) most_expensive
FROM product.product 
WHERE list_price > 1000
GROUP by brand_id 
ORDER by most_expensive DESC;

SELECT brand_id, COUNT(product_id) most_expensive
FROM product.product 

GROUP by brand_id

SELECT brand_id , COUNT(category_id)
FROM product.product 
GROUP by brand_id

--COUNT DISTINCT WITH GROUP BY

SELECT brand_id , COUNT(distinct category_id)
FROM product.product 
GROUP by brand_id

/* GROUP BY, aggregate function’ı çağırmadan önce sonuçları gruplandırır. Bu, tüm sorgu yerine gruplara aggregate func.  uygulamanıza olanak tanır.
WHERE cümlesi, aggregate’ten önceki veriler üzerinde operasyon yapar (çalışır).
WHERE cümlesi, GROUP BY cümlesinden önce çalışır. Dolayısıyla ana tablomuzun sadece WHERE cümlesindeki şartları sağlayan satırları gruplanır.
ORDER BY, GROUP BY’dan sonra gelir. (Sonucu sıralar.)
Yani ilk önce WHERE şartı uygulanıp data filtrelenir,
sonra üzerine GROUP BY uygulanır,
sonra aggregate function uygulanır.
Son olarak da sonuç ORDER BY a göre sıralanır.
  
(çalışma sütunlarını + koşula göre seç + fonksiyona göre gruplandır + sıralamasını belirle)

SQL'İN KENDİ İÇİNDEKİ İŞLEM SIRASI:

FROM : hangi tablolara gitmem gerekiyor?
WHERE : o tablolardan hangi verileri çekmem gerekiyor?
GROUP BY : bu bilgileri ne şekilde gruplayayım?
SELECT : neleri getireyim ve hangi aggragate işlemine tabi tutayım.
HAVING : yukardaki sorgu sonucu çıkan tablo üzerinden nasıl bir filtreleme yapayım (mesela list_price>1000)
Gruplama yaptığımız aynı sorgu içinde bir filtreleme yapmak istiyorsak HAVING kullanacağız
(HAVING kullanmadan; HAVING'ten yukarısını alıp başka bir SELECT sorgusunda WHERE şartı ile de bu filtrelemeyi yapabiliriz.)
ORDER BY : Çıkan sonucu hangi sıralama ile getireyim?*/

SELECT brand_id, category_id, list_price
FROM product.product
GROUP BY brand_id, category_id


/*  DİKKAT!!!!!!
WHERE ile ana tabloda bir filtreleme yapıyoruz. Ana tablo içinde herhangi bir filtreleme yapmayacaksan WHERE satırı kullanmayacaksın demektir.

ORDER BY, SELECT'ten sonra çalışıyor. Dolayısıyla SELECT'te yazdığım Allias'ı kabul eder!

SELECT satırında yazdığın sütunların hepsi GROUP BY'da olması gerekiyor!

ORDER BY satırındaki ilk parametre (örneğin) 2 ise bu SELECT satırındaki 2. sütuna göre sırala demektir.

HAVING ile ise query ile dönen sonuç üzerinde bir filtreleme yapıyoruz.

HAVING ile sadece aggregate sonucuna bir filtre uyguluyoruz. Dolayısıyla HAVING, GROUP BY ile birlikte kullanılıyor.

HAVING’de kullandığın sütun, aggregate te kullandığın sütunla aynı olmalı.*/

SELECT order_id,product_id, max(list_price)
 FROM sale.order_item

 GROUP BY order_id, product_id
ORDER BY order_id


SELECT *
 FROM sale.order_item


-- min / max

SELECT customer_id, 
    MIN(order_date) firs_order, 
    MAX(order_date) last_order
FROM sale.orders
GROUP by customer_id

SELECT brand_id, 
    MIN(list_price), 
    MAX(list_price) 
FROM product.product
GROUP by brand_id 


--- AVG 

SELECT * 
FROM sale.order_item

SELECT order_id, 
SUM(quantity * list_price * discount ) total_amount
FROM sale.order_item
 GROUP by order_id

SELECT order_id, list_price,
SUM(quantity * list_price * (1-discount)) total_amount
FROM sale.order_item
WHERE order_id = 1  AND product_id = 8
GROUP by order_id, list_price


SELECT order_id, list_price*2,
	SUM(quantity * list_price * (1-discount)) total_amount,
	SUM(quantity * list_price * discount) total_amount
FROM sale.order_item
WHERE order_id=1 AND product_id=8
GROUP BY order_id, list_price

SELECT order_id, 
	SUM(quantity *list_price ) total,SUM(quantity *list_price * discount) total_amount
FROM sale.order_item
GROUP BY order_id

SELECT order_id, list_price*2,
    SUM(quantity * list_price * (1-discount)) total_amount,
    SUM(quantity * list_price * discount) total_amount
FROM sale.order_item
WHERE order_id = 1 AND product_id = 8
GROUP BY order_id, list_price


---What is the average list price for each model year?
SELECT model_year, AVG(list_price) AS avg_price
FROM product.product
GROUP BY model_year;

--------------------------------------------------- Write a query that returns the most repeated name in the customer table.
SELECT top 1  first_name, COUNT(first_name)
FROM sale.customer
GROUP BY first_name
ORDER by COUNT(first_name)  DESC
 

SELECT TOP 1 first_name ,COUNT(first_name) repeat_time
FROM sale.customer
GROUP BY first_name
ORDER BY repeat_time DESC


-- Find the state where "yandex" is used the most? (with number of users)

SELECT [state] ,COUNT(email)
from sale.customer 
where email LIKE "%yandex%"
SELECT TOP 1 email ,COUNT(email) repeat_time
FROM sale.customer
where email LIKE "%yandex%"
GROUP by [state] 
ORDER by COUNT(email) DESC


SELECT state, COUNT(email)
FROM sale.customer
WHERE email LIKE '%yandex%'
GROUP BY state
ORDER BY COUNT(*) DESC;