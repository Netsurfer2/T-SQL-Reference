
/*Assignment 05 
•	Due Saturday by 11:59pm 
•	Points 10 
•	Submitting a file upload 
•	Using the document Exporting Data from SQL Server, 
create a new query from the data in the AdventureWorksLT2012 database to export to Excel. 

Create and test this query first and then use it for your export: 
List the product ID, name, standard cost, and list price in descending order 
by list price for Products whose list price is greater than $2000.

Note: If you get an error on the Name field during the export, 
Cast the Name field as Char(50) and give it the alias of ProductName. See Cast Name As Char(50).pdf   
for more information on the error and on correcting the error.

Name the spreadsheet with your Last Name, First Name and Assignment number, 
for example: LovestedtArtAssignment05.xlsx

Open the spreadsheet, check the results, resize the column widths to fit, and save the changes. 
Do not make any additional formatting changes.

Attach your completed, renamed, and not zipped document to this Assignment tool and 
submit for grading by the due date shown.
*/




USE AdventureWorksLT2012

SELECT [ProductID], [Name], [StandardCost], [ListPrice]
FROM [SalesLT].[Product]
WHERE [ListPrice] > 2000
ORDER BY [ListPrice] DESC

/* Create and test this query first and then use it for your export: 
List the product ID, name, standard cost, and list price in descending order 
by list price for Products whose list price is greater than $2000.
 
List the product id, name (or ProductName), standard cost, and 
list price in descending order by list price for Products whose list price is greater than $2000*/
