-- Title: Subscriptions overview
-- Question: What are the shape and date range of the data?
-- Source: RavenStack (Kaggle), SQLite

select
count(*) as row_count,
count(distinct account_id) as unique_accounts,
min(start_date) as first_start,
max(start_date) as last_start,
min(end_date) as first_end,
max(end_date) as last_end,
sum(case when is_trial = 1 then 1 else 0 end) as trial_count,
sum(case when is_trial = 1 then mrr_amount else 0 end) as trial_mrr
from subscriptions