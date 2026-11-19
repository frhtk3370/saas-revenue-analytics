-- Title: End date vs. churn flag
-- Question: How are `churn_flag` and a missing `end_date` related?
-- Source: RavenStack (Kaggle), SQLite

select
churn_flag,
case when end_date is null then 'empty' else 'filled' end as end_date_status,
count(*) as row_count
from subscriptions
group by 1, 2
order by 1, 2