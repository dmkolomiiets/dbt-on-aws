{{
    config(
        schema='analytics',
        materialized='table',
        location_root="s3://emr-eks-default-683131678078-us-east-1/",
        file_format='parquet',
        pre_hook=['SET ark.sql.legacy.allowNonEmptyLocationInCTAS=true', 'SET mapreduce.input.fileinputformat.input.dir.recursive=true']
    )
}}
select * from  {{ source('imdb_analytics', 'genre_titles') }}
