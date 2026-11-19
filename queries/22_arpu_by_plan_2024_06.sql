-- Title: ARPU by plan: 2024-06
-- Question: What are the ARPU and MRR share of each plan in 2024-06?
-- Source: RavenStack (Kaggle), SQLite

select
plan_tier,
count(*) as paid_subs,
sum(mrr_amount) as plan_mrr,
round(1.0 * sum(mrr_amount) / count(*), 0) as arpu_per_sub,
round(100.0 * sum(mrr_amount) / sum(sum(mrr_amount)) over (), 1) as mrr_share_pct
from subscriptions
where is_trial = 0
and start_date <= '2024-06-30'
and (end_date is null or end_date >= '2024-06-01')
group by 1
order by plan_mrr desc