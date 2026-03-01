import os
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("PGHOST")
DB_PORT = os.getenv("PGPORT")
DB_NAME = os.getenv("PGDATABASE")
DB_USER = os.getenv("PGUSER")
DB_PASSWORD = os.getenv("PGPASSWORD")

DB_PASSWORD_QUOTED = quote_plus(DB_PASSWORD)
engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD_QUOTED}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=require"
)

# Load data into a DataFrame
df = pd.read_sql("SELECT * FROM rawdata where timestamp  < 1771678800000 and timestamp > 1771677000000 ", engine)

# Export to CSV
df.to_csv("rawdata.csv", index=False)

# Or export to Parquet (better for large datasets)
df.to_parquet("rawdata.parquet", index=False)

