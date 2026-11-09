-- Query 1: “Do late orders get worse reviews than on-time orders?”
SELECT CASE WHEN is_late = 0 THEN 'Arrived on time' ELSE 'Arrived late' END AS order_arrival_status,
COUNT(*) AS orders, ROUND(AVG(review_rating), 2) AS avg_rating, 
ROUND((AVG((review_rating <= 2)::int) * 100),2) AS pct_bad_review
FROM order_analysis
group by order_arrival_status;

-- Query 2: “Which customer states have the highest late rate?”
SELECT customer_state, SUM(is_late) AS total_late_orders, COUNT(*) AS orders,
ROUND((AVG(is_late) * 100),2) AS rate_of_late_order_arrival
from order_analysis
group by customer_state
having count(*) >= 100
order by rate_of_late_order_arrival DESC;

-- Query 3: “Which product categories are late most often?”
Select product_category, SUM(is_late) AS total_late_orders, COUNT(*) AS orders,
ROUND((AVG(is_late) * 100),2) AS late_arrival_percentage
from order_analysis
group by product_category
having count(*) >= 200
order by late_arrival_percentage desc
limit 10;

-- Query 4: “Is there seasonality?” (late rate by month)
SELECT DATE_TRUNC('month', order_purchase_timestamp)::date AS months, SUM(is_late) AS total_late_orders, 
COUNT(*) AS orders,
ROUND((AVG(is_late) * 100),2) AS late_arrival_percentage
from order_analysis
group by months
having count(*) >= 100
order by months;

SELECT * FROM order_analysis LIMIT 10;

-- Query 5: “Which sellers are late most often?"
select seller_id, seller_state, SUM(is_late) AS total_late_orders, 
COUNT(*) AS orders,
ROUND((AVG(is_late) * 100),2) AS late_arrival_percentage
from order_analysis
group by seller_id, seller_state
having count(*) >= 50
order by late_arrival_percentage desc
limit 10;