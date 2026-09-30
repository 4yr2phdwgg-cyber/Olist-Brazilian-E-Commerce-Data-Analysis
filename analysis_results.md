# Olist E-Commerce Analysis Results

## 1. Data Grain

本项目使用 Olist Brazilian E-Commerce Public Dataset，主要分析以下数据表：

- `customers`
- `orders`
- `order_items`
- `products`
- `sellers`
- `order_payments`
- `order_reviews`
- `geolocation`
- `product_category_name_translation`

### Orders

`orders` 以订单为主要粒度。

### Order Items

一个订单可以包含多个商品，因此：

- `order_items` 行数：112,650
- 不重复订单数：98,666

因此不能把 `order_items` 的行数直接理解为订单数。

### Payments

一个订单可能存在多个支付记录，因此：

- `order_payments` 行数：103,886
- 不重复订单数：99,440

因此在计算销售额时，需要先按 `order_id` 汇总支付金额，再进行订单层面的分析。

---

# 2. Core Sales Metrics

```sql
SELECT
    COUNT(DISTINCT order_id) AS order_count,
    SUM(payment_value) AS total_revenue,
    SUM(payment_value) / COUNT(DISTINCT order_id) AS avg_order_value
FROM order_payments;
```

结果：

| Metric | Value |
|---|---:|
| Paid Orders | 99,440 |
| Revenue | 16,008,872.12 |
| Average Order Value | 160.990267 |

---

# 3. Monthly Sales

## 3.1 Calculation Logic

支付表存在一个订单对应多条支付记录的情况，因此首先按照订单汇总支付金额：

```sql
WITH pay AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_payment
    FROM order_payments
    GROUP BY order_id
)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(p.order_payment) AS revenue
FROM orders o
JOIN pay p
    ON o.order_id = p.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%y-%m')
ORDER BY month;
```

## 3.2 Monthly Results

| Month | Orders | Revenue |
|---|---:|---:|
| 2016-09 | 3 | 252.24 |
| 2016-10 | 324 | 59,090.48 |
| 2016-12 | 1 | 19.62 |
| 2017-01 | 800 | 138,488.04 |
| 2017-02 | 1,780 | 291,908.01 |
| 2017-03 | 2,682 | 449,863.60 |
| 2017-04 | 2,404 | 417,788.03 |
| 2017-05 | 3,700 | 592,918.82 |
| 2017-06 | 3,245 | 511,276.38 |
| 2017-07 | 4,026 | 592,382.92 |
| 2017-08 | 4,331 | 674,396.32 |
| 2017-09 | 4,285 | 727,762.45 |
| 2017-10 | 4,631 | 779,677.88 |
| 2017-11 | 7,544 | 1,194,882.80 |
| 2017-12 | 5,673 | 878,401.48 |
| 2018-01 | 7,269 | 1,115,004.18 |
| 2018-02 | 6,728 | 992,463.34 |
| 2018-03 | 7,211 | 1,159,652.12 |
| 2018-04 | 6,939 | 1,160,785.48 |
| 2018-05 | 6,873 | 1,153,982.15 |
| 2018-06 | 6,167 | 1,023,880.50 |
| 2018-07 | 6,292 | 1,066,540.75 |
| 2018-08 | 6,512 | 1,022,425.32 |
| 2018-09 | 16 | 4,439.54 |
| 2018-10 | 4 | 589.67 |

## 3.3 Data Treatment

在月度销售趋势分析中，以下月份订单量极低：

- 2016-09：3 orders
- 2016-12：1 order
- 2018-09：16 orders
- 2018-10：4 orders

因此，在趋势图中将上述月份剔除，以避免极低样本量影响正常经营趋势的展示。

**原始数据库数据不做修改，仅在分析和可视化阶段进行处理。**

---

# 4. Product Analysis

## 4.1 Top 10 by Sales Volume

```sql
SELECT
    p.product_category_name,
    COUNT(*) AS item_count,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY item_count DESC
LIMIT 10;
```

| Product Category | Item Count | Revenue |
|---|---:|---:|
| cama_mesa_banho | 11,115 | 1,036,988.68 |
| beleza_saude | 9,670 | 1,258,681.34 |
| esporte_lazer | 8,641 | 988,048.97 |
| moveis_decoracao | 8,334 | 729,762.49 |
| informatica_acessorios | 7,827 | 911,954.32 |
| utilidades_domesticas | 6,964 | 632,248.66 |
| relogios_presentes | 5,991 | 1,205,005.68 |
| telefonia | 4,545 | 323,667.53 |
| ferramentas_jardim | 4,347 | 485,256.46 |
| automotivo | 4,235 | 592,720.11 |

## 4.2 Top 10 by Revenue

| Product Category | Order Count | Revenue |
|---|---:|---:|
| beleza_saude | 9,670 | 1,258,681.34 |
| relogios_presentes | 5,991 | 1,205,005.68 |
| cama_mesa_banho | 11,115 | 1,036,988.68 |
| esporte_lazer | 8,641 | 988,048.97 |
| informatica_acessorios | 7,827 | 911,954.32 |
| moveis_decoracao | 8,334 | 729,762.49 |
| cool_stuff | 3,796 | 635,290.85 |
| utilidades_domesticas | 6,964 | 632,248.66 |
| automotivo | 4,235 | 592,720.11 |
| ferramentas_jardim | 4,347 | 485,256.46 |

## 4.3 Sales Volume vs Revenue Ranking

通过 `RANK()` 分别计算销量和销售额排名，再比较两个排名的差异。

排名差异较明显的品类包括：

| Product Category | Order Count | Revenue |
|---|---:|---:|
| pcs | 203 | 222,963.13 |
| portateis_casa_forno_e_cafe | 76 | 47,445.71 |
| eletrodomesticos_2 | 238 | 113,317.74 |
| agro_industria_e_comercio | 212 | 72,530.47 |
| bebidas | 379 | 22,428.70 |
| alimentos_bebidas | 278 | 15,179.48 |
| alimentos | 510 | 29,393.41 |
| livros_tecnicos | 267 | 19,096.06 |
| telefonia_fixa | 264 | 59,583.00 |
| market_place | 311 | 28,378.47 |

该结果说明不同品类的销售数量和销售额贡献并不完全一致。

---

# 5. Customer Analysis

## 5.1 Customer Consumption Table

客户分析使用 `customer_unique_id` 作为客户标识，以识别同一真实消费者的多次购买。

客户消费宽表包括：

- customer_id
- order_count
- total_value
- average_order_value

示例 Top 10：

| Customer ID | Orders | Total Value | Average Order Value |
|---|---:|---:|---:|
| 0a0a92112bd4c708ca5fde585afaa872 | 1 | 13,664.08 | 13,664.08 |
| 46450c74a0d8c5ca9395da1daac6c120 | 3 | 9,553.02 | 3,184.34 |
| da122df9eeddfedc1dc1f5349a1a690c | 2 | 7,571.63 | 3,785.82 |
| 763c8b1c9c68a0229c42c9fc6f662b93 | 1 | 7,274.88 | 7,274.88 |
| dc4802a71eae9be1dd28f5d788ceb526 | 1 | 6,929.31 | 6,929.31 |

## 5.2 Customer Segmentation by Purchase Frequency

| Purchase Frequency | Customers |
|---|---:|
| 1 | 93,098 |
| 2 | 2,745 |
| 3+ | 252 |

## 5.3 Repeat Purchase Rate

```sql
SELECT
    COUNT(*) AS customers,
    SUM(order_count > 1) AS repeat_customers,
    SUM(order_count > 1) / COUNT(*) AS repeat_rate
FROM t3;
```

结果：

| Metric | Value |
|---|---:|
| Customers | 96,095 |
| Repeat Customers | 2,997 |
| Repeat Rate | 3.12% |

从购买频次分布来看，客户主要为一次性购买。

---

# 6. Regional Analysis

按照客户所在州统计订单量、客户数、销售额和平均订单金额。

## Core Markets

| State | Orders | Customers | Revenue | AOV |
|---|---:|---:|---:|---:|
| SP | 41,745 | 41,745 | 5,998,226.96 | 143.69 |
| RJ | 12,852 | 12,852 | 2,144,379.69 | 166.85 |
| MG | 11,635 | 11,635 | 1,872,257.26 | 160.92 |
| RS | 5,466 | 5,466 | 890,898.54 | 162.99 |
| PR | 5,045 | 5,045 | 811,156.38 | 160.78 |
| SC | 3,637 | 3,637 | 623,086.43 | 171.32 |
| BA | 3,380 | 3,380 | 616,645.82 | 182.44 |
| DF | 2,140 | 2,140 | 355,141.08 | 165.95 |
| GO | 2,020 | 2,020 | 350,092.31 | 173.31 |
| ES | 2,033 | 2,033 | 325,967.55 | 160.34 |

SP has the highest order volume and revenue among the listed states.

---

# 7. Logistics Analysis

## 7.1 Delivery Time

配送时间使用：

```text
Actual Delivery Days
= order_delivered_customer_date
- order_purchase_timestamp
```

预计配送时间使用：

```text
Estimated Delivery Days
= order_estimated_delivery_date
- order_purchase_timestamp
```

## 7.2 Late Delivery Definition

```sql
CASE
    WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 'on_time'
    WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN 'late'
END
```

## 7.3 Overall Logistics Result

| Metric | Value |
|---|---:|
| Delivered Orders | 96,478 |
| On-time Orders | 88,652 |
| Late Orders | 7,826 |
| Wrong Orders | 0 |
| Late Rate | 8.11% |

延迟率计算：

```text
Late Rate
= Late Orders / (On-time Orders + Late Orders)
= 7,826 / 96,478
≈ 8.11%
```

---

# 8. Logistics by State

| State | Orders | On-time | Late | Avg Days | Late Rate |
|---|---:|---:|---:|---:|---:|
| RR | 41 | 36 | 5 | 29.34 | 12.20% |
| AP | 67 | 64 | 3 | 27.18 | 4.48% |
| AM | 145 | 139 | 6 | 26.36 | 4.14% |
| AL | 397 | 302 | 95 | 24.50 | 23.93% |
| PA | 946 | 829 | 117 | 23.73 | 12.37% |
| MA | 717 | 576 | 141 | 21.51 | 19.67% |
| SE | 335 | 284 | 51 | 21.46 | 15.22% |
| CE | 1,279 | 1,083 | 196 | 21.20 | 15.32% |
| AC | 80 | 77 | 3 | 21.00 | 3.75% |
| PB | 517 | 460 | 57 | 20.39 | 11.03% |
| PI | 476 | 400 | 76 | 19.40 | 15.97% |
| RO | 243 | 236 | 7 | 19.28 | 2.88% |
| BA | 3,256 | 2,799 | 457 | 19.28 | 14.04% |
| RN | 474 | 423 | 51 | 19.22 | 10.76% |
| PE | 1,593 | 1,421 | 172 | 18.40 | 10.80% |
| MT | 886 | 826 | 60 | 18.00 | 6.77% |
| TO | 274 | 239 | 35 | 17.60 | 12.77% |
| ES | 1,995 | 1,751 | 244 | 15.72 | 12.23% |
| MS | 701 | 620 | 81 | 15.54 | 11.55% |
| GO | 1,957 | 1,797 | 160 | 15.54 | 8.18% |
| RS | 5,345 | 4,963 | 382 | 15.25 | 7.15% |
| RJ | 12,350 | 10,686 | 1,664 | 15.24 | 13.47% |
| SC | 3,546 | 3,200 | 346 | 14.90 | 9.76% |
| DF | 2,080 | 1,933 | 147 | 12.90 | 7.07% |
| MG | 11,354 | 10,717 | 637 | 11.95 | 5.61% |
| PR | 4,923 | 4,677 | 246 | 11.94 | 5.00% |
| SP | 40,501 | 38,114 | 2,387 | 8.70 | 5.89% |

需要注意：部分州订单量非常低，因此其平均配送时间或延迟率不宜直接与高订单量州进行等量比较。

---

# 9. Monthly Logistics

| Month | Orders | On-time | Late | Avg Days | Late Rate |
|---|---:|---:|---:|---:|---:|
| 2018-08 | 6,351 | 5,691 | 660 | 7.66 | 10.39% |
| 2018-07 | 6,159 | 5,883 | 276 | 8.88 | 4.48% |
| 2018-06 | 6,099 | 6,016 | 83 | 9.16 | 1.36% |
| 2018-05 | 6,749 | 6,193 | 556 | 11.34 | 8.24% |
| 2018-04 | 6,798 | 6,437 | 361 | 11.42 | 5.31% |
| 2018-03 | 7,003 | 5,507 | 1,496 | 16.24 | 21.36% |
| 2018-02 | 6,555 | 5,507 | 1,048 | 16.87 | 15.99% |
| 2018-01 | 7,069 | 6,605 | 464 | 14.01 | 6.56% |
| 2017-12 | 5,513 | 5,051 | 462 | 15.31 | 8.38% |
| 2017-11 | 7,289 | 6,246 | 1,043 | 15.07 | 14.31% |
| 2017-10 | 4,478 | 4,241 | 237 | 11.73 | 5.29% |
| 2017-09 | 4,150 | 3,934 | 216 | 11.72 | 5.20% |
| 2017-08 | 4,193 | 4,054 | 139 | 11.02 | 3.32% |
| 2017-07 | 3,872 | 3,739 | 133 | 11.49 | 3.43% |
| 2017-06 | 3,135 | 3,014 | 121 | 12.01 | 3.86% |
| 2017-05 | 3,546 | 3,418 | 128 | 11.42 | 3.61% |
| 2017-04 | 2,303 | 2,122 | 181 | 15.02 | 7.86% |
| 2017-03 | 2,546 | 2,404 | 142 | 13.04 | 5.58% |
| 2017-02 | 1,653 | 1,600 | 53 | 13.30 | 3.21% |
| 2017-01 | 750 | 727 | 23 | 12.75 | 3.07% |
| 2016-12 | 1 | 1 | 0 | 5.00 | 0.00% |
| 2016-10 | 265 | 262 | 3 | 19.63 | 1.13% |
| 2016-09 | 1 | 0 | 1 | 55.00 | 100.00% |

2016-09 和 2016-12 的订单量分别只有 1 单，因此在趋势解读时不作为正常经营月份进行比较。

---

# 10. Logistics × Review

## Calculation

将订单配送状态与 `order_reviews` 进行关联：

```sql
SELECT
    late_or_no,
    COUNT(*) AS orders,
    AVG(score) AS average_score,
    SUM(CASE WHEN score = 1 THEN 1 ELSE 0 END) / COUNT(*) AS one_star_rate
FROM t2
GROUP BY late_or_no;
```

## Result

| Delivery Status | Orders | Average Review Score | 1-Star Rate |
|---|---:|---:|---:|
| On time | 88,660 | 4.2937 | 6.60% |
| Late | 7,699 | 2.5667 | 46.15% |

## Interpretation

正常配送和延迟配送订单之间存在明显的评价差异：

- 正常配送平均评分：4.2937
- 延迟配送平均评分：2.5667
- 正常配送 1 星率：6.60%
- 延迟配送 1 星率：46.15%

该分析显示配送状态与用户评价之间存在明显关联。

**注意：该分析属于关联分析，不能仅凭该结果证明延迟配送与低评分之间存在因果关系。**

---

# 11. Business Conclusions

## Sales

平台付费订单量为 99,440，支付金额合计 16,008,872.12，平均订单金额约 160.99。

## Product

不同品类的销量和销售额排名存在差异。部分品类销量较高但销售额排名相对靠后，而部分品类销量较低但销售额贡献较高。

## Customer

客户主要集中在一次性购买：

- 1 次购买：93,098
- 2 次购买：2,745
- 3 次及以上：252
- 复购率：3.12%

## Region

SP 是订单量和销售额最高的州，同时 RJ、MG 等州也是重要市场。

## Logistics

已完成配送订单中：

- 准时配送：88,652
- 延迟配送：7,826
- 延迟率：8.11%

不同地区配送效率存在明显差异，但低订单量地区的结果需要谨慎解释。

## Review

延迟配送订单的平均评价明显低于正常配送订单，且 1 星评价比例明显更高，说明配送体验与用户评价之间存在明显关联。

---

# 12. Main SQL Skills Demonstrated

- Multi-table JOIN
- GROUP BY
- Aggregate Functions
- CASE WHEN
- CTE
- Window Functions
- RANK()
- ROW_NUMBER()
- DATE_FORMAT()
- DATEDIFF()
- Data Quality Checks
- One-to-many relationship handling
- Business metric calculation

