-- 01_business_questions.sql  (part 1, Day 17)
-- The EDA questions answered again in SQL, using CTEs and window functions.
-- Each query notes the pandas figure it should reproduce.
--
-- sales_clean holds every line including cancellations, so each query filters
-- WHERE is_cancelled = false to match the EDA revenue base of 19.64M.


-- Q1. Top 5 products by revenue.
-- pandas: Regency Cakestand 330590.32, White Hanging Heart 260990.22,
-- Paper Craft 168469.60, Party Bunting 148318.28, Jumbo Bag 148073.47.
SELECT description,
       ROUND(SUM(revenue)::numeric, 2) AS product_revenue
FROM sales_clean
WHERE is_cancelled = false
GROUP BY description
ORDER BY product_revenue DESC
LIMIT 5;


-- Q2. The number-one product in each major market.
-- RANK() numbers products within each country; we then keep number 1.
-- pandas: UK/EIRE/Germany all Regency Cakestand, Netherlands Round Snack Boxes,
-- France Rabbit Night Light.
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


-- Q3. How many products make up 80% of revenue?  (Pareto / 80-20)
-- running_revenue adds up product revenue from largest down; we count the
-- products whose running total is still within 80% of the grand total.
-- pandas: 1039 of 4878 products (21.3%).
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


-- Q4. Monthly revenue with a running cumulative total.
-- The CTE totals each month first; the window then adds the months up in order.
-- pandas first 4 months: 2009-12 797738.02 / 797738.02,
-- 2010-01 612271.20 / 1410009.22, 2010-02 537893.54 / 1947902.76,
-- 2010-03 761665.62 / 2709568.38.
WITH monthly AS (
    SELECT year_month,
           SUM(revenue) AS monthly_revenue
    FROM sales_clean
    WHERE is_cancelled = false
    GROUP BY year_month
)
SELECT year_month,
       ROUND(monthly_revenue::numeric, 2)                                AS monthly_revenue,
       ROUND(SUM(monthly_revenue) OVER (ORDER BY year_month)::numeric, 2) AS running_total
FROM monthly
ORDER BY year_month
LIMIT 4;
