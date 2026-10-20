-- Grain: one row per ad group (ad set).
select
    cast(ad_group_id as string)             as ad_group_id,
    cast(ad_group_name as string)           as ad_group_name,
    cast(ad_group_updated_at as timestamp)  as ad_group_updated_at
from {{ source('facebook_ads', 'new_adgroup_de_randomized') }}
