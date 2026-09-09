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
