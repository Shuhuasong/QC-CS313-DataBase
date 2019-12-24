--2. Create a function to return the number of days between two dates.

if object_id(N'dbo.numDaysOfTwoDate',N'FN') is not null
drop function numDaysOfTwoDate;

go 
create function numDaysOfTwoDate(@OrderDate1 Date, @OrderDate2 Date)
returns INT
as 
begin
    declare @result int
    --declare @numDay1 int = Day(@OrderDate1);
    --declare @numDay2 int = Day(@OrderDate2);
select @result = DATEDIFF(day,@OrderDate1,@OrderDate2) ;
return @result
end;