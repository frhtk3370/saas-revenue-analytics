-- Title: MRR snapshot: 2024-06
-- Question: What are the subscription counts, total MRR and average MRR in 2024-06?
-- Source: RavenStack (Kaggle), SQLite

select
sum(mrr_amount) as mrr_sum,
count(*) as active_subscriptions,
sum(case when is_trial = 0 then 1 else 0 end) as paid_subscriptions,
round(1.0 * sum(mrr_amount) / sum(case when is_trial = 0 then 1 else 0 end), 2) as avg_mrr
from subscriptions
where start_date <= '2024-06-30'
and (end_date is null or end_date >= '2024-06-01')