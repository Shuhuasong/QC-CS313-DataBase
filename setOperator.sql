
USE TSQLV4;
-------------------------------------------------------------------------
--Union ALL: Assuming that Query1 returns m rows and Query2 returns n rows, 
--Query1 UNION ALL Query2 returns m + n rows.
-------------------------------------------------------------------------

--unify the employee locations and customer locations(with duplicate rows)
--return 9+91=100 rows
select country, region, city from HR.Employees --return 9 rows
union all
select country, region, city from Sales.Customers;--return 91 rows

---------------------------------------------------------------------------
--Union distinct, unify the results of two queries without duplicates
---------------------------------------------------------------------------
--without duplicate  rows, only return 71 rows
select country, region, city from HR.Employees --return 9 rows
union 
select country, region, city from Sales.Customers;--return 91 rows

---------------------------------------------------------------------------
--The Intersect Operator
--theory, the intersection of two sets (call them A and B) is the set of all elements
--that belong to A and also belong to B
--returning only rows that appear in both inputs.
--without duplicate rows
---------------------------------------------------------------------------
-- the folowing querycode returns distinct locations that are both employee locations and customer locations.
select country, region, city from HR.Employees
INTERSECT
select country, region, city from Sales.Customers;

select country, region, city from HR.Employees
INTERSECT 
select country, region, city from Sales.Customers;


--Use inner join to return distinct locations that both employee location and customer locations
select    
    c.country
    c.region
    c.city
    from HR.Employees as e
    inner join Sales.Customers as c
    on c.country = e.country
    and coalesce(c.region, 1) = coalesce(e.region, 1) --?????
   
   
--INTERSECT All does not return all duplicates but only returns the number of duplicate rows, matching
--the lower of the counts in both multisets.

--return the number of occurence of each row in Employee table
select 
   ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
              from HR.Employees

--return the number of occurence of each row in Customers table
select 
  ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
      from Sales.Customers;

--intersect
--apply the INTERSECT operator between the two queries with the ROW_NUMBER function.
--the follow query return all occurence of employee and customer locations and intersect 

select 
   ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
              from HR.Employees
intersect
select 
  ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
      from Sales.Customers;

-- use INTERSECT_ALL to return all occurrences of employee and customer locations that intersect.

with intersect_all
AS
(
   select 
   ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
              from HR.Employees
    INTERSECT

    select 
  ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
      from Sales.Customers
)

select country, region, city
from intersect_all;
    
---------------------------------------------------------------------------    
--The Except Opertator
--is the set of elements that belong to A and do not belong to B
---------------------------------------------------------------------------

--the following code returns distinct locations that are employee locations but not customer locations.
select country, region, city from HR.Employees
except
select country, region, city from Sales.Customers;

----the following code returns distinct locations that are customers' locations but not employees' locations.
--return 66 rows
select country, region, city from Sales.Customers 
except
select country, region, city from HR.Employees;

--EXCEPT ALL to return occurrences of employee
--locations that have no corresponding occurrences of customer locations.

with intersect_all
AS
(
   select 
   ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
              from HR.Employees
    EXCEPT

    select 
  ROW_NUMBER()
     over(partition by country, region, city
              order by (select 0)) as rownum,
              country, region, city
      from Sales.Customers
)

select country, region, city
from intersect_all;

--Precedence
--Higher: INTERSECT
--lower: EXCEPT, UNION
--the query return the locations that are supplier locations but not
 --locations that are both employee and customer locations.
select country, region, city from Production.Suppliers
EXCEPT
select country, region, city from HR.Employees
INTERSECT
select country, region, city from Sales.Customers;

--Use parenthese to control the order of evaluation of set operators
--returnlocations that are supplier locations but not employee locations) and
--that are also customer locations.
(select country, region, city from Production.Suppliers
EXCEPT
select country, region, city from HR.Employees)
INTERSECT
select country, region, city from Sales.Customers;





--Circumventing Unsupported Logical Phases
--the following query returns the number of distinct locations that are either
--employee or customer locations in each country.
select country, count(*) as numlocations
from (select country, region, city from HR.Employees
      UNION
      select country, region, city from Sales.Customers) as U
group by country;

--uses TOP queries to return the two most recent orders for those employees
--with an employee ID of 3 or 5.

select empid, orderid, orderdate
from (select top (2) empid, orderid, orderdate
      from Sales.Orders
      where empid = 3
      order by orderdate DESC, orderid DESC) as D1

union all
select empid, orderid, orderdate
from (select top (2) empid, orderid, orderdate
      from Sales.Orders
      where empid = 5
      order by orderdate DESC, orderid DESC) as D2

--using OFFSET-FETCH to return the two most recent orders for those employees
--with an employee ID of 3 or 5.
select empid, orderid, orderdate
from (select  empid, orderid, orderdate
      from Sales.Orders
      where empid = 3
      order by orderdate DESC, orderid DESC
      offset 0 rows fetch first 2 rows only) as D1
union all

select empid, orderid, orderdate
from (select  empid, orderid, orderdate
      from Sales.Orders
      where empid = 5
      order by orderdate DESC, orderid DESC
      offset 0 rows fetch first 2 rows only) as D2

