--1. What are the Top 10 products by net revenue?
Select top 10 p.Product_Name,
       cast(sum(s.Quantity * s.Unit_Price * (1 - s.Discount )) as decimal(10 ,2)) as 'Revenue'
from SalesInventoryMIS.dbo.Sales s
left outer join SalesInventoryMIS.dbo.Stores st on s.Store_ID = st.Store_ID
left outer join SalesInventoryMIS.dbo.Products p on p.Product_ID = s.Product_ID
group by p.Product_Name
order by sum(s.Quantity * s.Unit_Price * (1 - s.Discount )) desc
---------------------------------------------------------------------------------------------------------------------------------------------------------------

--2. What are the bottom 10 products by net revenue?
Select top 10 p.Product_Name,
       cast(sum(s.Quantity * s.Unit_Price * (1 - s.Discount )) as decimal(10 ,2)) as 'Revenue'
from SalesInventoryMIS.dbo.Sales s
left outer join SalesInventoryMIS.dbo.Stores st on s.Store_ID = st.Store_ID
left outer join SalesInventoryMIS.dbo.Products p on p.Product_ID = s.Product_ID
group by p.Product_Name
order by sum(s.Quantity * s.Unit_Price * (1 - s.Discount ))

---------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.Which stores are generating the highest and lowest net revenue?
With StoreRevenue as (
Select 
st.Store_ID,
st.Store_Name,
cast(SUM(s.Quantity * s.Unit_Price * (1-s.Discount)) as decimal(10 ,2)) as 'Net Revenue'
from SalesInventoryMIS.dbo.Sales s
left join SalesInventoryMIS.dbo.Stores st on s.Store_ID = st.Store_ID 
group by st.Store_ID, st.Store_Name
--order by SUM(s.Quantity * s.Unit_Price * (1-s.Discount)) desc
),
StoreRanked as (Select *,
RANK()over( order by [Net Revenue] desc) as 'Store Rank'
from StoreRevenue
)
Select * from StoreRanked
where [Store Rank] =  1 
or [Store Rank] = (SELECT MAX([Store Rank]) FROM StoreRanked)
----------------------------------------------------------------------------------------------------------------------------------------------------------------

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
---------------------------------------------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------------------------------------------

--6. What are the top 3 and bottom 3 stores based on sales target variance %, and which months showed their best performance?

With NetRevenue as (
Select
s.Store_ID,
month(s.Date) as 'Month',
cast(sum(s.Unit_Price * s.Quantity * (1 - s.Discount)) as decimal(10,2)) as 'Net Revenue'
from SalesInventoryMIS.dbo.Sales s
group by s.Store_ID,month(s.Date)
),
MonthwiseTarget as (
Select 
t.Store_ID,
day(t.Month) as 'Month',
sum(t.Sales_Target) as 'Sales target'
from SalesInventoryMIS.dbo.Targets t
group by t.Store_ID,day(t.Month)
)
Select
n.Store_ID,
n.[Net Revenue],
m.[Sales target],
n.[Month],
CAST(((n.[Net Revenue] - m.[Sales target])
            / NULLIF(m.[Sales target], 0)
        ) * 100 AS DECIMAL(10,2)) AS [Variance %]
from NetRevenue n 
left join MonthwiseTarget m on n.Store_ID = m.Store_ID and n.Month = m.Month
group by n.Store_ID,
n.[Net Revenue],
m.[Sales target],n.[Month]
order by [Variance %] desc

---------------------------------------------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------------------------------------------

--8. Which customer type generates the most revenue?

Select
s.Customer_Type
,cast(sum(s.Unit_Price * s.Quantity * (1 - s.Discount)) as decimal(10,2)) as 'Net Revenue'
from SalesInventoryMIS.dbo.Sales s
group by s.Customer_Type
order by [Net Revenue] desc

---------------------------------------------------------------------------------------------------------------------------------------------------
--9.Which payment mode is most commonly used?

Select 
s.Payment_Mode,
count(*) as 'No. of Transactions'
from SalesInventoryMIS.dbo.Sales s
group by s.Payment_Mode
order by [No. of Transactions] desc
