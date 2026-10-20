-- Grain: one row per ad.
select
    cast(ad_id as string)                       as ad_id,
    cast(ad_name as string)                     as ad_name,
    cast(ad_group_id as string)                 as ad_group_id,
    cast(ad_detail_updated_at as timestamp)     as ad_updated_at
from {{ source('snapchat_ads', 'snapchat_ads_ad_history_new_ad_names') }}
