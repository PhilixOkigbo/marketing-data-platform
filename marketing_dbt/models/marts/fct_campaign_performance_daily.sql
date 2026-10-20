-- Campaign performance per platform per day, with CTR / CPC / CPM.
-- Grain: one row per platform per campaign per day.
--
-- Ratios are calculated AFTER summing, so they are correct at this grain.
-- Never average these ratios across rows: re-aggregate the base metrics instead
-- (e.g. CTR for a month = sum(clicks) / sum(impressions)).
-- Table: small, pre-aggregated, and the main entry point for BI and AI agents.

with campaign_daily as (
    select
        platform,
        date_day,
        campaign_id,
        max(campaign_name)      as campaign_name,
        currency_code,
        sum(spend)              as spend,
        sum(spend_eur)          as spend_eur,
        sum(impressions)        as impressions,
        sum(clicks)             as clicks
    from {{ ref('fct_marketing_spend') }}
    group by platform, date_day, campaign_id, currency_code
)

select
    {{ dbt_utils.generate_surrogate_key(['platform', 'campaign_id', 'date_day', 'currency_code']) }} as campaign_performance_id,
    platform,
    date_day,
    campaign_id,
    campaign_name,
    currency_code,
    spend,
    spend_eur,
    impressions,
    clicks,
    -- nullif -> null instead of divide-by-zero when there is no denominator
    cast(clicks / nullif(impressions, 0) as decimal(18, 6))           as ctr,
    cast(spend_eur / nullif(clicks, 0) as decimal(18, 6))             as cpc_eur,
    cast(spend_eur / nullif(impressions, 0) * 1000 as decimal(18, 6)) as cpm_eur
from campaign_daily
