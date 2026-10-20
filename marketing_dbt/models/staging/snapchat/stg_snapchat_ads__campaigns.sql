-- Grain: one row per campaign. Snapchat has no account table; account_id comes from here.
select
    cast(campaign_id as string)     as campaign_id,
    cast(campaign_name as string)   as campaign_name,
    cast(account_id as string)      as account_id
from {{ source('snapchat_ads', 'snapchat_ads_campaign_history_new_campaign_names') }}
