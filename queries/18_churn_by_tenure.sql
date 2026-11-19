-- Title: Churn by tenure
-- Question: How does the churn rate change across subscription tenure stages?
-- Source: RavenStack (Kaggle), SQLite

with td as (
select
account_id,
julianday(coalesce(end_date, '2024-12-31')) - julianday(start_date) as tenure_days,
case when end_date is null then 1 else 0 end as is_active
from subscriptions
where is_trial = 0
),

buckets as (
select
count(*) as total_subs,
sum(case when is_active = 0 then 1 else 0 end) as ended_subs,
case when tenure_days < 90 then '1_0-3m'
     when tenure_days < 180 then '2_3-6m'
     when tenure_days < 270 then '3_6-9m'
     else '4_9m+' end as bucket
from td
group by 3
order by 3
),

at_risk as (
select
*,
sum(total_subs) over (order by bucket rows between current row and unbounded following) as at_risk_subs
from buckets
)

select
*,
round(100.0 * ended_subs / at_risk_subs, 2) as churn_pct
from at_risk