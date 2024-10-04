/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_py
PURPOSE: Solve an increased complexity question using SQL

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     10/03/2024   PYARLEQUE      1. Built this script for EC IT143


RUNTIME: 
1s

NOTES: 
Built for W3.4 - Adventure Works: Create Answers

I am building this script in order to show students how to solve an actual increased complexity question using these tools...
- Adventure Works Meta Data -> https://dataedo.com/samples/html/AdventureWorks/
- SQL
- SSMS
 
******************************************************************************************************************/
SELECT GETDATE() AS my_date;

-- Q1: What is the list price of the most expensive product in the product table? (student: Danilo C. Ymbong)
-- Restate the question: What is the list price of the most expensive product in the product table and what is the name of that product?
-- A1: This query retrieves the maximum list price and the most expensive product from the products table.

-- Select the top 1 product based on the highest list price from the Production.Product table.
SELECT TOP 1 ListPrice, Name AS MostExpensiveProduct
FROM Production.Product
ORDER BY ListPrice DESC; -- Order the results by list price in descending order to get the most expensive product.

-- Q2: What are the three hundred least expensive products in terms of list price? (student: Me)
-- Restate the question: Can you provide a list of the three hundred least expensive products based on the list price?
-- A2: This query returns the names and list prices of the three hundred least expensive products.

-- Select the top 300 products with the lowest list price.
SELECT TOP 300 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice ASC; -- Order the products by list price in ascending order.

-- Q3: How many employees were hired in the last fifteen years, and how many of them work full-time? (student: Me)
-- A3: This query counts the total employees hired in the last fifteen years and those who are full-time.

-- Count the total employees hired in the last 15 years and full-time employees.
SELECT COUNT(*) AS TotalEmployeesHired, 
       SUM(CASE WHEN e.JobTitle LIKE '%Full%' THEN 1 ELSE 0 END) AS FullTimeEmployees
FROM HumanResources.Employee e
WHERE DATEDIFF(YEAR, e.HireDate, GETDATE()) <= 15; -- Filter employees hired in the last 15 years.

-- Q4: I'm interested in knowing which are the top 10 married employees with the most available vacation hours, Can you give this information? (student: Edwin Esau Velasquez Canaviri)
-- A4: This query lists the top 10 married employees who have the most available vacation hours.

-- Select the top 10 married employees based on vacation hours.
SELECT TOP 10 e.BusinessEntityID, p.FirstName, p.LastName, e.VacationHours
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.MaritalStatus = 'M'
ORDER BY e.VacationHours DESC; -- Order the results by vacation hours in descending order.

-- Q5: I am reviewing sales performance for the year 2012. Can you provide a summary of total sales by month for all product categories? I need the total quantity sold, list price, and standard cost for each month. (student: Hunter Robinson)
-- A5: This query provides a summary of total sales quantity, list price, and standard cost by month for all categories in 2012.

-- Get total sales data summarized by month and product category for 2012.
SELECT MONTH(soh.OrderDate) AS OrderMonth, 
       pc.Name AS ProductCategory,
       SUM(sod.OrderQty) AS TotalQuantitySold,
       SUM(sod.LineTotal) AS TotalListPrice,
       SUM(p.StandardCost * sod.OrderQty) AS TotalStandardCost
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE YEAR(soh.OrderDate) = 2012
GROUP BY MONTH(soh.OrderDate), pc.Name
ORDER BY OrderMonth, ProductCategory; -- Group and order the results by month and category.

-- Q6: I need to understand more about mountain bike orders during Q3 2011. Specifically, I need to know how our mountain bike sales looked by frame color during that time period. Can you create a list that will tell me this information by order month? I need to know the quantity sold, list price, standard cost, and an estimated net revenue number. (student: Danilo C. Ymbong)
-- A6: This query generates a report of mountain bike sales by frame color, including quantity sold, list price, standard cost, and estimated net revenue for Q3 2011.

-- Summarize mountain bike sales data by month and frame color for Q3 2011.
SELECT MONTH(soh.OrderDate) AS OrderMonth,
       p.Color AS FrameColor,
       SUM(sod.OrderQty) AS TotalQuantitySold,
       SUM(sod.LineTotal) AS TotalListPrice,
       SUM(p.StandardCost * sod.OrderQty) AS TotalStandardCost,
       SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS EstimatedNetRevenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE psc.Name = 'Mountain Bikes'
  AND soh.OrderDate >= '2011-07-01' AND soh.OrderDate < '2011-10-01'
GROUP BY MONTH(soh.OrderDate), p.Color
ORDER BY OrderMonth, FrameColor; -- Group and order results by order month and frame color.


-- Q7: Can you create a list of tables in AdventureWorks that contain a column with one of these names:BusinessEntityID or ProductID? (student: Andrew Stephen)
-- A7: This query lists tables with a column with BusinessEntityID or ProductID.

-- List tables that contain specified column names.
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('BusinessEntityID', 'ProductID'); -- Filter by specific column names.


-- Q8: How many different datatypes are in the sales, persons and products tables? (student: Precious Okechukwu)
-- A8: This query calculates and lists the number of distinct data types in the Sales, Person, and Product tables.

-- Get the count of distinct data types in the specified tables.
SELECT TABLE_NAME, 
       DATA_TYPE, 
       COUNT(DISTINCT DATA_TYPE) AS DataTypeCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Sales', 'Person', 'Product')
GROUP BY TABLE_NAME, DATA_TYPE; -- Group the results by table name and data type.
