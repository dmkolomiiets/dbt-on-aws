{{
    config(
        schema='analytics',
        materialized='incremental',
        file_format='hudi',
        incremental_strategy='merge',
        unique_key='allergy_id',
        pre_hook=['SET ark.sql.legacy.allowNonEmptyLocationInCTAS=true', 'SET mapreduce.input.fileinputformat.input.dir.recursive=true']
    )
}}
select * from  {{ source('imdb_analytics', 'genre_titles') }}
