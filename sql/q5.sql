--Month-over-month revenue growth %.  (Day 18)
-- LAG() copies the previous month's revenue onto each row, so growth is just
-- (this month - last month) / last month.
-- pandas: 2010-01 -23.2%, 2010-02 -12.1%, 2010-03 +41.6%, 2010-04 -15.2%
-- (2009-12 has no prior month, so its growth is null).
WITH monthly AS (
    SELECT year_month,
           SUM(revenue) AS revenue
    FROM sales_clean
    WHERE is_cancelled = false
    GROUP BY year_month
),
compare AS (
    SELECT year_month,
           revenue,
           LAG(revenue) OVER (ORDER BY year_month) AS prev_revenue
    FROM monthly
)
SELECT year_month,
       ROUND((100.0 * (revenue - prev_revenue) / prev_revenue)::numeric, 1) AS mom_growth_pct
FROM compare
ORDER BY year_month
LIMIT 5;
