Select 
s.Payment_Mode,
count(*) as 'No. of Transactions'
from SalesInventoryMIS.dbo.Sales s
group by s.Payment_Mode
order by [No. of Transactions] desc
