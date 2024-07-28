WITH weather_data AS (
    SELECT
        date,
        prcp,
        AVG(prcp) OVER (
            ORDER BY date
            ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
        ) AS moving_avg_prcp
    FROM
        {{ ref('stg__central_park_weather') }}
)

SELECT
    date,
    prcp,
    moving_avg_prcp
FROM
    weather_data
ORDER BY
    date;