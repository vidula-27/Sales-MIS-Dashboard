--4.Which products have high sales but critically low closing stock?

With ProductSales as
(Select p.Product_ID, 
        cast(sum(s.Unit_Price * s.Quantity * (1 - s.Discount)) as Decimal(10,2)) as 'Net Revenue'
from SalesInventoryMIS.dbo.Sales s
left join SalesInventoryMIS.dbo.Products p on s.Product_ID = p.Product_ID 
group by p.Product_ID
),
InventorySales as
(Select pr.Product_ID,
        sum(i.Closing_Stock) as 'Total Closing Stocks'
 from SalesInventoryMIS.dbo.Products pr
 left join SalesInventoryMIS.dbo.Inventory i on pr.Product_ID = i.Product_ID
 group by pr.Product_ID
 )
 Select 
 ps.Product_ID,
 ps.[Net Revenue],
 ins.[Total Closing Stocks]
 from ProductSales ps 
 left join InventorySales ins on ps.Product_ID = ins.Product_ID
 where ps.[Net Revenue] > (Select AVG([Net Revenue]) from ProductSales)
 and ins.[Total Closing Stocks] < (Select AVG([Total Closing Stocks]) from InventorySales)
order by ps.Product_ID ,
ps.[Net Revenue] desc,
ins.[Total Closing Stocks] asc
