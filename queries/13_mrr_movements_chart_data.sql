-- Title: MRR movements chart data
-- Question: What are the monthly MRR movements to plot, excluding the first month?
-- Source: RavenStack (Kaggle), SQLite
-- Notes: 2023-01 is excluded because all MRR appears as new in the first month.

select
*
from monthly_mrr
where month_start > '2023-01-01'
order by month_start