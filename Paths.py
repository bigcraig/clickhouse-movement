# needed to remove the " quotes" around the data from the csv file 
import chdb

query = """
SELECT
    
    mac_address,
    arrayStringConcat(groupArray(probe_id), ' -> ') AS path_str,
    max(timestamp) -min(timestamp) as DeltaT
FROM
(
    SELECT *
    FROM file('dedupe_clean.csv', 'CSV', 'mac_address String, probe_id String, timestamp DateTime64(3)')
    ORDER BY mac_address, timestamp
)

GROUP BY mac_address

having path_str like '%->%'
order by DeltaT desc  limit 100
"""

result = chdb.query(query)
print(result)