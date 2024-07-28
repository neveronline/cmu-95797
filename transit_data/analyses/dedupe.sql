WITH events AS (
    SELECT
        STRPTIME(insert_timestamp, '%d/%m/%Y %H:%M') AS insert_timestamp,
        event_id,
        event_type,
        user_id,
        STRPTIME(event_timestamp, '%d/%m/%Y %H:%M') AS event_timestamp
    FROM
        {{ ref('events') }}
)
SELECT
    *
FROM
    events
QUALIFY
    ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY insert_timestamp DESC) = 1;