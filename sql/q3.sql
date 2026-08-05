WITH product_revenue AS (
    SELECT stock_code,
           SUM(revenue) AS revenue
    FROM sales_clean
    WHERE is_cancelled = false
    GROUP BY stock_code
    HAVING SUM(revenue) > 0
),
running AS (
    SELECT SUM(revenue) OVER (ORDER BY revenue DESC) AS running_revenue,
           SUM(revenue) OVER ()                      AS total_revenue
    FROM product_revenue
)
SELECT COUNT(*) AS products_for_80_percent
FROM running
WHERE running_revenue <= 0.8 * total_revenue;