--8. Which customer type generates the most revenue?

Select
s.Customer_Type
,cast(sum(s.Unit_Price * s.Quantity * (1 - s.Discount)) as decimal(10,2)) as 'Net Revenue'
from SalesInventoryMIS.dbo.Sales s
group by s.Customer_Type
order by [Net Revenue] desc
