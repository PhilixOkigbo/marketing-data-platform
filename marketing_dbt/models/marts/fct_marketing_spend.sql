{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='marketing_spend_id',
        on_schema_change='append_new_columns'
    )
}}
-- Unified marketing fact table.
-- Grain: one row per platform per ad per day.
--
-- Incremental: this is the largest table and ad platforms only add new days (or
-- restate the last few), so each run only reprocesses recent data per platform and
-- MERGEs it on marketing_spend_id. A 3-day lookback picks up late restatements.
-- The watermark is per platform, because the platforms load on different schedules.

with source as (
    select * from {{ ref('int_marketing_ads') }}
)

{% if is_incremental() %}
, watermark as (
    select platform, max(date_day) as max_date_day
    from {{ this }}
    group by platform
)
{% endif %}

select
    source.marketing_spend_id,
    source.date_day,
    source.platform,
    source.account_id,
    source.account_name,
    source.campaign_id,
    source.campaign_name,
    source.ad_group_id,
    source.ad_group_name,
    source.ad_id,
    source.ad_name,
    source.currency_code,
    source.spend,
    source.spend_eur,
    source.impressions,
    source.clicks,
    current_timestamp() as dbt_loaded_at
from source

{% if is_incremental() %}
left join watermark
    on source.platform = watermark.platform
where watermark.max_date_day is null
   or source.date_day >= date_sub(watermark.max_date_day, 3)
{% endif %}
