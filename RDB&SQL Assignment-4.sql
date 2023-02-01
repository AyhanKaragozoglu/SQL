--SQL RDB&SQL Assignment-4 (DS 13/22 EU) (DDL - DML)



CREATE DATABASE Manufacturer

USE Manufacturer


CREATE SCHEMA product


--Create Tables


CREATE TABLE [product].[product](
	[product_ID] INT PRIMARY KEY NOT NULL,
	[product_name] [nvarchar](100) NOT NULL,
	[quantity] INT NOT NULL)



create TABLE [product].[component](
	[comp_ID] INT PRIMARY KEY NOT NULL,
	[comp_name] NVARCHAR(50) NOT NULL,
	[description] NVARCHAR(50) NOT NULL,
	[quantity_comp] INT);



CREATE TABLE [product].[suppliers](
	[supp_ID] INT PRIMARY KEY NOT NULL,
	[supp_name] NVARCHAR(50) NOT NULL,
	[supp_location] NVARCHAR(50) NOT NULL,
	[is_active] bit);


CREATE TABLE [product].[Comp_supp](
	[supp_ID] INT  NOT NULL,
	[comp_ID] INT NOT NULL,
	[order_date] date NOT NULL,
	[quantity] INT,
	PRIMARY KEY ([supp_ID], [comp_ID]));



CREATE TABLE [product].[Prod_Comp](
	[prod_ID] INT  NOT NULL,
	[comp_ID] INT NOT NULL,
	[quantity_comp] INT,
	PRIMARY KEY ([prod_ID], [comp_ID]));

--ADD KEY CONSTRAINTS

ALTER TABLE [product].[Prod_Comp]
ADD CONSTRAINT FK_product FOREIGN KEY (prod_ID) REFERENCES product.product (prod_id) 



ALTER TABLE [product].[Prod_Comp]
ALTER COLUMN prod_ID INT NOT NULL

ALTER TABLE product.
ADD CONSTRAINT FK_product FOREIGN KEY (prod_ID) REFERENCES [product].[product] (prod_ID)



