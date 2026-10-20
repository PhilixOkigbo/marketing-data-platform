-- Total spend per platform in the final model must equal total spend in the raw data.
-- Catches rows lost or duplicated by joins, deduplication or the incremental logic.
with model as (
    select platform, sum(spend) as spend
    from {{ ref('fct_marketing_spend') }}
    group by platform
),

source as (
    select 'facebook' as platform, sum(try_cast(ad_spend as decimal(18, 6))) as spend
    from {{ source('facebook_ads', 'ads_stats') }}
    union all
    select 'snapchat' as platform, sum(try_cast(ad_spend as decimal(18, 6))) as spend
    from {{ source('snapchat_ads', 'snapchat_ads_stats') }}
)

select source.platform, source.spend as source_spend, model.spend as model_spend
from source
left join model on source.platform = model.platform
where abs(coalesce(model.spend, 0) - coalesce(source.spend, 0)) > 0.01
