-- Title: Monthly logo and revenue churn
-- Question: What are the logo and revenue churn rates in each month?
-- Source: RavenStack (Kaggle), SQLite

with recursive months as (
    select '2023-01-01' as month_start
    union all
    select date(month_start, '+1 month')
    from months
    where month_start < '2024-12-01'
)

select
m.month_start,
count(s.mrr_amount) as base_subscriptions,
sum(case when end_date < date(m.month_start, '+1 month') then 1 else 0 end) as lost_subscriptions,
sum(case when end_date < date(m.month_start, '+1 month') then mrr_amount else 0 end) as lost_mrr,
round(100.0 * sum(case when end_date < date(m.month_start, '+1 month') then 1 else 0 end) / count(s.mrr_amount), 2) as logo_churn_pct,
round(100.0 * sum(case when end_date < date(m.month_start, '+1 month') then mrr_amount else 0 end) / sum(mrr_amount), 2) as revenue_churn_pct
from months m
left join subscriptions s on
s.is_trial = 0 and s.start_date <= m.month_start
and (s.end_date is null or s.end_date >= m.month_start)
group by 1