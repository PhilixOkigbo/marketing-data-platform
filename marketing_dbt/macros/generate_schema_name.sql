{#-
    Schema naming per environment:
      prod     -> clean layer names:            production.staging / .intermediate / .marts
      dev, ci  -> prefixed with the target schema so developers / PRs never collide:
                  development.dbt_chinedu_marts, ci_development.pr_12_marts
-#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- elif target.name == 'prod' -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
