{{ config(materialized='ephemeral') }}
-- Snapchat daily stats rolled up from ad x day x country to ad x day (to match Facebook),
-- enriched with ad, ad group and campaign attributes.
-- Grain: one row per ad per day. Ephemeral: only used by int_marketing_ads.

with daily as (
    select
        ad_id,
        date_day,
        currency_code,
        sum(spend)          as spend,
        sum(impressions)    as impressions,
        sum(clicks)         as clicks
    from {{ ref('stg_snapchat_ads__ad_stats') }}
    group by ad_id, date_day, currency_code
)

select
    'snapchat'              as platform,
    d.date_day,
    c.account_id,
    cast(null as string)    as account_name,   -- Snapchat export has no account names
    g.campaign_id,
    c.campaign_name,
    a.ad_group_id,
    g.ad_group_name,
    d.ad_id,
    a.ad_name,
    d.currency_code,
    d.spend,
    d.impressions,
    d.clicks
from daily as d
left join {{ ref('stg_snapchat_ads__ads') }} as a
    on d.ad_id = a.ad_id
left join {{ ref('stg_snapchat_ads__ad_groups') }} as g
    on a.ad_group_id = g.ad_group_id
left join {{ ref('stg_snapchat_ads__campaigns') }} as c
    on g.campaign_id = c.campaign_id
