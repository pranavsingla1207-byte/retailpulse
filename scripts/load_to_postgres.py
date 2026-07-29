"""
Load the processed feature tables into PostgreSQL.

Reads the parquet files written by notebook 02 and writes four tables into a
`retailpulse` database. Column names are converted to snake_case so the SQL in
notebooks/sql stays clean (no quoted "Customer ID" everywhere).

The database password is never stored in this file. It is read from the
PGPASSWORD environment variable if set, otherwise prompted for at runtime, so
nothing sensitive is committed to git.

Run from the project root:
    python scripts/load_to_postgres.py
"""

import os
import re
import getpass

import pandas as pd
from sqlalchemy import create_engine, text

PROCESSED = os.path.join(os.path.dirname(__file__), "..", "data", "processed")
DB_NAME = "retailpulse"

# destination table name  ->  source parquet file
TABLES = {
    "sales_clean": "retail_features.parquet",
    "orders": "orders.parquet",
    "customers": "customers.parquet",
    "customer_rfm": "customer_rfm.parquet",
}


def to_snake(name):
    """'InvoiceDate' -> 'invoice_date', 'Customer ID' -> 'customer_id'."""
    name = name.strip().replace(" ", "_")
    name = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", name)
    return name.lower()


def main():
    user = os.environ.get("PGUSER", "postgres")
    password = os.environ.get("PGPASSWORD") or getpass.getpass("PostgreSQL password: ")
    host, port = "localhost", 5432

    base = f"postgresql+psycopg2://{user}:{password}@{host}:{port}"

    # 1) create the database if it does not exist.
    # CREATE DATABASE cannot run inside a transaction, so use an AUTOCOMMIT engine
    # connected to the always-present default 'postgres' database.
    admin = create_engine(f"{base}/postgres", isolation_level="AUTOCOMMIT")
    with admin.connect() as conn:
        exists = conn.execute(
            text("SELECT 1 FROM pg_database WHERE datname = :n"), {"n": DB_NAME}
        ).scalar()
        if exists:
            print(f"database '{DB_NAME}' already exists")
        else:
            conn.execute(text(f"CREATE DATABASE {DB_NAME}"))
            print(f"created database '{DB_NAME}'")
    admin.dispose()

    # 2) load each table, replacing it if a previous run left one behind.
    engine = create_engine(f"{base}/{DB_NAME}")
    for table, filename in TABLES.items():
        frame = pd.read_parquet(os.path.join(PROCESSED, filename))
        frame.columns = [to_snake(c) for c in frame.columns]

        # PostgreSQL allows max 65535 parameters per INSERT; method="multi" packs
        # many rows into one statement, so keep rows-per-batch * columns under that.
        chunksize = 60000 // len(frame.columns)
        frame.to_sql(table, engine, if_exists="replace", index=False,
                     chunksize=chunksize, method="multi")

        loaded = pd.read_sql(text(f"SELECT COUNT(*) FROM {table}"), engine).iloc[0, 0]
        print(f"{table:14} {loaded:>9,} rows")

    engine.dispose()
    print("done")


if __name__ == "__main__":
    main()
