WITH prcp_any_by_day AS (
    SELECT
        date,
        (prcp + snow) > 0 AS prcp_any
    FROM
        {{ ref('stg__central_park_weather') }}
),
final AS (
    SELECT
        p.date,
        prcp_any,
        LEAD(prcp_any) OVER (ORDER BY p.date) AS prcp_any_next,
        ttd.trips AS trips_today,
        ttd.trips - ttm.trips AS trips_delta
    FROM
        prcp_any_by_day p
    JOIN
        {{ ref('mart__fact_all_trips_daily') }} ttd
    ON
        p.date = ttd.date AND ttd.type = 'bike'
    JOIN
        {{ ref('mart__fact_all_trips_daily') }} ttm
    ON
        (p.date + INTERVAL '1 day') = ttm.date AND ttm.type = 'bike'
)

SELECT
    AVG(trips_delta / trips_today) AS reduction_in_trips
FROM
    final
WHERE
    prcp_any_next AND NOT prcp_any;