--3. Create a function to return a date that uses a base date plus the number of month(s)
-- being passed a parameter. Example: '20190119' plus 3 returns ’20190419'

if object_id(N'addMonthsOnDate', N'FN') is not null
drop function addMonthsOnDate;

go 
create function addMonthsOnDate(@baseDate Date, @numMonth int)
returns nvarchar(20)
as 
begin
     return dateadd(month, @numMonth, @baseDate)
end;