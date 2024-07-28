WITH weather_data AS (
    SELECT
        date,
        prcp,
        snow,
        MIN(prcp) OVER weather_window AS moving_min_prcp,
        MAX(prcp) OVER weather_window AS moving_max_prcp,
        AVG(prcp) OVER weather_window AS moving_avg_prcp,
        SUM(prcp) OVER weather_window AS moving_sum_prcp,
        MIN(snow) OVER weather_window AS moving_min_snow,
        MAX(snow) OVER weather_window AS moving_max_snow,
        AVG(snow) OVER weather_window AS moving_avg_snow,
        SUM(snow) OVER weather_window AS moving_sum_snow
    FROM
        {{ ref('stg__central_park_weather') }}
    WINDOW weather_window AS (
        ORDER BY date
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    )
)

SELECT
    date,
    prcp,
    snow,
    moving_min_prcp,
    moving_max_prcp,
    moving_avg_prcp,
    moving_sum_prcp,
    moving_min_snow,
    moving_max_snow,
    moving_avg_snow,
    moving_sum_snow
FROM
    weather_data
ORDER BY
    date;