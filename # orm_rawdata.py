# orm_rawdata.py

import os
from urllib.parse import quote_plus
from sqlalchemy import create_engine, Column, Integer, BigInteger, String
from sqlalchemy.orm import declarative_base, sessionmaker
from dotenv import load_dotenv

load_dotenv()


# -----------------------------
# 1️⃣ Database connection
# -----------------------------



# parse connection string from .env file
DB_HOST=os.getenv("PGHOST")
DB_PORT=os.getenv("PGPORT")
DB_NAME=os.getenv("PGDATABASE")
DB_USER=os.getenv("PGUSER"),
DB_PASSWORD=os.getenv("PGPASSWORD")

DB_HOST = "ba10-db.postgres.database.azure.com"
DB_PORT = 5432
DB_NAME = "ba10db"
DB_USER = "ba10db_user@ba10-db"
DB_PASSWORD = "RAVING-elastic-fondly-abuela"

# SQLAlchemy engine without URL parsing username@server
engine = create_engine(
    f"postgresql+psycopg2://{DB_HOST}:{DB_PORT}/{DB_NAME}",
    connect_args={
        "user": DB_USER,
        "password": DB_PASSWORD,
        "sslmode": "require"
    },
    pool_pre_ping=True,
    echo=True
)




SessionLocal = sessionmaker(bind=engine)

Base = declarative_base()

# -----------------------------
# 2️⃣ ORM model
# -----------------------------
class RawData(Base):
    __tablename__ = "rawdata"

    id = Column(Integer, primary_key=True)
    probeNo = Column(String)
    timestamp = Column(BigInteger)
    rssi = Column(Integer)

    def __repr__(self):
        return (
            f"<RawData(id={self.id}, probeNo={self.probeNo}, "
            f"timestamp={self.timestamp}, rssi={self.rssi})>"
        )

# -----------------------------
# 3️⃣ ORM query (LIMIT 1)
# -----------------------------
def main():
    session = SessionLocal()

    try:
        row = session.query(RawData).first()
        print(row)

    finally:
        session.close()

# -----------------------------
# 4️⃣ Entry point
# -----------------------------
if __name__ == "__main__":
    main()
