WITH params AS (
  SELECT
    -- Probe A: 0992c7d5f (4 days)
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-14 00:00:00+11') * 1000)::int8 AS a_day1_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-15 00:00:00+11') * 1000)::int8 AS a_day1_end,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-21 00:00:00+11') * 1000)::int8 AS a_day2_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-22 00:00:00+11') * 1000)::int8 AS a_day2_end,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-28 00:00:00+11') * 1000)::int8 AS a_day3_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-01 00:00:00+11') * 1000)::int8 AS a_day3_end,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-07 00:00:00+11') * 1000)::int8 AS a_day4_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-08 00:00:00+11') * 1000)::int8 AS a_day4_end,

    -- Probe B: 0d07ce7d1 (3 days)
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-13 00:00:00+11') * 1000)::int8 AS b_day1_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-16 00:00:00+11') * 1000)::int8 AS b_day1_end,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-10 00:00:00+11') * 1000)::int8 AS b_day2_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-11 00:00:00+11') * 1000)::int8 AS b_day2_end,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-15 00:00:00+11') * 1000)::int8 AS b_day3_start,
    (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-16 00:00:00+11') * 1000)::int8 AS b_day3_end
)





SELECT mac_address,
  to_timestamp("timestamp" / 1000.0) 
    AT TIME ZONE 'Australia/Sydney' AS readable_time,
  CASE probe_id
    WHEN '0992c7d5f' THEN 'Fish Market'
    WHEN '0d07ce7d1' THEN 'Rocks Market'
    ELSE probe_id
  END AS probe_name
FROM rawdata ,params
WHERE mac_address in ( '14:9c:ef:37:e8:87','54:91:af:42:11:28','60:32:3b:47:ad:1e','74:b8:39:61:33:1d',
'c1:22:33:44:93:89','bb:0b:b8:14:ba:9f','40:79:12:87:47:0a','c5:32:05:0e:b3:e2','44:6f:f8:6b:3d:7a',
'cd:fc:12:df:de:9b','2d:2e:17:c6:cd:32','fc:a8:9b:51:6b:50','a0:28:84:11:71:f7','e4:fa:5b:78:08:38',
'c4:ae:e2:0a:3f:d2','e4:fa:5b:c1:b7:6a','88:13:bf:a2:6b:5a','40:79:12:20:09:75','44:27:f3:9a:ef:f7',
'fc:b4:67:12:8f:c2','54:91:af:41:58:d3','2c:bc:bb:6b:06:0e','60:32:3b:47:b1:2c','da:0d:d5:42:4e:94',
'd6:19:c3:4e:7f:6b','c1:cd:f6:0c:ed:d9','94:54:93:1e:92:77','60:32:3b:47:a6:82','fc:a8:9b:2b:b3:e3',
'14:13:0b:8b:c1:8f','20:98:ed:04:bd:ca','3c:1a:cc:9c:61:29','d0:7e:cf:e9:ff:b8','50:26:ef:59:ed:4b',
'44:37:0b:e7:34:64','a8:96:09:cd:b6:f1','4c:50:dd:3b:f0:81','fd:25:18:b7:ad:69','88:13:bf:a4:56:92','28:f5:2b:a5:26:49',
'34:90:ea:a3:c3:2d','20:1c:3a:1a:f6:3b','44:27:f3:95:ca:9e','cf:2a:ad:98:5b:d8','f1:92:be:b9:ac:55')

and (
probe_id = '0992c7d5f'
  AND (
    ("timestamp" >= params.a_day1_start AND "timestamp" < params.a_day1_end)
    OR
    ("timestamp" >= params.a_day2_start AND "timestamp" < params.a_day2_end)
    OR
    ("timestamp" >= params.a_day3_start AND "timestamp" < params.a_day3_end)
    OR
    ("timestamp" >= params.a_day4_start AND "timestamp" < params.a_day4_end)
  )

or

(
probe_id = '0d07ce7d1'
  AND (
    ("timestamp" >= params.b_day1_start AND "timestamp" < params.b_day1_end)
    
  )
) 
)
order by mac_address,timestamp asc



/*
  AND "timestamp" < (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-03-16 00:00:00+11') * 1000)::int8
  AND "timestamp" > (EXTRACT(EPOCH FROM TIMESTAMPTZ '2026-02-14 00:00:00+11') * 1000)::int8
  AND probe_id IN ('0992c7d5f', '0d07ce7d1')
ORDER BY mac_address, "timestamp" ASC   */