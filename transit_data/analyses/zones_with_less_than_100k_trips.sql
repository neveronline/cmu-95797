WITH trip_counts AS (
    SELECT
        l.zone,
        COUNT(*) AS trip_count
    FROM
        {{ ref('mart__fact_all_taxi_trips') }} t
    JOIN
        {{ ref('mart__dim_locations') }} l
    ON
        t.pulocationid = l.locationid
    GROUP BY
        l.zone
)

SELECT
    zone,
    trip_count
FROM
    trip_counts
WHERE
    trip_count < 100000;