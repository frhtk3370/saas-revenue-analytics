-- Title: Upgrade and downgrade flags
-- Question: What share of paid subscriptions in each plan carries an upgrade, downgrade or churn flag?
-- Source: RavenStack (Kaggle), SQLite

select
plan_tier,
round(100.0 * sum(upgrade_flag) / count(*), 2) as upgrade_pct,
round(100.0 * sum(downgrade_flag) / count(*), 2) as downgrade_pct,
round(100.0 * sum(churn_flag) / count(*), 2) as churn_pct
from subscriptions
where is_trial = 0
group by plan_tier