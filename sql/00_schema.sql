-- Keys and indexes for the retailpulse database.

-- Primary keys: each dimension table has one naturally-unique column.
ALTER TABLE orders       ADD CONSTRAINT pk_orders       PRIMARY KEY (invoice);
ALTER TABLE customers    ADD CONSTRAINT pk_customers    PRIMARY KEY (customer_id);
ALTER TABLE customer_rfm ADD CONSTRAINT pk_customer_rfm PRIMARY KEY (customer_id);

-- sales_clean is line-item level: no unique column, and customer_id is ~23% null,
-- so it gets indexes on the columns the queries join and filter on instead.
CREATE INDEX ix_sales_customer     ON sales_clean (customer_id);
CREATE INDEX ix_sales_invoice_date ON sales_clean (invoice_date);
CREATE INDEX ix_sales_invoice      ON sales_clean (invoice);

CREATE INDEX ix_orders_customer   ON orders (customer_id);
CREATE INDEX ix_orders_order_date ON orders (order_date);
