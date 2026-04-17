SELECT 
    p.prod_id,
    p.prod_name,
    cat.cat_name,
    COUNT(DISTINCT od.order_id) as appearance_count,
    SUM(od.quantity) as units_sold,
    SUM(od.quantity * od.unit_price) as gross_revenue,
    NTILE(4) OVER (ORDER BY SUM(od.quantity * od.unit_price) DESC) as revenue_quartile,
    PERCENT_RANK() OVER (ORDER BY SUM(od.quantity * od.unit_price)) as market_percentile,
    AVG(SUM(od.quantity * od.unit_price)) OVER (PARTITION BY cat.cat_id) as category_avg_revenue
FROM Products p
JOIN Categories cat ON p.cat_id = cat.cat_id
LEFT JOIN OrderDetails od ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name, cat.cat_id, cat.cat_name
HAVING units_sold > 0
ORDER BY gross_revenue DESC;
