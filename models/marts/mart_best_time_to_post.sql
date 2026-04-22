with video_data as (
    select * from {{ ref('int_videos_with_time') }}
)

select
    publish_hour,
    publish_day_of_week,
    publish_day_name,
    category_name,
    country_code,
    count(distinct video_id) as trending_video_count,
    avg(views) as avg_views,
    avg(likes) as avg_likes,
    count(distinct video_id) as total_videos
from video_data
group by 1, 2, 3, 4, 5
order by trending_video_count desc