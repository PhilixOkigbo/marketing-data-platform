-- Grain: one row per ad per day.
-- Raw columns are strings (bronze keeps the file as-is); types are set here.
with source as (
    select * from {{ source('facebook_ads', 'ads_stats') }}
)

select
    cast(ad_id as string)                                   as ad_id,
    cast(account_id as string)                              as account_id,
    cast(ad_date as date)                                   as date_day,
    coalesce(try_cast(ad_spend as decimal(18, 6)), 0)       as spend,
    -- Missing impressions/clicks in the export mean "none recorded" -> 0
    coalesce(try_cast(ad_impressions as bigint), 0)         as impressions,
    coalesce(try_cast(ad_clicks as bigint), 0)              as clicks
from source
