"""
Run a .sql file against the retailpulse PostgreSQL database.

A small helper so SQL files can be executed without psql on PATH and without
clicking through pgAdmin. It runs each statement in the file; for statements
that return rows (SELECT) it prints the result, for the rest it prints OK.

Password handling is the same as the loader: read from PGPASSWORD if set,
otherwise prompt, so nothing sensitive is committed.

Usage:
    python scripts/run_sql.py sql/00_schema.sql
"""

import os
import sys
import getpass

import pandas as pd
from sqlalchemy import create_engine


def statements_in(path):
    """Split a .sql file into individual statements, skipping comment-only chunks."""
    text = open(path, encoding="utf-8").read()
    for chunk in text.split(";"):
        code_lines = [
            line for line in chunk.splitlines()
            if line.strip() and not line.strip().startswith("--")
        ]
        if code_lines:
            yield chunk.strip()


def main():
    if len(sys.argv) < 2:
        print("usage: python scripts/run_sql.py <file.sql>")
        return

    path = sys.argv[1]
    user = os.environ.get("PGUSER", "postgres")
    password = os.environ.get("PGPASSWORD") or getpass.getpass("PostgreSQL password: ")
    engine = create_engine(
        f"postgresql+psycopg2://{user}:{password}@localhost:5432/retailpulse"
    )

    with engine.begin() as conn:
        for stmt in statements_in(path):
            result = conn.exec_driver_sql(stmt)
            if result.returns_rows:
                rows = result.fetchall()
                frame = pd.DataFrame(rows, columns=result.keys())
                print(frame.to_string(index=False))
                print()
            else:
                verb = stmt.lstrip().split()[0].upper()
                print(f"OK  {verb}")

    engine.dispose()


if __name__ == "__main__":
    main()
