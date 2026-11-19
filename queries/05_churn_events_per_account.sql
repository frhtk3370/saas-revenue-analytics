-- Title: Churn events per account
-- Question: How many churn events does an account have?
-- Source: RavenStack (Kaggle), SQLite

with accs as (
select
account_id,
count(*) as acc_count
from churn_events
group by 1)

select
acc_count,
count(account_id) as user_count
from accs
group by 1
order by 1 desc