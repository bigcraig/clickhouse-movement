Project to generate movement reports combining postgres and clickhouse
firstly grab a time slice of data from azure then deduplicate probe entries
. The deduplicated table is then grouped by mac. probe.,time  to form a movement log
. The movement log is then put through Clickhouse to form a path map
