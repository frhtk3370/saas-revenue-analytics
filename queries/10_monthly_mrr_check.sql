-- Title: Monthly MRR view check
-- Question: Do the four MRR movement columns add up to net_change in every month?
-- Source: RavenStack (Kaggle), SQLite

select
month_start,
new_mrr + expansion_mrr + contraction_mrr + churned_mrr - net_change as check_diff
from monthly_mrr
where check_diff <> 0