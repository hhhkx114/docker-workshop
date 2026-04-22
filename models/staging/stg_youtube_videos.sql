with us as (
    select *, 'US' as country_code
    from {{ source('youtube_raw', 'raw_youtube_US') }}
),

gb as (
    select *, 'GB' as country_code
    from {{ source('youtube_raw', 'raw_youtube_GB') }}
),

ca as (
    select *, 'CA' as country_code
    from {{ source('youtube_raw', 'raw_youtube_CA') }}
),

de as (
    select *, 'DE' as country_code
    from {{ source('youtube_raw', 'raw_youtube_DE') }}
),

unioned as (
    select * from us
    union all
    select * from gb
    union all
    select * from ca
    union all
    select * from de
),

cleaned as (
    select
        video_id,
        title,
        channel_title,
        category_id,
        publish_time,
        trending_date,
        cast(views as int64) as views,
        cast(likes as int64) as likes,
        cast(dislikes as int64) as dislikes,
        cast(comment_count as int64) as comment_count,
        tags,
        country_code
    from unioned
    where video_id is not null
)

select * from cleaned