
--1c. Create a function to return the fiscal year (October 1, 20XX through September 30, 20XX+1)
--quarter that the OrderDate resides within. The function will return FY-YYYY+1-Quarter I,
--FY-YYYY-Quarter II, FY-YYYY -Quarter III and FY-YYYY -Quarter IV.

if object_id(N'dbo.fiscalYearQuarter3',N'FN') is not null
drop function fiscalYearQuarter3;

go 
create function fiscalYearQuarter3(@OrderDate Date)
returns nvarchar(20)
as 
begin
    declare @result nvarchar(20);
    declare @year int = YEAR(@OrderDate);
    declare @month int = Month(@OrderDate);
    select @result = case
             when @month in(10,11,12) then concat('FY-',@year+1,'-Quarter I')
             when @month in(1,2,3) then concat('FY-', @year, 'Quarter II')
             when @month in(4,5,6) then concat('FY-',@year,'-Quarter III')
             when @month in(7,8,9) then concat('FY-', @year, 'Quarter IV')
             else 'Unknown'
             end;
    return @result
    end;