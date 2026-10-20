-- The campaign mart is an aggregate of the fact table; totals must agree.
select 1
from (select sum(spend_eur) as s, sum(clicks) as c, sum(impressions) as i from {{ ref('fct_marketing_spend') }}) f
cross join (select sum(spend_eur) as s, sum(clicks) as c, sum(impressions) as i from {{ ref('fct_campaign_performance_daily') }}) m
where abs(f.s - m.s) > 0.01 or f.c != m.c or f.i != m.i
