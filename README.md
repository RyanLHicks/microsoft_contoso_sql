# Contoso SQL - Sales Analysis

## Overview

## Insight Questions
1. **Customer Segmentation**: Who contributes the most to the business?
2. **Cohort Analysis**: How do different customer groups generate our revenue?
3. **Retention Analysis**: Which customer groups haven't purchased recently?
## Analysis Approach
### 1. **Segmentation Analysis**
During this analysis I am going to break down how the different segments of contoso's consumer base impacts the revenue for the company. It has been divided into three groups conisting of: high-value customers, who are greater than the 75th percentile in purchasing, medium-value customers who are in between the 25th and 75th percentile in purchasing and finally low-value customers, who are less than the 25th percentile in purchasing. This allows us to see the numerical value associated with each group to make business decisions. This also shows insights into which customer segments are impacting our business positively and which one's need more targeting for increased revenue growth.

#### After running this query: 
```
WITH customer_ltv AS(
	SELECT
		customerkey,
		concat,
		SUM(net_revenue) AS total_ltv
	FROM
		cohort_analysis
	GROUP BY
		customerkey,
		concat
), customer_segments AS (
SELECT 
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
FROM 
	customer_ltv
), segment_values AS (
SELECT
	c.*,
	CASE
		WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
		WHEN c.total_ltv < cs.ltv_75th_percentile THEN '2 - mid-Value'
		ELSE '3 - high-value'
	END AS customer_segment
FROM 
	customer_ltv c,
	customer_segments cs
)	
SELECT 
	customer_segment,
	SUM(total_ltv) AS total_ltv,
	COUNT(customerkey) AS customer_count,
	SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM
	segment_values
GROUP BY 
	customer_segment
ORDER BY
	customer_segment DESC
```

#### The raw data we get:

```
"customer_segment","total_ltv","customer_count","avg_ltv"
"3 - high-value",135429277.26549858,12372,10946.433661938132
"2 - mid-Value",66636451.787238546,24743,2693.143587569759
"1 - Low-Value",4341809.527328128,12372,350.9383711063796
```

#### Is translated graphically:
<img width="1000" height="600" alt="image" src="https://github.com/user-attachments/assets/835d299f-2b8c-48c0-9fdb-add45c6c6d0b" />

#### Can be intrepreted:
We have a significant amount of mid-value customers contributing to our net revenue but we would like to see how we can move those customers into the high-value area to further increase profits. 

#### Using the data for decisions: 
This can be done by increased ad targeting by further analyzing what demographics are in this seciton or offering promotions that would incetive increased spending from our customers. 

### 2. **Cohort Analysis** 


#### After running this query:

#### The raw data we get:

#### Is translated graphically:

#### Can be intrepreted:

#### Using the data for decisions: 


### 3. **Retention Analysis**

## Recomendations


## Technical Skills


