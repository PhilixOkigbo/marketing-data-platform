-- Grain: one row per ad per day per country (Snapchat reports by country).
-- Rolled up to ad x day in int_snapchat_ads__daily.
-- Spend is already in normal currency units (not micro-currency).
with source as (
    select * from {{ source('snapchat_ads', 'snapchat_ads_stats') }}
)

select
    cast(ad_detail_id as string)                            as ad_id,
    cast(ad_date as date)                                   as date_day,
    lower(ad_country)                                       as country_code,
    upper(ad_currency_code)                                 as currency_code,
    coalesce(try_cast(ad_spend as decimal(18, 6)), 0)       as spend,
    coalesce(try_cast(ad_impressions as bigint), 0)         as impressions,
    coalesce(try_cast(ad_clicks as bigint), 0)              as clicks
from source
