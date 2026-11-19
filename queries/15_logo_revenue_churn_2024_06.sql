-- Title: Logo and revenue churn: 2024-06
-- Question: What are the logo and revenue churn rates in 2024-06?
-- Source: RavenStack (Kaggle), SQLite

with month_start_base as (
select
mrr_amount,
end_date
from subscriptions
where is_trial = 0
and start_date <= '2024-06-01'
and (end_date is null or end_date >= '2024-06-01')
)

select
count(*) as base_subscriptions,
sum(case when end_date < '2024-07-01' then 1 else 0 end) as lost_subscriptions,
sum(mrr_amount) as base_mrr,
sum(case when end_date < '2024-07-01' then mrr_amount else 0 end) as lost_mrr,
round(100.0 * sum(case when end_date < '2024-07-01' then 1 else 0 end) / count(*), 2) as logo_churn_pct,
round(100.0 * sum(case when end_date < '2024-07-01' then mrr_amount else 0 end) / sum(mrr_amount), 2) as revenue_churn_pct
from month_start_base