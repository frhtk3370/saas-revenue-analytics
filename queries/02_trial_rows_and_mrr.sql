-- Title: Trial account count
-- Question: Do all zero-MRR rows belong to trials?
-- Source: RavenStack (Kaggle), SQLite

select
is_trial,
count(*) as row_count
from subscriptions
where mrr_amount = 0
group by 1