# This query will aggregate all node transistions with a total trip time > 60 secs

WITH paths AS
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
                ) AS prev_probe
            FROM rawdata
        )
        WHERE prev_probe IS NULL OR prev_probe != probe_id
        ORDER BY mac_address, timestamp
    )
    GROUP BY mac_address
)

SELECT
    transition.1 AS from_probe,
    transition.2 AS to_probe,
    count() AS transition_count
FROM
(
    SELECT
        arrayJoin(
            arrayZip(
                arraySlice(path,1,length(path)-1),
                arraySlice(path,2)
            )
        ) AS transition
    FROM paths
    WHERE
        length(path) > 1
        
        AND lifetime > 600   /* only macs with a longer lifetime considered */
)
GROUP BY
    from_probe,
    to_probe
ORDER BY transition_count DESC