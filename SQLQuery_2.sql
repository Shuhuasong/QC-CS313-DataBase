--1b. Create a function to return the fiscal year (July 1, 20XX through June 30, 20XX+1)
--quarter that the OrderDate resides within. The function will return FY-YYYY+1-Quarter I,
--FY-YYYY+1-Quarter II, FY-YYYY-Quarter III and FY-YYYY -Quarter IV.

if object_id(N'dbo.fiscalYearQuarter', N'FN') is not null
   drop function ficalYearQuarter;

go
create function ficalYearQuarter(@OrderDate Date) 
returns nvarchar(20)
as 
begin 
     declare @result nvarchar(20)
     declare @year int = YEAR(@OrderDate);
     declare @month int = MONTH(@OrderDate);
   select @result = case
                 when @month in(7,8,9) then concat('FY',@year+1, '-Quarter I')
                 when @month in(10,11,12) then concat('FY',@year+1, '-Quarter II')
                 when @month in(1,2,3) then concat('FY',@year, '-Quarter III')
                 when @month in(4,5,6) then concat('FY',@year, '-Quarter IV')
                 else 'Unknown'
                 end; 
 return @result;
 end;
