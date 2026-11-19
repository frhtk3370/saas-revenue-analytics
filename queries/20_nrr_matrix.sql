-- Title: NRR matrix
-- Question: What is the net revenue retention of each monthly cohort by months since start?
-- Source: RavenStack (Kaggle), SQLite

with cm as (
select
account_id,
min(month_start) as cohort_month
from account_month_mrr
where account_mrr > 0
group by account_id
),

ms as (
select
a.account_id,
a.account_mrr,
c.cohort_month,
((cast(strftime('%Y', a.month_start) as integer) - cast(strftime('%Y', c.cohort_month) as integer)) * 12
+ cast(strftime('%m', a.month_start) as integer) - cast(strftime('%m', c.cohort_month) as integer)) as months_since
from account_month_mrr a
join cm c on a.account_id = c.account_id
),

matrix as (
select
sum(account_mrr) as cohort_mrr,
cohort_month,
months_since
from ms
where months_since >= 0
group by cohort_month, months_since
),

base as (
select
cohort_month,
cohort_mrr as base_mrr
from matrix
where months_since = 0
)

select
m.cohort_month,
m.months_since,
m.cohort_mrr,
b.base_mrr,
round(100.0 * m.cohort_mrr / b.base_mrr, 2) as nrr_pct
from matrix m
join base b on m.cohort_month = b.cohort_month
order by m.cohort_month, m.months_since