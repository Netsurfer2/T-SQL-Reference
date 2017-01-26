--*  BUSIT 103				Assignment   #10				DUE DATE :  Consult course calendar
/*
Name: Christopher Singleton 
Class: BUSIT103 - Online
Instructor: Art Lovestedt
Date: 11/22/2014	
*/						
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment10.sql). 
	Submit your file to the instructor using through the course site.  */

--  It is your responsibility to provide a meaningful column name for the return value of the function.
--  These statements will NOT use GROUP BY or HAVING. Those keywords are introduced in the next module. One cell 
--	results sets (one column and one row) do not need to have an ORDER BY clause.

--	Recall that sales to resellers are stored in the FactResellerSales table and sales to customers are stored in
--	the FactInternetSales table. 

--	Do not remove the USE statement
USE AdventureWorksDW2012;

-- 1.a.	(3) Find the count of customers who are married. Be sure give each derived field 
--		an appropriate alias.

SELECT COUNT([MaritalStatus]) AS 'Count_CustMarried' --You can also use the (*) instead, meaning that every that is married.
FROM [dbo].[DimCustomer]
WHERE [MaritalStatus] = 'M'

--Customers who are married (Using the COUNT Function): 10011 

--1.b.	(2) Check your result. Write queries to determine if the answer to 1.a. is correct.
--		You should be writing proofs for all of your statements.

SELECT Count([CustomerKey]) AS CustomerKey
FROM [dbo].[DimCustomer]
WHERE [MaritalStatus] = 'M'

--Returns 10011 rows.

--1.c.	(3) Find the total children (sum) and the total cars owned (sum) for customers who are married.

SELECT SUM([TotalChildren]) AS 'SUM_CustTotalChildren', 
       SUM([NumberCarsOwned]) AS 'SUM_CustTotalCarsOwned'
FROM [dbo].[DimCustomer]
WHERE [MaritalStatus] = 'M'

   
--1.d.	(2) Find the total children, total cars owned, and average yearly income for customers who are married.

SELECT SUM([TotalChildren]) AS 'SUM_CustTotalChildren', 
       SUM([NumberCarsOwned]) AS 'SUM_CustTotalCarsOwned',
	   AVG([YearlyIncome]) AS 'AVG_CustYearlyIncome'
FROM [dbo].[DimCustomer]
WHERE [MaritalStatus] = 'M'


--2.a.	(2) List the total dollar amount (SalesAmount) for sales to Resellers. Round to two decimal places.

SELECT SUM(CAST([SalesAmount] AS Decimal(8,2))) AS Total_ResellerSales
FROM [dbo].[FactResellerSales]



--2.b.	(3) List the total dollar amount (SalesAmount) for 2008 sales to resellers in Germany.
--		Show only the total sales--one row, one column--rounded to two decimal places. 

SELECT SUM(CAST([SalesAmount] AS Decimal(8,2))) AS Total_ResellerSales
FROM [dbo].[FactResellerSales] AS frs
     INNER JOIN [dbo].[DimReseller] AS dr ON frs.ResellerKey = dr.ResellerKey
     INNER JOIN [dbo].[DimGeography] AS dg ON dr.[GeographyKey] = dg.[GeographyKey]
WHERE dg.EnglishCountryRegionName = 'Germany' 
      AND (frs.[OrderDateKey] >= '20080101' AND frs.[OrderDateKey] <= '20081231')


--3.a.	(2) List the total dollar amount (SalesAmount) for sales to Customers. Round to two decimal places.

SELECT SUM(CAST([SalesAmount] AS Decimal(8,2))) AS TotalCust_SalesAmount
FROM [dbo].[FactInternetSales] AS fis
     INNER JOIN [dbo].[DimCustomer] AS c ON fis.CustomerKey = c.CustomerKey

/*
SELECT *
FROM [dbo].[DimCustomer]

SELECT *
FROM [dbo].[FactInternetSales]
*/

--3.b.  (3) List the total dollar amount (SalesAmount) for 2005 sales to customers located in the 
--		United Kingdom. Show only the total sales--one row, one column--rounded to two decimal places. 


SELECT SUM(CAST([SalesAmount] AS Decimal(8,2))) AS TotalCustSalesAmount_2005
FROM [dbo].[FactInternetSales] AS fis
     INNER JOIN [dbo].[DimCustomer] AS c ON fis.CustomerKey = c.CustomerKey
	 INNER JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
WHERE YEAR(fis.OrderDate) = 2005 AND g.EnglishCountryRegionName = 'United Kingdom'
/*
SELECT * 
FROM [dbo].[DimGeography]
*/

--4.	(4) List the average unit price for a touring bike sold to customers. Round to
--		two decimal places.

SELECT CAST(AVG(fis.[UnitPrice]) AS Decimal(6,2)) AS TourBike_AVGUnitPrice
FROM [dbo].[FactInternetSales] AS fis
     INNER JOIN [dbo].[DimCustomer] AS c ON fis.CustomerKey = c.CustomerKey
	 INNER JOIN [dbo].[DimProduct] AS p ON fis.ProductKey = p.ProductKey
WHERE p.[ProductSubcategoryKey] = 3

/*
SELECT * FROM [dbo].[DimProductSubcategory]
SELECT * FROM [dbo].[DimProductCategory]
*/
--5.	(5) List bikes that have a list price less than the average list price for all bikes.
--		Show product key, English product name, and list price.
--		Order descending by list price.

SELECT p.[ProductKey]
      ,p.[EnglishProductName]
	  ,p.[ListPrice] 
FROM [dbo].[DimProduct] AS p    
WHERE p.ProductSubCategoryKey IN (1,2,3)
      AND p.[ListPrice] < (SELECT AVG([ListPrice]) 
	                       FROM [dbo].[DimProduct] 
						   WHERE ProductSubCategoryKey IN (1,2,3))
ORDER BY p.[ListPrice] DESC


--6.	(4) List the lowest list price, the average list price, the highest list price, and product count for road bikes.
/*
SELECT * FROM [dbo].[DimProductSubcategory]
SELECT * FROM [dbo].[DimProductCategory]
*/

SELECT MIN(ListPrice) AS MinListPrice
      ,AVG(DISTINCT ListPrice) AS AvgListPrice
	  ,MAX(ListPrice) AS MaxListPrice
	  ,COUNT(*) AS NumOfRoadBikes
FROM [dbo].[DimProduct]
WHERE ProductSubcategoryKey = 2

--SELECT ListPrice, ProductSubcategoryKey FROM [dbo].[DimProduct] WHERE ProductSubcategoryKey = 2

-- 7.	(4) List the product alternate key, product name, and list price for the product(s) 
--		with the lowest List Price. There can be multiple products with the lowest list price.

/* --Checking:
ProductAlternateKey	EnglishProductName	  ListPrice
BK-M68S-42	        Mountain-200 Silver, 42	  2071.4196
BK-M68S-42	        Mountain-200 Silver, 42	  2319.99
*/

SELECT p1.ProductAlternateKey
      ,p1.EnglishProductName
	  ,p1.ListPrice AS LowestListPrice
FROM [dbo].[DimProduct] AS p1
WHERE p1.ListPrice = (SELECT MIN(ListPrice) 
                      FROM [dbo].[DimProduct] AS p2
					  WHERE p1.ProductAlternateKey = p2.ProductAlternateKey)	
ORDER BY p1.ProductAlternateKey, p1.EnglishProductName					   

/*
SELECT categoryid,
       productid,
       productName,
       unitprice
FROM products a
WHERE unitprice = (
                SELECT MIN(unitprice)
                FROM products b
                WHERE b.categoryid = a.categoryid)
*/

-- 8.a.	(4) List the product alternate key, product name, list price, dealer price, and the 
--		difference (calculated field) for all product(s). Show all money values to 2 decimal places.
--		Sort on difference from highest to lowest.

SELECT [ProductAlternateKey]
      ,[EnglishProductName]
	  ,CAST([ListPrice] AS Decimal(8,2)) AS ListPrice
	  ,CAST([DealerPrice] AS Decimal(8,2)) AS DealerPrice
	  ,CAST(ListPrice - DealerPrice AS Decimal(8,2)) AS PriceDifference
FROM [dbo].[DimProduct]
ORDER BY PriceDifference DESC


-- 8.b.	(3) Use the statement from 8.a. and modify to find the product(s) with the largest difference 
--		between the list price and the dealer price. Show all money values to 2 decimal places.

/*Checking:
ProductAlternateKey	EnglishProductName	   ListPrice	DealerPrice 	PriceDifference
BK-M68S-42	      Mountain-200 Silver, 42	2071.42 	 1242.85	     828.57
BK-M68S-42	      Mountain-200 Silver, 42	2319.99	     1391.99	     928.00
*/
SELECT [ProductAlternateKey]
      ,[EnglishProductName]
	  ,CAST(p1.[ListPrice] AS Decimal(8,2)) AS ListPrice
	  ,CAST(p1.[DealerPrice] AS Decimal(8,2)) AS DealerPrice
	  ,CAST(p1.ListPrice - p1.DealerPrice AS Decimal(8,2)) AS PriceDifference
FROM [dbo].[DimProduct] AS p1       
WHERE p1.ListPrice - p1.DealerPrice = 
                                    (SELECT MAX(ListPrice - DealerPrice)  
                                     FROM [dbo].[DimProduct] AS p2
		                             WHERE p1.ProductAlternateKey = p2.ProductAlternateKey)	
ORDER BY PriceDifference DESC


-- 9.	(4) List total Internet sales for product BK-M82S-44 using two methods: Total the sales amount field
--		and calculate the total amount using unit price and quantity. Place both calculations in different 
--		columns in the SAME Select statement. There will be one results set with two columns and one row. 
--		Show all money values to 2 decimal places. The values should be the same.

SELECT CAST(SUM(fis.[SalesAmount])AS Decimal(8,2)) AS TotalSalesAmount
      ,CAST(SUM(fis.[UnitPrice] * fis.[OrderQuantity]) AS Decimal(8,2)) AS ComputedTotalSalesAmount	  
FROM [dbo].[FactInternetSales] AS fis
     INNER JOIN [dbo].[DimProduct] AS p ON fis.[ProductKey] = p.[ProductKey]
WHERE ProductAlternateKey = 'BK-M82S-44'

--10.	(2) In your own words, write a business question that you can answer by querying the data warehouse
--		and using an aggregate function.
--		Then write the complete SQL query that will provide the information that you are seeking.
--My Question: 
--What is the total difference in Total Sales between 2007 and 2008. 
--Round to two decimal places and derive three alias columns.

SELECT CAST(SUM([SalesAmount]) AS Decimal(10,2)) AS TotalSalesAmount2007
      ,(SELECT CAST(SUM([SalesAmount]) AS Decimal(10,2)) 
		FROM [dbo].[FactInternetSales] 
		WHERE YEAR([OrderDate]) = 2008) AS TotalSalesAmount2008
	  ,CAST(SUM([SalesAmount]) - (SELECT SUM([SalesAmount]) 
	                              FROM [dbo].[FactInternetSales] 
     							  WHERE YEAR([OrderDate]) = 2008) AS Decimal(8,2)) AS YearlyDifference	
FROM [dbo].[FactInternetSales]  
WHERE YEAR([OrderDate]) = 2007

/*
SELECT *
FROM [dbo].[FactInternetSales]
WHERE YEAR([OrderDate]) = 2008
*/



