
-- Cross Joins

use TSQLV4;

-- ANSI SQL-92 Syntax
--inner join-> cardition product
select C.custid, E.empid
from Sales.Customers as C 
     cross join HR.Employees as E;

select custid
from Sales.Customers
select empid
from HR.Employees

-- ANSI SQL-92 Syntax
select C.custid, E.empid
from Sales.Customers as C, HR.Employees as E;

--Self Cross Joins(Cardition product)
select E1.firstname, E1.lastname,
       E2.firstname, E2.lastname
from HR.Employees as E1
    cross join HR.Employees E2




--Producing Tables of Numbers    ---Msg 3701, Level 14, State 20, Line 23
  ---Cannot drop the table 'Digits', because it does not exist or you do not have permission.
--use TSQLV4;
--if OBJECT_ID('dbo.Digits', 'U') is not null drop table dbo.Digits;
--create table dbo.Digits(digit int not null primary key);

--nsert into dbo.Digits(digit)
       --values (0), (1), (2), (3), (4), (5),(6), (7), (8),(9);

--select digit from dbo.Digits

--Inner Joins
--ANSI SQL-92 Syntax
select E.empid, E.firstname, E.lastname, O.orderid
from HR.Employees as E
    JOIN Sales.Orders as O
    on E.empid = O.empid


select *
from HR.Employees

select *
from Sales.Orders

--ANSI SQL-89 Syntax
select E.empid, E.firstname, E.lastname, O.orderid
from HR.Employees as E,
     Sales.Orders as O
     where E.empid = O.empid

--Inner Join Safety
/*select E.empid, E.firstname, E.lastname, O.orderid
from HR.Employees as E
    inner join Sales.Orders as O; */

select E.empid, E.firstname, E.lastname, O.orderid
from HR.Employees as E,
     Sales.Orders as O

--Composition Joins
/*use TSQLV4;
If OBJECT_ID('Sales.OrderDetailsAudit', 'U') is not NULL
   drop table Sales.OrderDetailsAudit;

create table Sales.OrderDetailsAudit
(
    lsn         int not null IDENTITY,
    orderid     int not null,
    productid   int not null,
    dt          datetime not null,
    loginname   sysname not null,
    columnname  sysname not null,
    oldval      sql_variant,
    newval      sql_variant,
    constraint  pk_OrderDetailsAudit primary key(lsn),
    constraint  fk_OrderDetailsAudit_OrderDetails
           foreign key (orderid, productid)
           references Sales.OrderDetails(orderid, productid)
);*/

--join the two tables based on a primary key–foreign key relationship
/*SELECT OD.orderid, OD.productid, OD.qty,
ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetails AS OD
JOIN Sales.OrderDetailsAudit AS ODA
ON OD.orderid = ODA.orderid
AND OD.productid = ODA.productid
WHERE ODA.columnname = N'qty'; */

--Non-Equi Joins
select 
    E1.empid, E1.firstname, E1.lastname,
    E2.empid, E2.firstname, E2.lastname
from HR.Employees as E1
    join HR.Employees as E2
    on E1.empid < E2.empid

--Multi-Join Queries
select C.custid, C.companyname, O.orderid,
       OD.productid, OD.qty
from Sales.Customers as C
    join Sales.Orders as O
    on C.custid = O.custid
    join Sales.OrderDetails as OD
    on O.orderid = OD.orderid;



 --Outer Joins
 --The LEFT keyword means that the rows of the left table are preserved
 --The following query joins the
 --Customers and Orders tables based on a match between the customer’s customer ID and the order’s
 --customer ID, to return customers and their orders. The join type is a left outer join; therefore, the query
 --also returns customers who did not place any orders.
 select C.custid, C.companyname, O.orderid
 from Sales.Customers as C
 left outer join Sales.Orders as O
      on C.custid = O.custid;

--adding WHERE clause that filters only outer rows
--query the customers who are not place order
select C.custid, C.companyname
from Sales.Customers as C
    left outer join Sales.Orders as O
    on C.custid = O.custid
where O.orderid is null;

--right outer join
--query the customers who are place order
select C.custid, C.companyname
from Sales.Customers as C
    right outer join Sales.Orders as O
    on C.custid = O.custid
where O.orderid is null;

--full outer join
--return all the customers, it doesn't matter if they place order or not
select C.custid, C.companyname
from Sales.Customers as C
    full outer join Sales.Orders as O
    on C.custid = O.custid
where O.orderid is null;


--Including Missing Values
--produce a sequence of all dates in the requested range
--can use the DATEDIFF function to calculate that number. 
--By adding n – 1 days to the starting point of the date range (January 1, 2006)
-- you get the actual date in the sequence.
select DATEADD(day, n-1, '20060101') as orderdate
from dbo.Nums
where n<=DATEDIFF(day, '20060101','20081231')+1
order by orderdate;

--adding a left outer join between Nums and the
--Orders tables. The join condition compares the order date produced from the Nums table and the
--orderdate from the Orders table by using the expression DATEADD(day, Nums.n – 1, ‘20060101’) like this.
select DATEADD(day, Nums.n-1, '20060101') as orderdate,
     O.orderid, O.custid, O.empid
from dbo.Nums
  left outer join Sales.Orders as O
  on DATEADD(day, Nums.n-1, '20060101') = O.orderdate
where Nums.n<=DATEDIFF(day, '20060101','20081231') +1
order by orderdate;

--Filtering Attributes from the Nonpreserved Side of an Outer Join
select C.custid, C.companyname, O.orderid, O.orderdate
from Sales.Customers as C
    left outer join Sales.Orders as O
    on C.custid = O.custid
where O.orderdate < '20150101';

--Using Outer Joins in a Multi-Join Query Recall the
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON C.custid = O.custid
JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid;

--to return customers with no orders
--in the output. One option is to use a left outer join in the second join as well.
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON C.custid = O.custid
LEFT OUTER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid;

--A second option is to first join Orders and OrderDetails by using an inner join, and then join to the
--Customers table by using a right outer join.
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
RIGHT OUTER JOIN Sales.Customers AS C
ON O.custid = C.custid;

--A third option is to use parentheses to turn the inner join between Orders and OrderDetails into an
--independent logical phase. This way, you can apply a left outer join between the Customers table and
--the result of the inner join between Orders and OrderDetails.
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
LEFT OUTER JOIN
(Sales.Orders AS O
JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid)
ON C.custid = O.custid;

--Using the COUNT Aggregate with Outer Joins
SELECT C.custid, COUNT(*) AS numorders
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON C.custid = O.custid
GROUP BY C.custid;

select *
from Sales.Orders
where custid = 1;

--The COUNT(*) aggregate function cannot detect whether a row really represents an order. To fix
--the problem, you should use COUNT(<column>) instead of COUNT(*), and provide a column from
--the nonpreserved side of the join.
SELECT C.custid, COUNT(O.orderid) AS numorders
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON C.custid = O.custid
GROUP BY C.custid;