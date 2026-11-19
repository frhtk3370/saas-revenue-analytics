-- Title: GRR matrix
-- Question: What is the GRR of each monthly cohort by months since start?
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

grr_base as (
select
account_id,
cohort_month,
account_mrr as base_mrr
from ms
where months_since = 0
),

cap as (
select
sum(min(m.account_mrr, g.base_mrr)) as capped_mrr,
m.cohort_month,
m.months_since
from ms m
join grr_base g on g.account_id = m.account_id
where months_since >= 0
group by m.cohort_month, m.months_since
),

cohort_base as (
select
capped_mrr as base_mrr,
cohort_month
from cap
where months_since = 0
)

select
c.capped_mrr,
c.cohort_month,
c.months_since,
b.base_mrr,
round(100.0 * c.capped_mrr / b.base_mrr, 2) as grr_pct
from cap c
join cohort_base b on b.cohort_month = c.cohort_month
order by c.cohort_month, c.months_since