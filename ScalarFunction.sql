--http://www.sqlservertutorial.net/sql-server-user-defined-functions/sql-server-scalar-functions/
--create a function to return the fiscal calendar year quarter that
--the OrderDate resides within. The function will return CY-YYYYQuarter I,
-- CY-YYYY-Quarter II, CY-YYYY-Quarter III and CY-YYYYQuarter IV.

if object_id(N'dbo.yearQuarter', N'FN') is not null
   drop function yearQuarter;

go
create function yearQuarter(@OrderDate nvarchar(20)) 
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

 