WITH country_product AS (
    SELECT country,
           description,
           SUM(revenue) AS product_revenue,
           RANK() OVER (PARTITION BY country ORDER BY SUM(revenue) DESC) AS rnk
    FROM sales_clean
    WHERE is_cancelled = false
    GROUP BY country, description
)
SELECT country,
       description,
       ROUND(product_revenue::numeric, 2) AS product_revenue
FROM country_product
WHERE rnk = 1
  AND country IN ('United Kingdom', 'EIRE', 'Germany', 'France', 'Netherlands')
ORDER BY product_revenue DESC;
