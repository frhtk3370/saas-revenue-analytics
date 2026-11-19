-- Title: Net MRR growth rate
-- Question: How does MRR grow from month to month?
-- Source: RavenStack (Kaggle), SQLite

with growth as (
select
    month_start,
    total_mrr,
    lag(total_mrr) over (order by month_start) as prev_total_mrr,
    net_change
from monthly_mrr
)

select
    month_start,
    total_mrr,
    prev_total_mrr,
    net_change,
    round(100.0 * net_change / prev_total_mrr, 2) as growth_pct
from growth
where prev_total_mrr is not null