"""
Export the tables the Power BI dashboard needs, as CSV.

Four small, curated CSVs rather than the full 1M-row line table: the product page
only needs revenue and units per product, so that is pre-aggregated here. Output
goes to data/processed/powerbi/ (gitignored, regenerable by re-running this file).

Run from the project root:
    python scripts/export_for_powerbi.py
"""

import os

import pandas as pd

PROCESSED = os.path.join(os.path.dirname(__file__), "..", "data", "processed")
OUT = os.path.join(PROCESSED, "powerbi")
os.makedirs(OUT, exist_ok=True)


def lower_columns(frame):
    frame = frame.copy()
    frame.columns = [c.lower().replace(" ", "_") for c in frame.columns]
    return frame


def write(frame, name):
    path = os.path.join(OUT, name)
    frame.to_csv(path, index=False)
    print(f"{name:24} {len(frame):>9,} rows")


# order-level facts: KPIs, monthly trend, revenue by country
orders = lower_columns(pd.read_parquet(os.path.join(PROCESSED, "orders.parquet")))
write(orders, "orders.csv")

# cohort table: retention heatmap and new-vs-returning split
cohorts = lower_columns(pd.read_parquet(os.path.join(PROCESSED, "cohorts.parquet")))
write(cohorts, "cohorts.csv")

# one row per customer with segment and cluster labels
segments = lower_columns(pd.read_parquet(os.path.join(PROCESSED, "customer_segments.parquet")))
write(segments, "customer_segments.csv")

# product revenue and units, pre-aggregated from the 1M-row line table
features = pd.read_parquet(os.path.join(PROCESSED, "retail_features.parquet"))
sales = features[~features["is_cancelled"]]
product_summary = (
    sales.groupby(["StockCode", "Description"])
    .agg(revenue=("Revenue", "sum"), units=("Quantity", "sum"))
    .reset_index()
    .sort_values("revenue", ascending=False)
)
product_summary.columns = [c.lower() for c in product_summary.columns]
write(product_summary, "product_summary.csv")

print("done ->", OUT)
