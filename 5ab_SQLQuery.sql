USE Northwinds2019TSQLV5;

--1a. create a function to return the fiscal calendar year quarter that
--the OrderDate resides within. The function will return CY-YYYYQuarter I,
-- CY-YYYY-Quarter II, CY-YYYY-Quarter III and CY-YYYYQuarter IV.

--drop table if exists dbo.yearQuarter
if object_id(N'dbo.yearQuarter', N'FN') is not null
   drop function yearQuarter;

go
create function yearQuarter(@OrderDate Date) 
returns nvarchar(20)
as 
begin 
     declare @result nvarchar(20)
     declare @year int = YEAR(@OrderDate);
     declare @month int = MONTH(@OrderDate);
   select @result = case
                 when @month in(1,2,3) then concat('CY-',@year, '-Quarter I')
                 when @month in(4,5,6) then concat('CY-',@year, '-Quarter II')
                 when @month in(7,8,9) then concat('CY-',@year, '-Quarter III')
                 when @month in(10,11,12) then concat('CY-',@year, '-Quarter IV')
                 else 'Unknown'
                 end; 
 return @result;
 end;


--5. Create a query that summarizes customer purchases by fiscal year quarters. a. Create a scalar 
--function called [Example].[FindCalendarYearQuarter] with one parameter @OrderDate datatype date. 
--b. Make sure all currency columns are formatted as currency using the format statement.

select C.CustomerCompanyName,
       [dbo].[ficalYearQuarter](O.OrderDate) as FiscalYearQuarter,
       count(distinct O.CustomerId) as  TotalNumberOfOrders,
       format(sum(O.Freight),'C') as TotalFreigth,
       format(sum(OD.UnitPrice * OD.Quantity),'C') as TotalLineCost,
       format(sum((OD.UnitPrice*OD.Quantity)*(1. - OD.DiscountPercentage)),'C') as DiscountedLineCost
from Sales.Customer as C
     inner join Sales.[Order] as O
     on C.CustomerId = O.CustomerId
     inner join Sales.OrderDetail as OD
     on O.OrderId = OD.OrderId
    group by 
         C.CustomerCompanyName, [dbo].[ficalYearQuarter](O.OrderDate)

UNION

select 'All customer purchases' as CustomerCompanyName, 
        'All Fiscal Year Quarter' as FiscalYearQuarter,
        count(distinct O.CustomerId) as  TotalNumberOfOrders,
        format(sum(O.Freight),'C') as TotalFreigth,
        format(sum(OD.UnitPrice * OD.Quantity),'C') as TotalLineCost,
        format(sum((OD.UnitPrice*OD.Quantity)*(1. - OD.DiscountPercentage)),'C') as DiscountedLineCost
from Sales.Customer as C
     inner join Sales.[Order] as O
     on O.CustomerId = C.CustomerId
     inner join Sales.OrderDetail as OD
     on OD.OrderId = O.OrderId
order by C.CustomerCompanyName;

--Return the total cost of customer which include total Freigth and total Cost
select O1.CustomerCompanyName,
       count(O1.OrderId) as TotalOderId,
       sum(OD1.TotalNumProductsOrder) as TotalProductOrder,
       sum(O1.TotalFreigth) as TotalFreigth,
       sum(OD1.TotalLineItemCost) as TotalCustomerLineCost,
       sum(O1.TotalFreigth + OD1.TotalLineItemCost)  as TotalCustomerOrderCost
from
(
select C.CustomerCompanyName, 
       O.OrderId,
       O.Freight as TotalFreigth
from Sales.Customer as C
     inner join Sales.[Order] as O
     on O.CustomerId = C.CustomerId
)  as O1
inner join
(
    select OD.OrderId,
        count(OD.ProductId) as TotalNumProductsOrder,
        sum((OD.UnitPrice * OD.Quantity) * (1.0- OD.DiscountPercentage)) as TotalLineItemCost
        from   Sales.OrderDetail as OD
        group by OD.OrderId
) OD1
  on OD1.OrderId = O1.OrderId
  group by O1.CustomerCompanyName