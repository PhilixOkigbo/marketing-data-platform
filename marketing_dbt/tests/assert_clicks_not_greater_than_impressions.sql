-- A click requires an impression, so clicks > impressions signals bad source data.
select *
from {{ ref('fct_marketing_spend') }}
where clicks > impressions
