-- Title: Total MRR trend data
-- Question: What is the total MRR in each month?
-- Source: RavenStack (Kaggle), SQLite

select
month_start,
total_mrr
from monthly_mrr
order by month_start