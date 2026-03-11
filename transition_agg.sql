# this script gives transitions for each mac with total path tiemstamp
# which we can filter on the DeltaT for the trasnstion

SELECT
    mac_address,
    arrayStringConcat(groupArray(probe_id), ' -> ') AS path_str,
    max(timestamp) - min(timestamp) AS DeltaT
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
        FROM   
  rawdata    )
    WHERE prev_probe IS NULL OR prev_probe != probe_id  
    ORDER BY mac_address, timestamp
)
GROUP BY mac_address
HAVING path_str LIKE '%->%' AND DeltaT >1000
ORDER BY DeltaT ASC
LIMIT 100