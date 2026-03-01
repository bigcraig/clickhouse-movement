import os
from sqlalchemy import create_engine, Column, Integer, String, BigInteger, desc
from sqlalchemy.orm import declarative_base, sessionmaker
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
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD_QUOTED}@{DB_HOST}:{DB_PORT}/{DB_NAME}?sslmode=require",
    echo=True,
    pool_pre_ping=True
)

Base = declarative_base()
SessionLocal = sessionmaker(bind=engine)

class RawData(Base):
    __tablename__ = "rawdata"
    id = Column(Integer, primary_key=True)
    probeNo = Column("probe_id", String)   # <-- actual DB column
    timestamp = Column("timestamp", BigInteger)
    rssi = Column("rssi", Integer)

session = SessionLocal()
try:
    last_rows = session.query(RawData)\
        .order_by(desc(RawData.timestamp))\
        .limit(10)\
        .all()

    for row in last_rows:
        print(f"id={row.id}, probeNo={row.probeNo}, timestamp={row.timestamp}, rssi={row.rssi}")
finally:
    session.close()

