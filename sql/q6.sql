-- Q6. Churn: customers who bought in 2010 but not in 2011.
-- Take the distinct 2010 customers, then keep those whose id is not in the
-- list of 2011 customers.
-- pandas: 1549 customers churned (of 4205 active in 2010 = 36.8%).
SELECT COUNT(*) AS churned_2010_customers
FROM (
    SELECT DISTINCT customer_id
    FROM sales_clean
    WHERE is_cancelled = false AND year = 2010 AND customer_id IS NOT NULL
) AS customers_2010
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales_clean
    WHERE is_cancelled = false AND year = 2011 AND customer_id IS NOT NULL
);