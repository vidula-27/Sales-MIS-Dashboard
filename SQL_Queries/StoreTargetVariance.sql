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
