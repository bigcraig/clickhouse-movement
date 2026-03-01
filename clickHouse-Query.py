import chdb

query = """
SELECT mac_address, probe_id,min(timestamp)
FROM file('rawdata.csv', CSVWithNames)
where probe_id in ('0aff41123','006baee48','0a71576dd','018d959e5','0472e71fd')
GROUP BY mac_address,probe_id
order by mac_address;


"""

result = chdb.query(query)

print(result)
with open("dedupe.csv", "w") as f:
    f.write(result)