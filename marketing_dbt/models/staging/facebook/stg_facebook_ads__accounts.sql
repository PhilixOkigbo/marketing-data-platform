-- Grain: one row per ad account. Currency lives here, not on the stats table.
select
    cast(account_id as string)              as account_id,
    cast(account_name as string)            as account_name,
    upper(ad_currency_code)                 as currency_code,
    cast(account_created_at as timestamp)   as account_created_at,
    cast(account_updated_at as timestamp)   as account_updated_at
from {{ source('facebook_ads', 'new_acccount_de_randomized') }}
