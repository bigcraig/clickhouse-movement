WITH F1 AS (
  SELECT 
    mac_address,
    DATE(to_timestamp("timestamp" / 1000.0) AT TIME ZONE 'Australia/Sydney') AS visit_date,
    MIN(to_timestamp("timestamp" / 1000.0) AT TIME ZONE 'Australia/Sydney') AS first_seen
  FROM rawdata
  WHERE probe_id = '07d73c260'
    AND "timestamp" > (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-05 00:00:00+11') * 1000)::int8
    AND "timestamp" < (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-10 00:00:00+11') * 1000)::int8
  GROUP BY mac_address, DATE(to_timestamp("timestamp" / 1000.0) AT TIME ZONE 'Australia/Sydney')
  ORDER BY mac_address, visit_date
)
SELECT mac_address,
count(*) as Visits,
STRING_AGG(visit_date::TEXT, ', ' ORDER BY visit_date) AS dates_seen,
min(first_seen) as firstVisit,
max(first_seen) as LastVisit
FROM F1
GROUP BY mac_address
HAVING COUNT(*) > 1
ORDER BY Visits DESC





/* SELECT mac_address,
count(*) as visits
from F1
GROUP BY mac_address
having count(*) > 0
order by visits DESC
*/