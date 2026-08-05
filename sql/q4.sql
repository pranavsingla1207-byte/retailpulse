WITH monthly AS (
    SELECT year_month,
           SUM(revenue) AS monthly_revenue
    FROM sales_clean
    WHERE is_cancelled = false
    GROUP BY year_month
)
SELECT year_month,
       ROUND(monthly_revenue::numeric, 2) AS monthly_revenue,
       ROUND(SUM(monthly_revenue) OVER (ORDER BY year_month)::numeric, 2) AS running_total
FROM monthly
ORDER BY year_month
LIMIT 4;