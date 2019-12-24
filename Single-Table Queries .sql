---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 02 - Single-Table Queries
-- © Shuhua Song 
---------------------------------------------------------------------
 
---------------------------------------------------------------------
--
-- Elements of the SELECT Statement
---------------------------------------------------------------------
 
-- Listing 2-1: Sample Query
USE Northwinds2019TSQLV5;

SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM Sales.[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) >1
ORDER BY EmployeeId, orderyear

---------------------------------------------------------------------
--2
-- The FROM Clause
--return all the orders placed by different custome
---------------------------------------------------------------------
SELECT OrderId, CustomerId, EmployeeId, OrderDate, Freight
FROM Sales.[Order]

---------------------------------------------------------------------
--3
-- The WHERE Clause
--return all the orders placed by a customer with Id number 71
---------------------------------------------------------------------
SELECT OrderId, EmployeeId, OrderDate, Freight
FROM Sales.[Order]
WHERE CustomerId = 71;

---------------------------------------------------------------------
--4-1
-- The GROUP BY Clause
--Group by the orders  placed by CustomerID=71 
---------------------------------------------------------------------
 SELECT EmployeeId, YEAR(OrderDate) AS orderyear
 FROM Sales.[Order]
 WHERE CustomerId = 71
 Group BY EmployeeId, YEAR(OrderDate);

---------------------------------------------------------------------
--4-2
-- The GROUP BY Clause
--Group by the orders  placed by CustomerID=71 
---------------------------------------------------------------------
 SELECT 
       EmployeeId,
       YEAR(OrderDate) AS orderdate,
       SUM(Freight) AS totalfreight,
       COUNT(*) AS numOrders
 FROM Sales.[Order]
 WHERE CustomerId = 71
 GROUP By EmployeeId, YEAR(orderdate)

 ---------------------------------------------------------------------
--4-3
-- The GROUP BY Clause
--Group by the orders dealed with by different employees and list the number of different customers they provide the service  
---------------------------------------------------------------------
SELECT 
     EmployeeId,
     YEAR(OrderDate) AS orderyear,
     COUNT(DISTINCT CustomerId) AS numCusts
FROM Sales.[Order]
GROUP BY EmployeeId, YEAR(OrderDate);

---------------------------------------------------------------------
--5
-- The HAVING Clause
--returen the orders places by customerId=71, and the number of order that employee deal charging is greater than 1
---------------------------------------------------------------------
SELECT EmployeeId, YEAR(OrderDate) AS orderyear
FROM Sales.[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1;
 
------------------------------------------------------------------------
--6
-- Query Returning Duplicate Rows
---------------------------------------------------------------------
SELECT EmployeeId, YEAR(OrderDate) AS orderyear
FROM Sales.[Order]
WHERE CustomerId = 71;

------------------------------------------------------------------------
--6-2
-- Query Returning Duplicate Rows
---------------------------------------------------------------------
SELECT DISTINCT EmployeeId, YEAR(OrderDate) AS orderyear
FROM Sales.[Order]
WHERE CustomerId = 71;

------------------------------------------------------------------------
--7-1
-- Query All the Column in the table Shipper
---------------------------------------------------------------------
SELECT *
FROM Sales.[Shipper]

------------------------------------------------------------------------
--7-2
-- Query the different orders with different order Id
---------------------------------------------------------------------
SELECT OrderId,
     YEAR(OrderDate) AS orderyear,
     YEAR(OrderDate) + 1 AS nextyear
FROM Sales.[Order]

---------------------------------------------------------------------
--8
-- The ORDER BY Clause
--Query Demonstrating the ORDER BY Clause
---------------------------------------------------------------------
SELECT EmployeeId, EmployeeLastName, EmployeeFirstName,EmployeeCountry
FROM HumanResources.Employee
ORDER By HireDate

---------------------------------------------------------------------
--9-1 The TOP and OFFSET-FETCH Filters
--Query Demonstrating the TOP records
--return the top 5 orders after order by the order date ascending
---------------------------------------------------------------------
 
SELECT TOP (5) OrderId, OrderDate, CustomerID, EmployeeId
FROM Sales.[Order]
ORDER By OrderDate ASC;
---------------------------------------------------------------------
--9-2 The TOP Filter
--return the top 1 percentage of orders after order by the order date descending
---------------------------------------------------------------------
SELECT TOP (1) PERCENT OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC;

---------------------------------------------------------------------
--9-3 Query Demonstrating TOP with Unique ORDER BY List
--return the top 5  orders after order by the order date descending and OrderId descending
---------------------------------------------------------------------
SELECT TOP(5) OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC, OrderId DESC

---------------------------------------------------------------------
--9-4 Query Demonstrating TOP with Unique ORDER BY List
--return the top 5 orders with the same sort values(OrderDate) after order by the order date descending 
---------------------------------------------------------------------
SELECT TOP(5) WITH TIES OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC;

---------------------------------------------------------------------
--10 The OFFSET-FETCH Filter
--Skip 50 rows, filter 25 rows after the skipped rows
---------------------------------------------------------------------
 SELECT OrderId, OrderDate, CustomerId, EmployeeId
 FROM Sales.[Order]
 ORDER BY OrderDate, OrderId
 OFFSET 50 ROWS FETCH NEXT 25 ROW ONLY

select EmployeeId, EmployeeFirstName, EmployeeTitle, HireDate, EmployeeCountry
from HumanResources.[Employee]
order by EmployeeId, HireDate

select EmployeeId, EmployeeLastName,YEAR(HireDate) as hireYear, count(*) as EmployeeCountry
from HumanResources.[Employee]
group by EmployeeId, EmployeeLastName,YEAR(HireDate)


