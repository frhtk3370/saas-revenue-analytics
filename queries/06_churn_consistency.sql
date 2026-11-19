-- Title: Churn consistency
-- Question: Do `churn_events` and `subscriptions.churn_flag` identify the same accounts?
-- Source: RavenStack (Kaggle), SQLite

with flags as (
select
a.account_id,
case when a.account_id in (select account_id from churn_events) then 1 else 0 end as in_events,
case when a.account_id in (select account_id from subscriptions where churn_flag = 1) then 1 else 0 end as in_flag
from accounts a
)

select
in_events,
in_flag,
count(*) as account_count
from flags
group by 1, 2
order by 1, 2