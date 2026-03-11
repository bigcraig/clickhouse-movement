SELECT
path,
count(path) as count_path
FROM
 (
 SELECT
    mac_address,
    groupArray(probe_id) AS path,
    length(groupArray(probe_id)) AS path_length,
    min(timestamp) AS first_seen,
    max(timestamp) AS last_seen, (last_seen -first_seen) as  deltaT
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
            ) AS prev_probe
        FROM rawdata
    )
    WHERE prev_probe IS NULL OR prev_probe != probe_id
    ORDER BY mac_address, timestamp
)
GROUP BY mac_address   having deltaT > 0
 )
 GROUP BY path
 order by count_path
