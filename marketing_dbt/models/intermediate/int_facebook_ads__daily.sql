{{ config(materialized='ephemeral') }}
-- Facebook daily stats enriched with ad, ad group, campaign and account attributes,
-- renamed to the shared marketing vocabulary.
-- Grain: one row per ad per day. Ephemeral: only used by int_marketing_ads.

select
    'facebook'              as platform,
    s.date_day,
    s.account_id,
    acc.account_name,
    a.campaign_id,
    c.campaign_name,
    a.ad_group_id,
    g.ad_group_name,
    s.ad_id,
    a.ad_name,
    acc.currency_code,
    s.spend,
    s.impressions,
    s.clicks
from {{ ref('stg_facebook_ads__ad_stats') }} as s
left join {{ ref('stg_facebook_ads__ads') }} as a
    on s.ad_id = a.ad_id
left join {{ ref('stg_facebook_ads__ad_groups') }} as g
    on a.ad_group_id = g.ad_group_id
left join {{ ref('stg_facebook_ads__campaigns') }} as c
    on a.campaign_id = c.campaign_id
left join {{ ref('stg_facebook_ads__accounts') }} as acc
    on s.account_id = acc.account_id
