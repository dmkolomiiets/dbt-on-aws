{{
    config(
        schema='analytics',
        materialized='table',
        file_format='parquet',
        pre_hook=['SET ark.sql.legacy.allowNonEmptyLocationInCTAS=true', 'SET mapreduce.input.fileinputformat.input.dir.recursive=true']
    )
}}
select * from  {{ source('fdr_2121', 'inspec_allergy2') }}
