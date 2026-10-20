-- Grain: one row per ad group.
-- The raw table is a history table (an ad group can appear more than once);
-- keep only the most recent version.
select
    cast(ad_group_id as string)                 as ad_group_id,
    cast(ad_group_name as string)               as ad_group_name,
    cast(campaign_id as string)                 as campaign_id,
    cast(ad_group_updated_at as timestamp)      as ad_group_updated_at
from {{ source('snapchat_ads', 'snapchat_ads_adgroup_history_new_ad_group_names') }}
qualify row_number() over (
    partition by ad_group_id
    order by cast(ad_group_updated_at as timestamp) desc
) = 1
