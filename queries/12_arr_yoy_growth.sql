-- Title: ARR and year-over-year growth
-- Question: How does ARR change compared to the same month last year?
-- Source: RavenStack (Kaggle), SQLite

with arr_calc as (
select
    month_start,
    total_mrr,
    total_mrr * 12 as arr
from monthly_mrr
),
arr_yoy as (
select
    month_start,
    total_mrr,
    arr,
    lag(arr, 12) over (order by month_start) as prev_year_arr
from arr_calc
)

select
    month_start,
    total_mrr,
    arr,
    prev_year_arr,
    round(100.0 * (arr - prev_year_arr) / prev_year_arr, 2) as yoy_pct
from arr_yoy
where prev_year_arr is not null