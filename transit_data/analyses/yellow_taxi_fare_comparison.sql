WITH fare_data AS (
    SELECT
        t.fare_amount,
        l.zone,
        l.borough,
        AVG(t.fare_amount) OVER (PARTITION BY l.zone) AS avg_fare_zone,
        AVG(t.fare_amount) OVER (PARTITION BY l.borough) AS avg_fare_borough,
        AVG(t.fare_amount) OVER () AS avg_fare_overall
    FROM
        {{ ref('stg__yellow_tripdata') }} t
    JOIN
        {{ ref('mart__dim_locations') }} l
    ON
        t.pulocationid = l.locationid
)

SELECT
    fare_amount,
    zone,
    borough,
    avg_fare_zone,
    avg_fare_borough,
    avg_fare_overall,
    fare_amount - avg_fare_zone AS diff_from_zone_avg,
    fare_amount - avg_fare_borough AS diff_from_borough_avg,
    fare_amount - avg_fare_overall AS diff_from_overall_avg
FROM
    fare_data;