--4_Create a function to return a grouping based upon OrderId where
if object_id(N'dbo.grouppingOrderId', N'FN') is not null
drop function grouppingOrderId;

go 
create function grouppingOrderId(@orderId int)
returns nvarchar(20)
as 
begin
    --declare @result nvarchar(20);
    return case
            when (@orderId%2) != 0 then concat('SO-',@orderId)
            when (@orderId%2) = 0 and @orderId < 7  then concat('PU-', @orderId)
            else concat('OM-',@orderId)
            end
 end;
