-- Grain: one row per campaign.
select
    cast(campaign_id as string)             as campaign_id,
    cast(campaign_name as string)           as campaign_name,
    cast(campaign_updated_at as timestamp)  as campaign_updated_at
from {{ source('facebook_ads', 'new_campaign_de_randomized') }}
