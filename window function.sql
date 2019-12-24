--A window function is a function that, for each row, computes a scalar result value
-- based on a calculationn against a subset of the rows from the underlying query.
--The subset of rows is known as a window
--The syntax for window functions uses a clause called OVER
--perform a calculation against a set and return a single value.
--groups. With window functions, the set is defined for each function, not for the entire query.
--In contrast, a window function is applied to a subset of rows from the underlying query’s result se

USE TSQLV4;

select orderid, YEAR(orderdate) as orderYear, freight,
   SUM(freight) over (partition by YEAR(orderdate)
                      order by YEAR(orderdate)
                      rows between unbounded preceding
                              and current row) as runFreight
from Sales.Orders;

--The window specification in the OVER clause has three main parts: partitioning, 
--ordering, and framing. the frame is between the beginning of the partition 
--(UNBOUNDED PRECEDING) and the current row (CURRENT ROW).
--phase, window functions are allowed only in the SELECT and ORDER BY clauses of a query
--Using table expression if we want to use in the earlier logical query

--Ranking Window function
--allow you to rank each row in respect to others in several different ways.
--ROW_NUMBER function: function assigns incrementing sequential integers to the rows in the
--result set of a query, must produce unique values even when there are ties in the ordering values
select orderid, custid, val,
row_number() over(order by val) as rownum,
rank()       over(order by val) as rank,
dense_rank() over(order by val) as dense_rank,
ntile(100)   over(order by val) as ntile
from Sales.OrderValues
order by val;

--using ORDER BY, guarantee presentation ordering
--the row_number function is processed before the distinct clause
select orderid, custid, val,
   row_number() over(partition  by custid
                order by val) as rownum
from Sales.OrderValues
order by custid, val;

--Offset Window Functions
--The LAG and LEAD functions support window partition and window order clauses.
--The LAG function looks before the current row, and the LEAD function looks ahead.
--the LAG function to return the value of the previous customer’s order
--the LEAD function to return the value of the next customer’s order.
select custid, orderid, val,
   LAG(val) over(partition by custid
                 order by orderdate,orderid) as prevval,
   LEAD(val) over(partition by custid
                 order by orderdate,orderid) as nextval            
from Sales.OrderValues


select custid, orderid, val,
   First_value(val) over(partition by custid
                         order by orderdate, orderid
                         rows between unbounded preceding
                         and current row) as firstval,

   Last_value(val) over(partition by custid
                         order by orderdate, orderid
                         rows between current row
                         and unbounded following) as lasttval
from Sales.OrderValues
order by custid, orderdate, orderid

--Aggregate Window Function

--totalvalue: the total value calculated for all rows.
--custTotalValue: the total value for all rows that have the same custid value as in the current row
select orderid, custid, val,
   SUM(val) over() as totalvalue, 
   SUM(val) over(partition by custid) as custTotalValue
from Sales.OrderValues;

select orderid, custid, val,
     100. * val / SUM(val) over() as pctall,
     100. * val /SUM(val) over(partition by custid) as pctcust
from Sales.OrderValues 

select empid, ordermonth, val,
    SUM(val) over(partition by empid
                  order by ordermonth
                  rows between unbounded preceding
                       and current row) as runval
from Sales.EmpOrders

--Pivoting Data
--Pivoting data involves rotating data from a state of rows to a state of columns

drop table if exists dbo.Orders;
create table dbo.Orders
(
    orderid    int   not null,
    orderdate  date  not null,
    empid      int   not null,
    custid     varchar(5) not null,
    qty        int not null,
    constraint PK_Orders primary key(orderid) 
);

insert into dbo.Orders(orderid, orderdate, empid, custid, qty)
values
(30001, '20070802', 3, 'A', 10),
(10001, '20071224', 2, 'A', 12),
(10005, '20071224', 1, 'B', 20),
(40001, '20080109', 2, 'A', 40),
(10006, '20080118', 1, 'C', 14),
(20001, '20080212', 2, 'B', 12),
(40005, '20090212', 3, 'A', 10),
(20002, '20090216', 1, 'C', 20),
(30003, '20090418', 2, 'B', 15),
(30004, '20070418', 3, 'C', 22),
(30007, '20090907', 3, 'D', 30);

select * from dbo.Orders

select empid, custid, SUM(qty) as sumqty
from dbo.Orders
group by empid, custid

--Pivoting with Standard SQL
select empid,
  SUM(case when custid = 'A' then qty end) as A,
  SUM(case when custid = 'B' then qty end) as B,
  SUM(case when custid = 'C' then qty end) as C,
  SUM(case when custid = 'D' then qty end) as D
from dbo.Orders
group by empid;

--Pivoting with the Native T-SQL PIVOT Operator
--to use a table expression here
select empid, A, B, C, D
from ( select empid, custid, qty
        from dbo.Orders) as D
   pivot(SUM(qty) for custid in(A, B, C, D)) as P;

select *
from dbo.Orders

--view each individual row as a group
select empid, A, B, C, D
from dbo.Orders
    pivot(sum(qty) for custid in(A, B, C, D)) as P;

SELECT empid,
SUM(CASE WHEN custid = 'A' THEN qty END) AS A,
SUM(CASE WHEN custid = 'B' THEN qty END) AS B,
SUM(CASE WHEN custid = 'C' THEN qty END) AS C,
SUM(CASE WHEN custid = 'D' THEN qty END) AS D
FROM dbo.Orders
GROUP BY orderid, orderdate, empid;

--Unpivoting Data: technique to rotate data from a state of columns to a state of rows.
drop table if exists dbo.EmpCustOrders
CREATE TABLE dbo.EmpCustOrders
(
empid INT NOT NULL
CONSTRAINT PK_EmpCustOrders PRIMARY KEY,
A VARCHAR(5) NULL,
B VARCHAR(5) NULL,
C VARCHAR(5) NULL,
D VARCHAR(5) NULL
);

INSERT INTO dbo.EmpCustOrders(empid, A, B, C, D)
SELECT empid, A, B, C, D
FROM (SELECT empid, custid, qty
FROM dbo.Orders) AS D
PIVOT(SUM(qty) FOR custid IN(A, B, C, D)) AS P;
SELECT * FROM dbo.EmpCustOrders;

--Unpivoting with Standard SQL
select *
from dbo.EmpCustOrders
    cross join(values('A'),('B'),('C'),('D')) as Custs(custid);


select empid, custid, 
     case custid
         when 'A' then A
         when 'B' then B
         when 'C' then C
         when 'D' then D
      end as qty
      from dbo.EmpCustOrders
      cross join (values('A'),('B'),('C'),('D')) as Cust(custid);

select *
from (select empid, custid, 
      case custid
        when 'A' then A
        when 'B' then B
        when 'C' then C
        when 'D' then D
     end as qty
     from dbo.EmpCustOrders
     cross join (values('A'),('B'), ('C'),('D'))as Custs(custid)) as D
     where qty is not null;

     --pivoting with the Native T-SQL UNPIVOT Operator
     select empid, custid, qty
     from dbo.EmpCustOrders
       unpivot(qty for custid in(A, B, C, D)) as U;

--Grouping Sets
SELECT empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid, custid;

SELECT empid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid;

SELECT custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY custid;

SELECT SUM(qty) AS sumqty
FROM dbo.Orders;


SELECT empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid, custid
UNION ALL
SELECT empid, NULL, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid
UNION ALL
SELECT NULL, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY custid
UNION ALL
SELECT NULL, NULL, SUM(qty) AS sumqty
FROM dbo.Orders;

--The GROUPING SETS Subclause
SELECT empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY
GROUPING SETS
(
(empid, custid),
(empid),
(custid),
()
);

--The CUBE Subclause: The CUBE subclause of the GROUP BY clause provides an abbreviated way to
 --define multiple grouping sets.
 --CUBE(a, b, c) is equivalent to GROUPING SETS( (a, b, c), (a, b), (a, c), (b, c), (a), (b), (c), () ).
SELECT empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY CUBE(empid, custid);

--The ROLLUP Subclause: The ROLLUP subclause of the GROUP BY clause also provides 
--an abbreviated way to define multiple grouping sets.
--ROLLUP(a, b, c) produces only four grouping sets, assuming the hierarchy a>b>c, 
--and is the equivalent of specifying GROUPING SETS( (a, b, c), (a, b), (a), () ).
SELECT
YEAR(orderdate) AS orderyear,
MONTH(orderdate) AS ordermonth,
DAY(orderdate) AS orderday,
SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY ROLLUP(YEAR(orderdate), MONTH(orderdate), DAY(orderdate));

--The GROUPING and GROUPING_ID Functions
SELECT
GROUPING(empid) AS grpemp,
GROUPING(custid) AS grpcust,
empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY CUBE(empid, custid);

SELECT
GROUPING_ID(empid, custid) AS groupingset,
empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY CUBE(empid, custid);