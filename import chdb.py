# needed to remove the " quotes" around the data from the csv file 
import chdb
query = """
SELECT *
FROM file('dedupe_clean.csv', CSV, 'mac_address String, probe_id String, timestamp DateTime64(3)')
order by mac_address , timestamp
limit 80
"""

result = chdb.query(query)
print(result)
