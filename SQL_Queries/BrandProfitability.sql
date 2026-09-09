--7. Which brands are the most profitable?

Select
p.Brand
,cast(sum(s.Unit_Price * s.Quantity * (1 - s.Discount)) as decimal(10,2)) as 'Net Revenue'
,CAST(SUM((s.Unit_Price * s.Quantity * (1 - s.Discount)) - (p.Cost_Price * s.Quantity)) AS DECIMAL(10,2)) AS [Profit],
CAST(SUM((s.Quantity * s.Unit_Price * (1 - s.Discount)) - (s.Quantity * p.Cost_Price)) / NULLIF(SUM(s.Quantity * s.Unit_Price * (1 - s.Discount)),0 ) * 100 AS DECIMAL(10,2)) AS [Profit Margin %]
from SalesInventoryMIS.dbo.Sales s
left join SalesInventoryMIS.dbo.Products p on s.Product_ID = p.Product_ID
group by p.Brand
order by [Profit Margin %] desc
