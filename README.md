# Olist Brazilian E-Commerce Data Analysis

## Project Overview

This project analyzes the Olist Brazilian E-Commerce Public Dataset
using MySQL and SQL.

The analysis focuses on sales performance, product categories, customer
purchasing behavior, regional markets, delivery performance, and
customer reviews.

## Tools

-   MySQL 8.0
-   SQL
-   MySQL Workbench
-   Git / GitHub
-   Power BI (dashboard can be added separately)

## Dataset

The dataset contains information about:

-   Customers
-   Orders
-   Order items
-   Products
-   Sellers
-   Payments
-   Reviews
-   Geolocation
-   Product category translation

Raw CSV files are not included in this repository.

## Business Questions

1.  What is the overall sales scale of the platform?
2.  Which product categories contribute the most revenue?
3.  Are customers mainly one-time buyers or repeat buyers?
4.  Which regions are the core markets?
5.  How efficient is the delivery process?
6.  Is there a difference in review scores between on-time and late
    deliveries?

## Analysis Workflow

Raw Data\
→ Data Grain Understanding\
→ Data Quality Checks\
→ SQL Analysis\
→ Business Metrics\
→ Business Insights\
→ Power BI Dashboard

## Analysis Areas

### 1. Sales Analysis

-   Order volume
-   Total revenue
-   Average order value
-   Monthly revenue trends

### 2. Product Analysis

-   Top product categories by sales volume
-   Top product categories by revenue
-   Differences between sales-volume and revenue rankings

### 3. Customer Analysis

-   Customer purchase frequency
-   One-time vs. repeat customers
-   Repeat purchase rate
-   High-value customers

### 4. Regional Analysis

-   Orders and revenue by state
-   Average order value by state
-   Core regional markets

### 5. Logistics Analysis

-   Estimated vs. actual delivery time
-   Late delivery identification
-   Overall late delivery rate
-   Delivery performance by state and month

### 6. Review Analysis

-   Review score by delivery status
-   Average review score
-   One-star review rate
-   Association between late delivery and lower review scores

## Key Findings

-   The analysis contains 99,440 paid orders and total payment revenue
    of 16,008,872.12 in the payment-based sales analysis.
-   Average order value based on paid orders is approximately 160.99.
-   One-time customers account for the majority of analyzed customers:
    93,098 customers purchased once, while 2,997 customers made more
    than one purchase.
-   São Paulo (SP) is the largest market by both order volume and
    revenue in the regional analysis.
-   Product categories show different rankings when measured by sales
    volume versus revenue.
-   Delivery performance varies substantially across states and months.
-   On-time and late-delivery orders show a clear difference in review
    scores in this dataset: the average score was 4.2937 for on-time
    orders and 2.5667 for late orders. This result indicates an
    association, not a causal conclusion.

## Data Quality Notes

During the analysis, data quality and data-grain issues were considered,
including:

-   One order can contain multiple order-item records.
-   One order can have multiple payment records.
-   Payment data was aggregated to the order level before combining it
    with order-level analysis to reduce one-to-many duplication risks.
-   Some early monthly records contained anomalous date groups such as
    `0000-00`; these were excluded from the monthly trend
    interpretation.
-   Very small-volume early-month records were treated cautiously when
    interpreting logistics trends.

## Repository Structure

``` text
olist-ecommerce-analysis/
├── README.md
├── analysis_results.md
└── dashboard/
    └── screenshots/
```

## Notes

This repository presents the analysis process and business findings from
the Olist public dataset. The purpose is to demonstrate practical skills
in SQL-based data analysis, data quality checking, business metric
calculation, and business interpretation.
