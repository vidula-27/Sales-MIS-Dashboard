--2. What are the bottom 10 products by net revenue?
Select top 10 p.Product_Name,
       cast(sum(s.Quantity * s.Unit_Price * (1 - s.Discount )) as decimal(10 ,2)) as 'Revenue'
from SalesInventoryMIS.dbo.Sales s
left outer join SalesInventoryMIS.dbo.Stores st on s.Store_ID = st.Store_ID
left outer join SalesInventoryMIS.dbo.Products p on p.Product_ID = s.Product_ID
group by p.Product_Name
order by sum(s.Quantity * s.Unit_Price * (1 - s.Discount ))
