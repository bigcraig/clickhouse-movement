import chdb

query = """
SELECT
    path_str,
    count() AS occurrences
FROM
(
    SELECT
        mac_address,
        arrayStringConcat(groupArray(probe_id), ' -> ') AS path_str,
        min(timestamp)
    FROM
    (
        SELECT *
        FROM file(
            'dedupe_clean.csv',
            CSV,
            'mac_address String, probe_id String, timestamp DateTime64(3)'
        )
        ORDER BY mac_address, timestamp
    )
    GROUP BY mac_address
    HAVING count() > 1
)
GROUP BY path_str
ORDER BY occurrences DESC
"""

print(chdb.query(query))

'''
Sort first

Then group

Then build path

Then group paths

Then count 
'''