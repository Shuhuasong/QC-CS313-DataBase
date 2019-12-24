USE Northwinds2019TSQLV5;
--select OrderId, OrderDate
--from Sales.[Order]

---select OrderId, dbo.yearQuarter(OrderDate)
--from Sales.[Order]
--where OrderDate = '20140704';

select C.CustomerCompanyName,
       [dbo].[ficalYearQuarter](O.OrderDate) as FiscalYearQuarter,
       count(distinct O.CustomerId) as  TotalNumberOfOrders,
       format(sum(O.Freight),'C') as TotalFreigth,
       format(sum(OD.UnitPrice * OD.Quantity),'C') as LineCost,
       format(sum((OD.UnitPrice*OD.Quantity)*(1. - OD.DiscountPercentage)),"D") as DiscountedLineCost
from Sales.Customer as C
     inner join Sales.[Order] as O
     on C.CustomerId = O.CustomerId
     inner join Sales.OrderDetail as OD
     on O.OrderId = OD.OrderId
    group by 
         C.CustomerCompanyName, [Example].[FindCalendarYearQuarter](O.OrderDate)


