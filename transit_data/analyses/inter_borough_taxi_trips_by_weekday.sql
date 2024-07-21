with all_trips as
(select
    -- Extract the weekday from pickup_datetime
    weekday(pickup_datetime) as weekday,
    -- Count the total number of trips
    count(*) trips
    from {{ ref('mart__fact_all_taxi_trips') }} trips
    -- Group by the weekday
    group by all),

inter_borough as
(select
    weekday(pickup_datetime) as weekday,
    count(*) as trips
from {{ ref('mart__fact_all_taxi_trips') }} trips
    -- Join with the dim_locations table to get the pickup location details
join {{ ref('mart__dim_locations') }} a on trips.PUlocationID = a.LocationID
    -- Join again with the dim_locations table to get the dropoff location details
join {{ ref('mart__dim_locations') }} b on trips.DOlocationID = b.LocationID
-- Filter to include only trips where the pickup and dropoff locations are in different boroughs
where a.borough != b.borough
group by all)

select all_trips.weekday,
       all_trips.trips as all_trips,
       inter_borough.trips as inter_borough_trips,
       inter_borough.trips / all_trips.trips as percent_inter_borough
from all_trips
join inter_borough on (all_trips.weekday = inter_borough.weekday);