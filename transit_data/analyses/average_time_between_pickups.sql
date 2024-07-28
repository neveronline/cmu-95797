WITH pickup_times AS (
    SELECT
        t.pulocationid,
        l.zone,
        t.pickup_datetime,
        LAG(t.pickup_datetime) OVER (PARTITION BY t.pulocationid ORDER BY t.pickup_datetime) AS previous_pickup_datetime
    FROM
        {{ ref('mart__fact_all_taxi_trips') }} t
    JOIN
        {{ ref('mart__dim_locations') }} l
    ON
        t.pulocationid = l.locationid
)

SELECT
    zone,
    AVG(EXTRACT(EPOCH FROM (pickup_datetime - previous_pickup_datetime)) / 60) AS avg_time_between_pickups_min
FROM
    pickup_times
WHERE
    previous_pickup_datetime IS NOT NULL
GROUP BY
    zone
ORDER BY
    avg_time_between_pickups_min;