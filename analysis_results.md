# Olist E-Commerce Analysis Results

## 1. Data Grain

The main tables have different grains:

-   `orders`: order level
-   `order_items`: order-item level
-   `order_payments`: payment level
-   `customers`: customer record level
-   `products`: product level
-   `order_reviews`: review level

One order can contain multiple products, so `order_items` has more rows
than the number of distinct orders. One order can also contain multiple
payment records.

For example, the analysis found:

-   `order_items`: 112,650 rows and 98,666 distinct orders
-   `order_payments`: 103,886 rows and 99,440 distinct orders

This difference in data grain is important when joining tables and
calculating metrics.

## 2. Core Sales Metrics

Based on `order_payments`:

  Metric                          Value
  --------------------- ---------------
  Paid orders                    99,440
  Total revenue           16,008,872.12
  Average order value        160.990267

Payment records were aggregated by `order_id` before being combined with
order-level information.

## 3. Monthly Sales

Monthly revenue was calculated after aggregating payment values to the
order level.

The analysis found a clear increase in sales volume during 2017 and 2018
compared with the earliest months in the dataset.

Some very small or anomalous early-month records, including `0000-00`,
`2016-12`, and `2018-09`, were excluded from interpretation.

## 4. Product Analysis

### Top categories by sales volume

  Category                    Items        Revenue
  ------------------------ -------- --------------
  cama_mesa_banho            11,115   1,036,988.68
  beleza_saude                9,670   1,258,681.34
  esporte_lazer               8,641     988,048.97
  moveis_decoracao            8,334     729,762.49
  informatica_acessorios      7,827     911,954.32
  utilidades_domesticas       6,964     632,248.66
  relogios_presentes          5,991   1,205,005.68
  telefonia                   4,545     323,667.53
  ferramentas_jardim          4,347     485,256.46
  automotivo                  4,235     592,720.11

### Top categories by revenue

  Category                    Items        Revenue
  ------------------------ -------- --------------
  beleza_saude                9,670   1,258,681.34
  relogios_presentes          5,991   1,205,005.68
  cama_mesa_banho            11,115   1,036,988.68
  esporte_lazer               8,641     988,048.97
  informatica_acessorios      7,827     911,954.32
  moveis_decoracao            8,334     729,762.49
  cool_stuff                  3,796     635,290.85
  utilidades_domesticas       6,964     632,248.66
  automotivo                  4,235     592,720.11
  ferramentas_jardim          4,347     485,256.46

The ranking changes depending on whether categories are measured by
sales volume or revenue.

## 5. Customer Analysis

Customer purchase frequency was analyzed using `customer_unique_id`,
which represents the same real customer across purchases.

  Purchase frequency     Customers
  -------------------- -----------
  1 purchase                93,098
  2 purchases                2,745
  3+ purchases                 252

The analysis identified:

-   Total analyzed customers: 96,095
-   Repeat customers: 2,997
-   Repeat purchase rate: 3.12%

The customer base is therefore strongly concentrated in one-time
purchasers.

## 6. Regional Analysis

The largest markets by order volume and revenue included:

  State     Orders        Revenue      AOV
  ------- -------- -------------- --------
  SP        41,745   5,998,226.96   143.69
  RJ        12,852   2,144,379.69   166.85
  MG        11,635   1,872,257.26   160.92
  RS         5,466     890,898.54   162.99
  PR         5,045     811,156.38   160.78

São Paulo (SP) is the largest market in this analysis by both order
volume and revenue.

## 7. Logistics Analysis

For delivered orders, delivery performance was classified by comparing
actual delivery date with estimated delivery date.

Overall results:

  Metric                  Value
  -------------------- --------
  Delivered orders       96,478
  On-time orders         88,652
  Late orders             7,826
  Late delivery rate      8.11%

The overall average delivery time can also be examined from the
delivered-order data.

### State-level delivery performance

The analysis showed substantial regional differences.

  State     Orders   Avg. delivery days   Late orders   Late rate
  ------- -------- -------------------- ------------- -----------
  RR            41              29.3415             5      12.20%
  AP            67              27.1791             3       4.48%
  AM           145              26.3586             6       4.14%
  AL           397              24.5013            95      23.93%
  PA           946              23.7252           117      12.37%
  RJ        12,350              15.2370         1,664      13.47%
  MG        11,354              11.9450           637       5.61%
  PR         4,923              11.9380           246       5.00%
  SP        40,501               8.6991         2,387       5.89%

Very small-volume states should be interpreted cautiously. For example,
RR has only 41 delivered orders.

## 8. Monthly Logistics

Delivery performance also varied by month.

Examples from the analysis:

  Month       Orders   Avg. delivery days   Late rate
  --------- -------- -------------------- -----------
  2018-08      6,351               7.6582      10.39%
  2018-07      6,159               8.8834       4.48%
  2018-06      6,099               9.1600       1.36%
  2018-03      7,003              16.2376      21.36%
  2018-02      6,555              16.8734      15.99%
  2017-11      7,289              15.0711      14.31%

The earliest months contain very small sample sizes and were treated
cautiously in the interpretation.

## 9. Logistics and Reviews

The analysis compared review scores between on-time and late deliveries.

  Delivery status     Orders   Average review score   1-star rate
  ----------------- -------- ---------------------- -------------
  On time             88,660                 4.2937         6.60%
  Late                 7,699                 2.5667        46.15%

The difference is substantial in this dataset:

-   On-time orders: average score 4.2937
-   Late orders: average score 2.5667
-   One-star review rate: 6.60% vs. 46.15%

This analysis shows a strong association between late delivery and lower
review scores. It should not be interpreted as proof that late delivery
alone causes lower ratings.

## 10. Business Conclusions

### Sales

The platform generated approximately 16.01 million in payment revenue
across 99,440 paid orders, with an average paid order value of
approximately 160.99.

### Product

High-volume categories are not always the highest-revenue categories.
Comparing both rankings provides a more complete view of product
performance.

### Customer

One-time purchases dominate the customer base. The repeat purchase rate
in the analysis is 3.12%.

### Region

São Paulo is the largest market by order volume and revenue. Regional
delivery performance varies substantially.

### Logistics

The overall late delivery rate is 8.11% among delivered orders that
could be classified as on-time or late. Delivery times and late rates
vary by state and month.

### Reviews

Late-delivery orders have much lower average review scores and a much
higher one-star review rate than on-time orders. The result is an
association observed in the dataset rather than a causal estimate.
