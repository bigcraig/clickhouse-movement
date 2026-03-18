select full_path,count(full_path) as count_path 
FROM
(
SELECT
    mac_address,
    arrayStringConcat(path, '->') AS full_path,
    lifetime AS total_time_seconds
FROM
(
    SELECT
        mac_address,
        groupArray(probe_id) AS path,
        min(timestamp) AS start_time,
        max(timestamp) AS end_time,
        max(timestamp) - min(timestamp) AS lifetime
    FROM
    (
        SELECT
            mac_address,
            probe_id,
            timestamp
        FROM
        (
            SELECT
                mac_address,
                probe_id,
                timestamp,
                LAG(probe_id) OVER (
                    PARTITION BY mac_address
                    ORDER BY timestamp
                ) AS prev_probe,
                LAG(timestamp) OVER (
                    PARTITION BY mac_address
                    ORDER BY timestamp
                ) AS prev_ts
            FROM rawdata
        )
        -- Remove consecutive duplicates and optionally short bounces under 10s
        WHERE prev_probe IS NULL 
           OR prev_probe != probe_id 
           OR (timestamp - prev_ts) > 60 -- debounce time
        ORDER BY mac_address, timestamp
    )
    GROUP BY mac_address
)
WHERE lifetime > 300  -- total life of mac_address, reduce noise 
ORDER BY total_time_seconds DESC
)
GROUP BY  full_path
order by count_path desc