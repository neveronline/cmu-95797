select count(*) as trips
from {{ ref('mart__fact_all_taxi_trips') }} trips
join {{ ref('mart__dim_locations') }} drop_locations on trips.DOlocationID = drop_locations.LocationID
where drop_locations.service_zone in ('Airports', 'EWR')
group by all