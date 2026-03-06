# this script imports the raw data and only keeps the first ping from each 
# probe for each mac. 
import chdb

query = """
SELECT mac_address, probe_id,min(fromUnixTimestamp64Milli(timestamp))
FROM file('rawdata.csv', CSVWithNames)
where probe_id in ('0aff41123','006baee48','0a71576dd','018d959e5','0472e71fd')
GROUP BY mac_address,probe_id
order by mac_address,min(timestamp);


"""

result = chdb.query(query)

print(result)
with open("dedupe.csv", "wb") as f:
    f.write(result.bytes())