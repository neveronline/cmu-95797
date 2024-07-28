WITH trips_by_borough AS (
    SELECT
        l.borough,
        COUNT(*) AS trip_count
    FROM
        {{ ref('mart__fact_all_taxi_trips') }} t
    JOIN
        {{ ref('mart__dim_locations') }} l
    ON
        t.pulocationid = l.locationid
    GROUP BY
        l.borough
)

SELECT
    *
FROM
    trips_by_borough
PIVOT (
    SUM(trip_count)
    FOR borough IN ('Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island')
);