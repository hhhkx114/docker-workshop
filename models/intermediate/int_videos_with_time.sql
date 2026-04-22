with videos as (
    select * from {{ ref('stg_youtube_videos') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
)

select
    v.video_id,
    v.title,
    v.channel_title,
    c.category_name,
    v.publish_time,
    v.trending_date,
    extract(hour from timestamp(v.publish_time)) as publish_hour,
    extract(dayofweek from timestamp(v.publish_time)) as publish_day_of_week,
    format_timestamp('%A', timestamp(v.publish_time)) as publish_day_name,
    v.views,
    v.likes,
    v.comment_count,
    v.country_code
from videos v
left join categories c on v.category_id = c.category_id