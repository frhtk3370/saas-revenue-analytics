-- Title: Gross and net revenue churn
-- Question: What are the gross and net revenue churn rates in each month?
-- Source: RavenStack (Kaggle), SQLite

with mrr_month_prev as (
select
*,
lag(total_mrr, 1) over (order by month_start) as prev_tot_mrr
from monthly_mrr
)

select
month_start,
round(-100.0 * (churned_mrr + contraction_mrr) / prev_tot_mrr, 2) as gross_churn_pct,
round(-100.0 * (churned_mrr + contraction_mrr + expansion_mrr) / prev_tot_mrr, 2) as net_churn_pct
from mrr_month_prev
where prev_tot_mrr is not null
group by month_start
order by month_start