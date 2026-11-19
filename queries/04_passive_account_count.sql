-- Title: Passive account count
-- Question: How many accounts have no active paid subscription?
-- Source: RavenStack (Kaggle), SQLite
-- Notes: An account can have multiple subscriptions, so rows are first grouped per account.
with flag as (
select
account_id,
sum(case when end_date is null and is_trial = 0 then 1 else 0 end) as active_count
from subscriptions
group by 1)

select
count(*) as passive_accs
from flag
where active_count = 0