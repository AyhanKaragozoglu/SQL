-- SQL session 4 16/01/2023 join 

SELECT * from product.product
SELECT * from product.category

SELECT * FROM product.product 
INNER JOIN product.category 
    on product.product.category_id = product.category.category_id
    
    SELECT * FROM product.product a
INNER JOIN product.category b
    on a.category_id = b.category_id


   SELECT a.product_id, a.product_name, a.category_id, a.category_name from product.product

INNER JOIN product.product
    on a.category_id = b.category_id

    SELECT * FROM product.product
SELECT * FROM product.category

SELECT *
FROM product.product A -- BU KULLANIMDA AS YERİNE İSTEDİĞİMİZ HARFİ KULLANIYORUZ ON SATIRINDA KALABALIK OLMASIN DİYE
INNER JOIN product.category B
	ON A.category_id=B.category_id

	SELECT A.product_id,A.product_name,A.category_id,B.category_name  -- İSTEDİĞİMİZ SÜTUNLARI GETİREBİLİRZ.
FROM product.product A -- BU KULLANIMDA AS YERİNE İSTEDİĞİMİZ HARFİ KULLANIYORUZ ON SATIRINDA KALABALIK OLMASIN DİYE
INNER JOIN product.category B
	ON A.category_id=B.category_id


SELECT a.product_id, a.product_name, a.category_id, b.category_id, b.category_name 
from product.product a , product.category b
 WHERE a.category_id = b.category_id



 SELECT * 
 from sale.staff a
 INNER JOIN sale.store b on a.store_id = b.store_id 

  SELECT a.first_name, a. last_name, b. store_name 
 from sale.staff a
 INNER JOIN sale.store b on a.store_id = b.store_id 

 --How many employees are in each store?

  SELECT b.store_name COUNT(a.staff_id)
 from sale.staff a
 INNER JOIN sale.store b on a.store_id = b.store_id 
GROUP by b.store_name
;
 SELECT COUNT(B.store_id)
FROM sale.store A
INNER JOIN sale.staff B
    ON A.store_id = B.store_id
GROUP BY A.store_id


SELECT b.store_name , COUNT(a.staff_id)
from sale.staff a 
INNER JOIN sale.store b on a.store_id = b.store_id
GROUP by b.store_name


---left join


SELECT * FROM product.product
SELECT * FROM sale.order_item

SELECT COUNT(distinct product_id )  FROM sale.order_item



SELECT a.product_id, a.product_name, b.order_id
from product.product a
LEFT JOIN sale.order_item b on a.product_id = b.product_id
WHERE b.order_id IS NULL


SELECT a.staff_id, a.first_name, a.last_name, c.quantity, c.order_id
FROM sale.staff a  
LEFT JOIN sale.orders b on a.staff_id = b.staff_id
LEFT JOIN sale.order_item c on b.order_id = c.order_id


SELECT a.staff_id, sum(c.quantity)
FROM sale.staff a  
LEFT JOIN sale.orders b on a.staff_id = b.staff_id
LEFT JOIN sale.order_item c on b.order_id = c.order_id
GROUP by a.staff_id 

SELECT a.staff_id, isnull(sum(c.quantity), 0) -- barchart çizdirmek için null değerler 0 ile değiştirildi 
FROM sale.staff a  
LEFT JOIN sale.orders b on a.staff_id = b.staff_id
LEFT JOIN sale.order_item c on b.order_id = c.order_id
GROUP by a.staff_id 

SELECT a.staff_id, coalesce(sum(c.quantity), 0)
FROM sale.staff a  
LEFT JOIN sale.orders b on a.staff_id = b.staff_id
LEFT JOIN sale.order_item c on b.order_id = c.order_id
GROUP by a.staff_id 

SELECT A.staff_id, SUM(C.quantity)
FROM sale.staff A
LEFT JOIN SALE.orders B 
	ON  A.staff_id = B.staff_id
LEFT JOIN sale.order_item C 
	ON B.order_id= C.order_id
GROUP BY A.staff_id  -- BURDA ÇIKAN NULL 0 ANLAMINDA HİÇ SATIŞ YAPMAMIŞ.

--NULLLARI 0 LA DEĞİŞTİR

SELECT A.staff_id,	ISNULL(SUM(C.quantity),0)  -- İSNULL YERİNE COALESCE KULLANILIRDI.
FROM sale.staff A
LEFT JOIN SALE.orders B 
	ON  A.staff_id = B.staff_id
LEFT JOIN sale.order_item C 
	ON B.order_id= C.order_id
GROUP BY A.staff_id 
ORDER BY A.staff_id


-- satış yapamayan elemanları göremiyoruz

SELECT a.staff_id, coalesce(sum(c.quantity), 0) 
FROM sale.staff a  
INNER JOIN sale.orders b on a.staff_id = b.staff_id
INNER JOIN sale.order_item c on b.order_id = c.order_id
GROUP by a.staff_id 


--- RIGHT JOIN

SELECT a.staff_id, coalesce(sum(c.quantity), 0) 
FROM sale.staff a  
RIGHT JOIN sale.orders b on a.staff_id = b.staff_id
RIGHT JOIN sale.order_item c on b.order_id = c.order_id
GROUP by a.staff_id 


SELECT a.product_id, a.product_name, b.order_id

from sale.order_item b 
RIGHT JOIN product.product a on a.product_id = b.product_id
WHERE b.order_id IS NULL

---- full OUTER JOIN
SELECT * FROM product.stock ORDER by store_id , product_id


SELECT p.product_id , sum(s.quantity) 
from product.product p 
FULL OUTER  JOIN product.stock s 
on p.product_id = s.product_id
 GROUP by p.product_id;



/*Cross join, birinci tabloda yer alan her bir kaydı ikinci tabloda yer alan 
her bir kayıt ile ilişkilendirerek satırlar türetmede kullanılır.*/


-- cross join

SELECT *
FROM product.stock


SELECT product_id
FROM product.stock


SELECT p.product_id, s.store_id, 0 as quantity

FROM product.product p 
CROSS JOIN sale.store s 
WHERE p.product_id not  in(SELECT product_id
FROM product.stock)


SELECT *
FROM product.stock

SELECT S.store_id,P.product_id
FROM product.product P
CROSS JOIN sale.store S  -- 520 SATIRIN HEPSİNİ DİĞER 3 SATIR İLE ÇARPTI


SELECT S.store_id,P.product_id, 0 as quantity
FROM product.product P
CROSS JOIN sale.store S 
WHERE P.product_id NOT IN (SELECT product_id    FROM product.stock)


SELF JOIN

SELECT * FROM sale.staff

SELECT a.staff_id, a.first_name, b.first_name + ' ' + b.last_name as manager_name
FROM sale.staff a 
LEFT JOIN sale.staff b on a.manager_id = b.staff_id

SELECT * FROM sale.staff

SELECT a.staff_id, a.first_name, b.first_name + ' ' + b.last_name as manager_name
FROM sale.staff a 
LEFT JOIN sale.staff b on a.manager_id = b.staff_id 

---- VIEW 
/*Subquery'ler, CTE (Common Table Expression)'lar, VIEW'ler hep aynı amaca hizmet ediyor. Tablolarla daha rahat çalışmamızı sağlıyorlar.
AVANTAJLARI:
Performans + Simplicity + Security + Storage
Tek bir tabloda yapacağımız işlemleri aşamalara bölerek yapmamızı sağlıyor. Bu da hızımızı arttırıyor.(Performans)
VIEW ile aynı tablo gibi oluşturuyoruz ve bu VIEW'a kimleri erişebileceğini belirleyebiliyoruz. bu da security sağlıyor.
VIEW'ların kullanımı da, oluşturması da basittir. Büyük tablonun içerisinde biz bir kısım ilgilendiğimiz verileri alıp, daraltılmış tablolarla sonuca gitmeye çalışıyoruz. (Simplicity)
VIEW'lar çok az yer kaplar. çübkü asıl tablonun bir görüntüsüdür.(Storage)*/



CREATE OR ALTER VIEW vw_customer_product AS
SELECT a.customer_id, a.first_name, a.last_name, b.order_id, c.product_id, c.quantity
FROM sale.customer a 
LEFT JOIN sale.orders b on a.customer_id = b.customer_id
LEFT JOIN sale.order_item c  on b.order_id = c.order_id

SELECT * from vw_customer_product

/*Ana tablodan query ile elde edildiği için, ana tablo güncellendikçe VIEW' da otomatik olarak güncellenir!!
Eğer siz bunu tablo olarak create etmiş olsaydınız; ana tablodan verileri çekip ekstradan bir tablo kaydetmiş olacaktınız.
Ve ana tablodaki değerler güncellendiğinde bu tablo GÜNCELLENMEMİŞ olacaktı. yani tablo create etmek maliyetli bir işlemdir.*/

EXEC sp_helptext vw_customer_product

ALTER VIEW vw_customer_product AS
SELECT a.customer_id, a.first_name, b.order_id, c.product_id, c.quantity
FROM sale.customer a 
LEFT JOIN sale.orders b on a.customer_id = b.customer_id
LEFT JOIN sale.order_item c  on b.order_id = c.order_id


 DROP VIEW vw_customer_product

 /*
 What are the advantages?
It acts like a table, so most things you'd do with a table will work with a view
if you're doing user level access control, you can give a user access to a view without giving them access to the tables behind it
It allows you to keep the logic centralized, rather than repeating it in your code
It can allow for massive performance improvements
What are the disadvantages?
If done wrong, it can result in performance issues
You may not be able to update the view, forcing you back to the original tables
A view is one more moving piece that has to be maintained*/

