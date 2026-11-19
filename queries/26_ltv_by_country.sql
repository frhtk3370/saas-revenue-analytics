-- Title: LTV by country
-- Question: What are the LTV and weighted monthly churn of each country in 2024?
-- Source: RavenStack (Kaggle), SQLite

with recursive months as (
    select '2024-01-01' as month_start
    union all
    select date(month_start, '+1 month')
    from months
    where month_start < '2024-12-01'
),

subs as (
    select
        m.month_start,
        s.subscription_id,
        a.country,
        s.mrr_amount,
        s.end_date
    from months m
    left join subscriptions s
        on s.is_trial = 0
        and s.start_date <= m.month_start
        and (s.end_date is null or s.end_date >= m.month_start)
    left join accounts a
        on a.account_id = s.account_id
),

monthly as (
    select
        month_start,
        country,
        count(subscription_id) as paid_subs,
        sum(case when end_date < date(month_start, '+1 month') then 1 else 0 end) as ended_subs,
        1.0 * sum(mrr_amount) / count(subscription_id) as arpu_per_sub
    from subs
    where country is not null
    group by month_start, country
),

segment_stats as (
    select
        country,
        sum(ended_subs) as ended_subs,
        avg(arpu_per_sub) as avg_arpu_2024,
        100.0 * sum(ended_subs) / sum(paid_subs) as weighted_churn_2024,
        avg(paid_subs) as avg_paid_subs,
        count(*) as months
    from monthly
    group by country
)

select
    country,
    ended_subs,
    round(avg_arpu_2024, 2) as avg_arpu_2024,
    round(weighted_churn_2024, 2) as weighted_churn_2024,
    round(100.0 / weighted_churn_2024, 1) as lifetime_months,
    round(avg_arpu_2024 * 100.0 / weighted_churn_2024) as ltv,
    round(avg_paid_subs) as avg_paid_subs,
    months
from segment_stats
order by ltv desc