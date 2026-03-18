-- INTERSECT: cleanest, returns unique MACs only
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
SELECT mac_address
FROM public.rawdata, params
WHERE probe_id = '0992c7d5f'
  AND (
    ("timestamp" >= params.a_day1_start AND "timestamp" < params.a_day1_end)
    OR
    ("timestamp" >= params.a_day2_start AND "timestamp" < params.a_day2_end)
    OR
    ("timestamp" >= params.a_day3_start AND "timestamp" < params.a_day3_end)
    OR
    ("timestamp" >= params.a_day4_start AND "timestamp" < params.a_day4_end)
  )

INTERSECT

SELECT mac_address
FROM public.rawdata, params
WHERE probe_id = '0d07ce7d1'
  AND (
    ("timestamp" >= params.b_day1_start AND "timestamp" < params.b_day1_end)
    
  );
