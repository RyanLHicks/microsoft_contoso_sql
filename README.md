# Contoso SQL - Sales Analysis

## Introduction
### 🌄 Background
- This is part of a self-taught journey for data analysis. I want to learn and utilize all practical data analysis tools that include: SQL, Python, Excel, and Power BI. I believe that learning these tools will allow me to increase my general knowledge of how business decisions are made, leverage a higher salary and earning potential, and finally make informed decisions on everyday topics and issues based on data.
- I will be practicing SQL data extraction through Microsoft's Contoso sales database to better understand:
1. How and when to use various SQL queries.
2. Develop my insight and decision making skills based on data.

### 🤖 Process
- Give a brief overview of what I'm doing for each analysis.
- Develop and run a SQL query to uncover the data.
- Show the raw data.
- Transform it into easy to read graphs and charts.
- Lay out what we see into simple terms.
- Find any strategic decisions to make from the data.

### 💡 Question Overview
1. **Customer Segmentation**: Who contributes the most to the business?
2. **Cohort Analysis**: How do new customer groups generate our revenue?
3. **Retention Analysis**: Which customer groups haven't purchased recently?

## Analysis Approach
### 1. **Segmentation Analysis**
During this analysis I am going to break down how the different segments of Contoso’s consumer base impact on the revenue for the company. It has been divided into three groups consisting of: high-value customers, who are greater than the 75th percentile in purchasing, medium-value customers who are in between the 25th and 75th percentile in purchasing and finally low-value customers, who are less than the 25th percentile in purchasing. This allows us to see the numerical value associated with each purchasing group and how they affect our total revenue. This also shows insights into which customer segments are impacting our business positively and which one's need more targeting for increased revenue growth.

#### ⚙️After running this query: 
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

#### 🔍The raw data we get:

```
"customer_segment","total_ltv","customer_count","avg_ltv"
"3 - high-value",135429277.26549858,12372,10946.433661938132
"2 - mid-Value",66636451.787238546,24743,2693.143587569759
"1 - Low-Value",4341809.527328128,12372,350.9383711063796
```

#### 📊Is translated graphically:
<img width="1000" height="600" alt="image" src="https://github.com/user-attachments/assets/835d299f-2b8c-48c0-9fdb-add45c6c6d0b" />

#### 🧠Can be intrepreted:
We have a significant number of mid-value customers contributing to our net revenue, but we would like to see how we can move those customers into the high-value area to further increase profits. 

#### ✅Using the data for decisions: 
This can be done by increased ad targeting the moderate spenders by further analyzing what demographics they are in or offering promotions that would encourage increased spending from those customers. The key here is to understand that majority of our customers are moderate spenders, and we need to ensure that they can get the most value out of our products, leading to sustainable business practices.

### 2. **Cohort Analysis** 
This analysis will break down how active our new customers look compared to our total revenue for a specified year. We want to see how many new customers we have each year and how much they contribute to the revenue we are bringing in. This will give us a clear indication of how well the business is performing, and we will implement some strategies to increase or maintain our first-time customers. Using this information, it will allow us to leverage new strategies to either maintain or increase our customer base.

#### 🔍After running this query:

```
SELECT
	cohort_year,
	COUNT(DISTINCT customerkey) AS total_customers,
	SUM(net_revenue) AS total_revenue,
	SUM(net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM
	cohort_analysis
GROUP BY
	cohort_year
```

#### ⚙️The raw data we get:
```
"cohort_year","total_customers","total_revenue","customer_revenue"
2015,2825,14892230.469868412,5271.586007033066
2016,3397,18360521.738402583,5404.922501737587
2017,4068,21979733.96408646,5403.081112115649
2018,7446,36460385.4237634,4896.640535020602
2019,7755,36696243.8765804,4731.946341274069
2020,3031,11921900.968580445,3933.3226554208
2021,4663,18387736.17938562,3943.327510054819
2022,9010,29872808.298764743,3315.5170142913144
2023,5890,14979328.333089931,2543.1796830373396
2024,1402,2856649.3275427977,2037.5530153657614
```

#### 📊Is translated graphically:

<img width="1067" height="1600" alt="image" src="https://github.com/user-attachments/assets/575632ba-fa86-4aef-af76-84f1af878b74" />

#### 🧠Can be intrepreted:
In the first graph we can visually see that for the total customer/cohort year we have seen a general uptick in new customers from 2015-2022 (outlier in 2020 from a pandemic) and after that have seen an unfortunate decrease in new customers from 2022 and out. For the second graph it's easy to see that the total revenue/cohort year closely followed the customer/cohort year graph which makes sense when talking about new customers every year and revenue every year seeing a close correlation between the two. The most concerning graph is the graph depicting average revenue/customer/cohort year, which shows a decrease in average revenue for each year for each customer. This is unfortunate; however, it gives us valuable information about where the decreases happen and what we can do about in the future to see a thriving business.

#### ✅Using the data for decisions: 
From the first two graphs, it's imperative that we tackle the problems of why we aren't attracting new customers from 2022 and beyond. The data clearly shows that the attraction of new customers is falling and that is directly impacting on our revenue streams. We need to form a solid plan with marketing to first attract these new customers and then devise a strategy to retain loyalty after we achieve this. After the first two parts, looking at the average spending habits of the customer is essential because we see that from 2017 and onward there was a dramatic decrease in average new customer spending and try and understand 1) Why did such a dramatic decrease from 2017 - 2018? and 2) What did we do well from 2015-2017 and how can we repeat this strategy from here on out? 3) Is this a natural part of business cycles where it’s expected to lose new customers? 

### 3. **Retention Analysis**
This section is specifically dedicated to customer retention and how it might relate to the other analysis above when talking about key revenue indicators. The goal is to see how many loyal customers we currently retain and at what % of our total customer base are considered retained or leave after a one-time purchase. This will give us good insight into our baseline and how we might be able to retain more customers in the future.

#### ⚙️After running this query:

```
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
```

#### 🔍The raw data we get:

```
"customer_status","num_customers","total_customers","status_percent","cohort_year"
ACTIVE,237,2825,0.08,2015
CHURNED,2588,2825,0.92,2015
ACTIVE,311,3397,0.09,2016
CHURNED,3086,3397,0.91,2016
ACTIVE,385,4068,0.09,2017
CHURNED,3683,4068,0.91,2017
ACTIVE,704,7446,0.09,2018
CHURNED,6742,7446,0.91,2018
ACTIVE,687,7755,0.09,2019
CHURNED,7068,7755,0.91,2019
CHURNED,2748,3031,0.91,2020
ACTIVE,283,3031,0.09,2020
CHURNED,4221,4663,0.91,2021
ACTIVE,442,4663,0.09,2021
ACTIVE,937,9010,0.10,2022
CHURNED,8073,9010,0.90,2022
ACTIVE,455,4718,0.10,2023
CHURNED,4263,4718,0.90,2023
```

#### 📊Is translated graphically:

<img width="1200" height="1200" alt="image" src="https://github.com/user-attachments/assets/e60d570e-e9c2-47cc-a820-58f3b18e9ee7" />


#### 🧠Can be intrepreted:
This shows the direct relationship between our active and churned customers for each year. This is another great insight for making decisions on how the company can move forward. Unfortunately, there is a high churn rate but being in business, this can be expected. We can see that 2022 was the best year for active customers along with total customers as well.

#### ✅Using the data for decisions: 
Based on the data presented, I believe that continuing the strategies from previous sections would also decrease our churn to active customer rate which we want to reduce below 90% as a starting point. I believe for the company to be sustainable, aiming for 85% -80% will be what we need to continue successful operation. Like before, using our resources like targeted marketing and advertising would help increase customer retention.

## Conclusion

### 📚 Recomendations
- Increased targeted marketing strategies for comprehensive customer engagement.
- Amplified research and development into products and services currently offered and the introduction of new one's. 
- Considering taking on additional capital debt for innovation, customer outreach, and surveying. 

### ✍️ Technical Skills Learned
- SQL queries
- Postgresql SQL database
- Dbeaver SQL analysis
- Git's local repository 
- Github presentations
- Google Gemini visualizations
- Data implementation, extraction, and stories.

### 🚀 Future
- I want to continue and use SQL for the following topics that rely heavily on data: Consumerism, Technology, Retail, Pharmacy, and Exercise.
- I believe that the possibilities with using this program are endless and continuing to use these SQL functions will set my future up great. My goal with this program is to of course become a master but also get something out of what the data is trying to tell me and I think in general this will help me lead to better informed decisions about our crazy world for the better.

### 💻 Sources
- [Luke Barrouse](https://www.youtube.com/watch?v=QKIGsShyEsQ&t=23012s&pp=0gcJCfsJAYcqIYzv)
- [Microsoft Contoso Database](https://www.microsoft.com/en-us/download/details.aspx?id=18279)
- Dbeaver
- PostgreSQL
- Github
- Google Gemini
 







