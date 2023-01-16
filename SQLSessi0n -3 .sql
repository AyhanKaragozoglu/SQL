-- SQL Session-3 



SELECT N'قمر'
SELECT CONVERT(VARCHAR, N'قمر')
SELECT CONVERT(NVARCHAR, N'قمر')
SELECT N':grinning:'



-- char vs. varchar
SELECT DATALENGTH(CONVERT(CHAR(50), 'clarusway'))
SELECT DATALENGTH(CONVERT(VARCHAR(50), 'clarusway'))

CREATE TABLE t_date_time (
A_time [time],
A_date [date],
A_smalldatetime [smalldatetime],
A_datetime [datetime],
A_datetime2 [datetime2],
A_datetimeoffset [datetimeoffset]
);

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())



CREATE TABLE t_date_time (
A_time [time],
A_date [date],
A_smalldatetime [smalldatetime],
A_datetime [datetime],
A_datetime2 [datetime2],
A_datetimeoffset [datetimeoffset]
);
INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())
SELECT * FROM t_date_time






CREATE TABLE t_date_time (
A_time [time],
A_date [date],
A_smalldatetime [smalldatetime],
A_datetime [datetime],
A_datetime2 [datetime2],
A_datetimeoffset [datetimeoffset]
);


INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())
SELECT * FROM t_date_time

/*Arkadaşlar CHAR ile VARCHAR arasındaki farkı örnekle pekiştirelim:
Eğer sınırlama yapmazsanız VARCHAR ın 65000 karakter sınırı var. CHAR kullanırsanız 255 karaktere kadar müsaade eder. 
VARCHAR'ı daha büyük doküman yazacaksanız tercih edebilirsiniz.
Aralarındaki fark şu: Diyelim siz CHAR dediniz ve karakter uzunluğunu 200 olarak belirlediniz. 
Ondan sonra siz bir satıra ister 5 karakter girin ister 200 karakter girin CHAR her zaman hafızada 200 karakter yer tutar.
Ama diyelim ki VARCHAR'a 200 değeri girdiniz. Bir satıra 10 karakter yazdınız. 
VARCHAR hafızada girdiğiniz karakter kadar yer kaplar. 200 karakter yer kaplamaz.

*/

SELECT        A_date,
DATENAME(DW, A_date) [weekday],            
DATEPART(DW, A_date) [weekday_2],          
DATENAME(M, A_date) [month],             
DATEPART(month, A_date) [month_2],
DAY (A_date) [day],
MONTH(A_date) [month_3],
YEAR (A_date) [year],
A_time,
DATEPART (minute, A_time) [minute],
DATEPART (NANOSECOND, A_time) [nanosecond]
FROM        t_date_time;


YEAR / YYYY / YY
QUARTER / QQ / Q
MONTH / MM / M
DAYOFYEAR / DY / Y
WEEK / WW / WK
WEEKDAY / DW
DAY / DD / D
HOUR / HH
MINUTE / MI / N
SECOND / SS / S
MILLISECOND / MS
MICROSECOND / MCS
NANOSECOND / NS

SELECT A_date,       
       A_datetime,
       GETDATE() AS [CurrentTime],
       DATEDIFF (DAY, '2020-11-30', A_date) Diff_day,
       DATEDIFF (MONTH, '2020-11-30', A_date) Diff_month,
       DATEDIFF (YEAR, '2020-11-30', A_date) Diff_year,
       DATEDIFF (HOUR, A_datetime, GETDATE()) Diff_Hour,
       DATEDIFF (MINUTE, A_datetime, GETDATE()) Diff_Min
FROM  t_date_time;


select        order_date, shipped_date,
DATEDIFF (DAY, order_date, shipped_date) day_diff,
DATEDIFF (DAY, shipped_date, order_date) day_diff
from        sale.orders
where        order_id = 1;


SELECT	order_date,
		DATEADD(YEAR, 5, order_date), 
		DATEADD(DAY, 5, order_date),
		DATEADD(DAY, -5, order_date)		
FROM	sale.orders
where	order_id = 1

SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())

SELECT	order_date, EOMONTH(order_date) end_of_month,
		EOMONTH(order_date, 2) eomonth_next_two_months
FROM	sale.orders;

SELECT ISDATE('2021-12-02') --2021/12/02 ||| 2021.12.02 ||| 20211202
 
SELECT ISDATE('02/12/2022') --02-12-2022 ||| 02.12.2022


-----CHARINDEX
 
SELECT CHARINDEX('C', 'CHARACTER')
 
SELECT CHARINDEX('C', 'CHARACTER', 2)
 
SELECT CHARINDEX('CT', 'CHARACTER')
 
SELECT CHARINDEX('ct', 'CHARACTER')


--PATINDEX()
 
SELECT PATINDEX('%R', 'CHARACTER')
 
SELECT PATINDEX('R%', 'CHARACTER')
 
SELECT PATINDEX('%[RC]%', 'CHARACTER')
 
SELECT PATINDEX('_H%' , 'CHARACTER')

SELECT PATINDEX('%R', 'CHARACTER')    --9 öncesinde bir şeyler olabilir ama sonrasında olmaz.
SELECT PATINDEX('R%', 'CHARACTER')    --0 sonrasında bir şeyler olabilir ama öncesinde olmaz.
SELECT PATINDEX('%[RC]%', 'CHARACTER')--1 R veya C olsun fark etmez, ilk hangisi geliyorsa onu verir.
SELECT PATINDEX('_H%' , 'CHARACTER')  --1 _H birliktedir. bu pattern hemen CH olarak başta var.

SELECT LEFT ('HASAN',2)


SELECT RIGHT ('HASAN',2)


select LEFT('hasan',2)
SELECT RIGHT('HASAN',3)
SELECT SUBSTRING('HASAN',2,2)


--LEFT / RIGHT

SELECT LEFT('CHARACTER', 5)     --CHARA soldan başlıyor 5 tane getiriyor
SELECT LEFT('CH ARACTER', 5)    --CH AR boşluğu sayar
SELECT RIGHT('CHARACTER', 5)    --ACTER soldan başlıyor 5 tane getiriyor
SELECT RIGHT('CH ARACTER ', 5)  --CTER  boşluğu sayar



--SUBSTRING

SELECT SUBSTRING('CHARACTER', 3, 5)     --ARACT 3ten başlıyor, 5 tane getiriyor
SELECT SUBSTRING('CHARACTER', 0, 5)     -- CHAR 0dan başlıyor, 5 tane getiriyor. boşlukla başlar
SELECT SUBSTRING('CHARACTER', -1, 5)    --  CHA -1den başlıyor, 5 tane getiriyor. boşlukla başlar
SELECT SUBSTRING(888888, 3, 5)          --ERROR sayılarla çalışmıyor.

SELECT UPPER(LEFT('edwin', 1)) +
LOWER(RIGHT('edwin', LEN('edwin') - 1))



SELECT UPPER(LEFT(‘character’,1)) + LOWER(RIGHT(‘character’,LEN(‘character’)-1))




SELECT TRIM('?, ' FROM '   ?SQL Server,') AS TrimmedString;
1:12
SELECT REPLACE('CHARACTER STRING', ' ', '/')
SELECT CAST(12345 AS CHAR)
SELECT CAST(123.95 AS INT)
SELECT CAST(123.95 AS DEC(3,0))


SELECT CAST(12345 AS CHAR)
SELECT CAST(123.95 AS INT)
SELECT CAST(123.95 AS DEC(3,0)) --DECIMAL(3,0)
---CONVERT
SELECT CONVERT(int, 30.60)
SELECT CONVERT(VARCHAR(10), '2020-10-10')
SELECT CONVERT(DATETIME, '2020-10-10')


SELECT CONVERT(VARCHAR, GETDATE(), 7)
SELECT CONVERT(NVARCHAR, GETDATE(), 100) --0 / 100
SELECT CONVERT(NVARCHAR, GETDATE(), 112)
SELECT CONVERT(NVARCHAR, GETDATE(), 113) --13 / 113
SELECT CAST('20201010' AS DATE)
SELECT CONVERT(NVARCHAR, CAST('20201010' AS DATE), 103)


--şöyle CONVERT ile CAST örneklerini bir arada görelim. Syntax farkına dikkat!:
SELECT CONVERT(varchar, '2017-08-25', 101);
SELECT CAST('2017-08-25' AS varchar);
-- date formatındaki bir veriyi char'a çevirdi.
SELECT CONVERT(datetime, '2017-08-25');
SELECT CAST('2017-08-25' AS datetime);
-- char formatındaki bir veriyi datetime'a çevirdi.
SELECT CONVERT(int, 25.65);
SELECT CAST(25.65 AS int);
-- decimal bir veriyi, integer'a (tam sayıya) çevirdi.
SELECT CONVERT(DECIMAL(5,2), 12) AS decimal_value;
SELECT CAST(12 AS DECIMAL(5,2) ) AS decimal_value;
-- integer bir veriyi 5 rakamdan oluşan ve bunun virgülden sonrası 2 rakam olan decimal'e çevirdi.
SELECT CONVERT(DECIMAL(7,2), ' 5800.79 ') AS decimal_value;
SELECT CAST(' 5800.79 ' AS DECIMAL (7,2)) AS decimal_value;
-- char (string) olan ama rakamdan oluşan veriyi decimal'e çevirdi.


https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

-- Desimal (Ondalık) veri türünü çeşitli uzunluk parametreleriyle yuvarlama örnekleri:
DECLARE @value decimal(10,2)
SET @value = 11.05
SELECT ROUND(@value, 1)  -- 11.10
SELECT ROUND(@value, -1) -- 10.00 
SELECT ROUND(@value, 2)  -- 11.05 
SELECT ROUND(@value, -2) -- 0.00 
SELECT ROUND(@value, 3)  -- 11.05
SELECT ROUND(@value, -3) -- 0.00
SELECT CEILING(@value)   -- 12 
SELECT FLOOR(@value)     -- 11 
GO



---Bunlar da Float veri türü ile yuvarlamaya örnekleri.. çalışma dosyanıza yapıştırın bulunsun:
DECLARE @value float(10)
SET @value = .1234567890
SELECT ROUND(@value, 1)  -- 0.1
SELECT ROUND(@value, 2)  -- 0.12
SELECT ROUND(@value, 3)  -- 0.123
SELECT ROUND(@value, 4)  -- 0.1235
SELECT ROUND(@value, 5)  -- 0.12346
SELECT ROUND(@value, 6)  -- 0.123457
SELECT ROUND(@value, 7)  -- 0.1234568
SELECT ROUND(@value, 8)  -- 0.12345679
SELECT ROUND(@value, 9)  -- 0.123456791
SELECT ROUND(@value, 10) -- 0.123456791---


SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) result;
SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', NULL) result;
SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', 100, NULL) result;
---This function doesn't limit the number of arguments, but they must all be of the same data type.
SELECT COALESCE(NULL, NULL) result;








SELECT ISNULL(NULL, 1)
SELECT ISNULL(phone, 'no phone')
FROM sale.customer
---difference between coalesce and isnull
SELECT ISNULL(phone, 0)
FROM sale.customer
SELECT COALESCE(phone, 0) --ERROR
FROM sale.customer

SELECT NULLIF(10,10)
SELECT NULLIF('Hello', 'Hi') result;
SELECT NULLIF(2, '2')

/*COALESCE()'de içerisine yazdığınız ifadelerin data tipleri aynı olmak zorunda değil. Diğer NULL fonksiyonlarda ise yazdığınız 2 ifadenin de veri türlerinin aynı olması gerekiyor. COALESCE() , yazdığınız ‘çok sayıda ifadelere sırayla gider ve ilk bulduğu NULL olmayan ifadede kalır.
:point_right:Kullanım yeri olarak şöyle bir örneğe rastladım:
AdSoyad(varchar), Telefon(int), e-mail(varchar),adres(varchar) kolonlarına sahip olsun.  Kişiyle iletişime geçebilecek alanı çekmek istiyorsunuz fakat tablonuzda çok fazla eksikliklerin olduğunun farkındasınız.
Bu örnekte coalesce fonksiyonunu kullanmanız gerekmektedir, yoksa içiçe isnull ya da nvl gibi fonksiyonlar kullanmanız gerekecekti;
COALESCE( Telefon , e-mail , adres , '-' )*/

/*COALESCE()'de içerisine yazdığınız ifadelerin data tipleri aynı olmak zorunda değil. Diğer NULL fonksiyonlarda ise yazdığınız 2 ifadenin de veri türlerinin aynı olması gerekiyor. COALESCE() , yazdığınız ‘çok sayıda ifadelere sırayla gider ve ilk bulduğu NULL olmayan ifadede kalır.
:point_right:Kullanım yeri olarak şöyle bir örneğe rastladım:
AdSoyad(varchar), Telefon(int), e-mail(varchar),adres(varchar) kolonlarına sahip olsun.  Kişiyle iletişime geçebilecek alanı çekmek istiyorsunuz fakat tablonuzda çok fazla eksikliklerin olduğunun farkındasınız.
Bu örnekte coalesce fonksiyonunu kullanmanız gerekmektedir, yoksa içiçe isnull ya da nvl gibi fonksiyonlar kullanmanız gerekecekti;
COALESCE( Telefon , e-mail , adres , '-' ) 
Datamızı analiz ederken bazı durumlarda NaN valueları da hesaba katmak isteriz ve onları "unknown" a çevirerek sanki ayrı bir kategori imiş gibi muamele ederiz.
Fakat burada dikkat edilmesi gereken bir nokta var:
Machine learning algoritmaları, datadaki bazı paternleri bularak çalışır. Unsupervised learning'te (bunu ML'de öğreneceksiniz, merak edenler "supervised & unsupervised learning" temel kavramlarına bir göz atabilirler) bu genellikle benzer value'lara sahip bazı featureları olan instance (training datadaki örnek) grupları bulmak anlamına gelir. Sistem bu şekilde çalışır. Ve eğer siz datada bazı "unknown" değerler bırakırsanız, bunlar algoritma tarafından bir paternin parçası olarak potansiyel olarak kullanılması olasıdır!
İşte tam da bu noktada bir problem ortaya çıkabiliyor. Çünkü malumunuz olduğu üzere bu "unknown"lar, gerçek (ve anlamlı) bilgi olarak datayı temsil etmez. Bu durum belki yeterince büyük ve düzgün bir datasetinde problem olmayabilir.
Eğer datasetiniz yeterince büyükse; bir X feature'u için "unknown" value'lara sahip örneklerin alt kümesinde diğer featureların farklı olması muhtemeldir (içlerinde çok sayıda farklı veriye sahip olmaları nedeniyle). Bu durumda ML algoritması, bunların aynı paterne sahip olduklarını değerlendirmeyecektir. Belki sonuca etki etmeyecek derecede çok zayıf bir patern olarak görecektir.
Fakat eğer datada daha kuvvetli bir patern bulunamaz ise ve sonuç bu zayıf paterne dayanıyorsa; o zaman zaten taskın çok başarılı olması olası değildir.

*/






