-- Facebook and Snapchat in one common structure, with spend also converted to EUR.
-- Grain: one row per platform per ad per day.
-- View: cheap to keep, read only by the marts.

with unioned as (
    select * from {{ ref('int_facebook_ads__daily') }}
    union all
    select * from {{ ref('int_snapchat_ads__daily') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['u.platform', 'u.ad_id', 'u.date_day']) }} as marketing_spend_id,
    u.platform,
    u.date_day,
    u.account_id,
    u.account_name,
    u.campaign_id,
    u.campaign_name,
    u.ad_group_id,
    u.ad_group_name,
    u.ad_id,
    u.ad_name,
    u.currency_code,
    u.spend,
    cast(u.spend * fx.rate_to_eur as decimal(18, 6)) as spend_eur,
    u.impressions,
    u.clicks
from unioned as u
left join {{ ref('currency_rates_to_eur') }} as fx
    on u.currency_code = fx.currency_code
