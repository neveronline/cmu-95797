WITH trip_durations AS (
    SELECT
        l.borough,
        l.zone,
        t.pulocationid,
        t.dolocationid,
        t.duration_min
    FROM
        {{ ref('mart__fact_all_taxi_trips') }} t
    JOIN
        {{ ref('mart__dim_locations') }} l
    ON
        t.pulocationid = l.locationid
)

SELECT
    borough,
    zone,
    COUNT(*) AS trip_count,
    AVG(duration_min) AS average_duration_min
FROM
    trip_durations
GROUP BY
    borough,
    zone;