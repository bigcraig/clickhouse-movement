import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(
    host=os.getenv("PGHOST"),
    port=os.getenv("PGPORT"),
    dbname=os.getenv("PGDATABASE"),
    user=os.getenv("PGUSER"),
    password=os.getenv("PGPASSWORD"),
    sslmode="require",
)

with conn.cursor() as cur:
    cur.execute("""
        SELECT *
        FROM rawdata
        WHERE rssi < -72   
        ORDER BY timestamp DESC
        LIMIT 5
    """)
    rows = cur.fetchall()

for row in rows:
    print(row)

conn.close()
