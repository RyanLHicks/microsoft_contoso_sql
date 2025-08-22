WITH customer_last_purchase AS(
	SELECT
		customerkey,
		concat,
		orderdate,
		ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
		first_purchase_date,
		cohort_year
	FROM
		cohort_analysis
), churned_customers AS (
SELECT
	customerkey,
	concat,
	orderdate AS last_purchase_date,
	CASE
		WHEN orderdate < '2024-04-20'::date - INTERVAL '6 MONTHS' THEN 'CHURNED'
		ELSE 'ACTIVE'
	END AS customer_status,
	cohort_year
FROM
	customer_last_purchase 
WHERE rn = 1 AND first_purchase_date < '2024-04-20'::date - INTERVAL '6 MONTHS'
)
SELECT 
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,
	ROUND(COUNT(customerkey)/ 	SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year),2) AS status_percent,
	cohort_year
FROM
	churned_customers 
GROUP BY
	customer_status,
	cohort_year
