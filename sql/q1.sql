SELECT description,
       ROUND(SUM(revenue)::numeric, 2) AS product_revenue
FROM sales_clean
WHERE is_cancelled = false
GROUP BY description
ORDER BY product_revenue DESC
LIMIT 5;