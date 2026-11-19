-- Title: MRR views
-- Question: How does MRR move per account and month, and how does it roll up to totals?
-- Source: RavenStack (Kaggle), SQLite
-- Notes: Views depend on each other, so run this file top to bottom. An account counts as active in a month if its subscription ends on or after the first day of that month.

drop view if exists account_month_mrr;
drop view if exists mrr_movements;
drop view if exists monthly_mrr;

create view account_month_mrr as
with recursive months as (
    select '2023-01-01' as month_start
    union all
    select date(month_start, '+1 month')
    from months
    where month_start < '2024-12-01'
),
account_grid as (
    select
        m.month_start,
        a.account_id
    from months m
    cross join accounts a
),
account_mrr_by_month as (
    select
        g.month_start,
        g.account_id,
        coalesce(sum(s.mrr_amount), 0) as account_mrr
    from account_grid g
    left join subscriptions s
        on s.account_id = g.account_id
        and s.start_date <= date(g.month_start, '+1 month', '-1 day')
        and (s.end_date is null or s.end_date >= g.month_start)
    group by g.month_start, g.account_id
)
select
    month_start,
    account_id,
    account_mrr,
    lag(account_mrr, 1, 0) over (partition by account_id order by month_start) as prev_mrr
from account_mrr_by_month;

create view mrr_movements as
select
    *,
    case
        when prev_mrr = 0 and account_mrr > 0 then 'new'
        when prev_mrr > 0 and account_mrr > prev_mrr then 'expansion'
        when prev_mrr > 0 and account_mrr > 0 and account_mrr < prev_mrr then 'contraction'
        when prev_mrr > 0 and account_mrr = 0 then 'churned'
        else 'unchanged'
    end as movement_type,
    account_mrr - prev_mrr as mrr_change
from account_month_mrr;

create view monthly_mrr as
select
    month_start,
    sum(account_mrr) as total_mrr,
    sum(case when movement_type = 'new' then mrr_change else 0 end) as new_mrr,
    sum(case when movement_type = 'expansion' then mrr_change else 0 end) as expansion_mrr,
    sum(case when movement_type = 'contraction' then mrr_change else 0 end) as contraction_mrr,
    sum(case when movement_type = 'churned' then mrr_change else 0 end) as churned_mrr,
    sum(mrr_change) as net_change
from mrr_movements
group by month_start;