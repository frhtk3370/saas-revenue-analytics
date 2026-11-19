-- Title: Cohort groups
-- Question: How many accounts start in each monthly cohort?
-- Source: RavenStack (Kaggle), SQLite

with cm as (
select
account_id,
min(month_start) as cohort_month
from account_month_mrr
where account_mrr > 0
group by account_id
)

select
count(account_id) as cohort_count,
cohort_month
from cm
group by cohort_month