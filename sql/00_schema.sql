-- 00_schema.sql
-- Adds keys and indexes to the tables loaded by scripts/load_to_postgres.py.
-- pandas.to_sql creates columns but no constraints, so this file supplies the
-- structure: primary keys for identity, indexes for the columns that Days 17-18
-- filter and join on.
--
-- Safe to re-run: every constraint and index is dropped first if it exists.

-- orders: one row per invoice, so the invoice number is the natural primary key.
ALTER TABLE orders DROP CONSTRAINT IF EXISTS pk_orders;
ALTER TABLE orders ADD CONSTRAINT pk_orders PRIMARY KEY (invoice);

-- customers: one row per customer.
ALTER TABLE customers DROP CONSTRAINT IF EXISTS pk_customers;
ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

-- customer_rfm: one row per customer.
ALTER TABLE customer_rfm DROP CONSTRAINT IF EXISTS pk_customer_rfm;
ALTER TABLE customer_rfm ADD CONSTRAINT pk_customer_rfm PRIMARY KEY (customer_id);

-- sales_clean is a line-item fact table: no single column is unique, and
-- customer_id is ~23% null, so it cannot take a primary key. It gets indexes
-- instead, on the three columns the analysis queries touch most:
--   customer_id  -> joins to customers / grouping by customer
--   invoice_date -> month filters and time-series aggregation
--   invoice      -> grouping line items back up to orders
DROP INDEX IF EXISTS ix_sales_customer;
DROP INDEX IF EXISTS ix_sales_invoice_date;
DROP INDEX IF EXISTS ix_sales_invoice;
CREATE INDEX ix_sales_customer     ON sales_clean (customer_id);
CREATE INDEX ix_sales_invoice_date ON sales_clean (invoice_date);
CREATE INDEX ix_sales_invoice      ON sales_clean (invoice);

-- orders: index the columns used to join to customers and to filter by date.
DROP INDEX IF EXISTS ix_orders_customer;
DROP INDEX IF EXISTS ix_orders_order_date;
CREATE INDEX ix_orders_customer   ON orders (customer_id);
CREATE INDEX ix_orders_order_date ON orders (order_date);
