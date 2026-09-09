--5.Which product categories generate the highest revenue ,profit and profit margin?

Select  
p.Category ,
cast(sum(s.Quantity * s.Unit_Price * (1 - s.Discount)) as decimal(10,2)) as 'Net Revenue' ,
cast(sum((s.Quantity * s.Unit_Price * (1 - s.Discount)) - (s.Quantity * p.Cost_Price)) as decimal(10,2)) as 'Profit' ,
CAST(SUM((s.Quantity * s.Unit_Price * (1 - s.Discount)) - (s.Quantity * p.Cost_Price)) / NULLIF(SUM(s.Quantity * s.Unit_Price * (1 - s.Discount)),0 ) * 100 AS DECIMAL(10,2)) AS [Profit Margin %]
from SalesInventoryMIS.dbo.Sales s 
left join SalesInventoryMIS.dbo.Products p on s.Product_ID = p.Product_ID
group by p.Category 
order by [Profit Margin %] desc
