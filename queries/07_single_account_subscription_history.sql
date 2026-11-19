-- Title: Single-account subscription history
-- Question: What does the subscription history of one sample account look like?
-- Source: RavenStack (Kaggle), SQLite

select
start_date,
end_date,
plan_tier,
mrr_amount
from subscriptions
where account_id = 'A-3c1a3f'
order by 1 asc