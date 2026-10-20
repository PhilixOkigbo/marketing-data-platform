-- Grain: one row per ad.
select
    cast(ad_id as string)                   as ad_id,
    cast(ad_name as string)                 as ad_name,
    cast(ad_group_id as string)             as ad_group_id,
    cast(campaign_id as string)             as campaign_id,
    cast(account_id as string)              as account_id,
    lower(ad_status)                        as ad_status,
    cast(ad_updated_at as timestamp)        as ad_updated_at
from {{ source('facebook_ads', 'new_ads_de_randomized') }}
