# Olist E-Commerce Data Analysis

基于 Olist Brazilian E-Commerce Public Dataset 的电商经营分析项目。

本项目使用 MySQL / SQL 对订单、支付、商品、客户、地区、物流和评价数据进行分析，并进一步整理为可用于 Power BI 数据看板的数据分析结果。

## 1. Project Overview

**Project Type:** E-commerce Business Data Analysis  
**Dataset:** Olist Brazilian E-Commerce Public Dataset  
**Database:** MySQL 8.0  
**Analysis Tools:** SQL / MySQL Workbench / Power BI  
**Focus:** Sales, Product, Customer, Region, Logistics, Review

项目重点不是单纯展示 SQL 语法，而是从业务问题出发完成：

> 数据理解 → 数据质量检查 → SQL 数据处理 → 指标分析 → 业务结论 → Dashboard

## 2. Dataset

数据包含以下主要表：

- `customers`：客户信息
- `orders`：订单信息
- `order_items`：订单商品明细
- `products`：商品信息
- `sellers`：卖家信息
- `order_payments`：订单支付信息
- `order_reviews`：订单评价信息
- `geolocation`：地理位置信息
- `product_category_name_translation`：商品类别英文映射

本项目使用的原始数据未上传至 GitHub，仅保留数据说明、SQL 分析逻辑和分析结果。

## 3. Business Questions

### Sales
- 平台整体销售规模如何？
- 月度销售额如何变化？

### Product
- 哪些商品品类销量最高？
- 哪些商品品类销售额最高？
- 销量排名和销售额排名是否存在明显差异？

### Customer
- 客户整体消费情况如何？
- 客户主要是一次性购买还是重复购买？
- 平台复购率如何？

### Region
- 哪些州是核心销售市场？
- 不同地区的订单量、销售额和客单价如何？

### Logistics
- 平台整体配送效率如何？
- 平均配送时间是多少？
- 延迟配送比例是多少？
- 不同地区、不同月份的物流表现如何？

### Review
- 正常配送和延迟配送用户的评价是否存在明显差异？

## 4. Analysis Workflow

```text
Raw Data
   ↓
Data Understanding
   ↓
Data Quality Checks
   ↓
MySQL Data Processing
   ↓
Business Metrics
   ↓
Sales / Product / Customer / Region / Logistics / Review Analysis
   ↓
Power BI Dashboard
```

## 5. Key Findings

### 5.1 Overall Sales

- Paid orders: **99,440**
- Revenue: **16,008,872.12**
- Average order value: **160.99**

订单量和销售额均基于 `order_payments` 聚合结果计算。

### 5.2 Monthly Sales

月度销售趋势使用订单的 `order_purchase_timestamp` 作为月份划分，并先按 `order_id` 汇总支付金额，再与订单表关联，以避免支付表一对多关系造成销售额重复计算。

由于平台早期及数据末期部分月份订单量极低，项目在月度趋势可视化中剔除：

- 2016-09
- 2016-12
- 2018-09
- 2018-10

**注意：这里是在分析和可视化阶段排除低样本月份，并未修改原始数据。**

### 5.3 Product

按商品明细统计销量 Top 10：

| Category | Item Count | Revenue |
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

销售额 Top 10 中，`beleza_saude`、`relogios_presentes` 等品类表现突出。

销量和销售额排名并不完全一致，说明商品销量与单件商品价值之间存在差异。

### 5.4 Customer

客户消费频次：

| Purchase Frequency | Customers |
|---|---:|
| 1 | 93,098 |
| 2 | 2,745 |
| 3+ | 252 |

- Total customers analyzed: **96,095**
- Repeat customers: **2,997**
- Repeat rate: **3.12%**

从客户购买次数分布来看，客户主要集中在一次购买。

### 5.5 Region

销售额较高的州包括：

| State | Orders | Revenue | AOV |
|---|---:|---:|---:|
| SP | 41,745 | 5,998,226.96 | 143.69 |
| RJ | 12,852 | 2,144,379.69 | 166.85 |
| MG | 11,635 | 1,872,257.26 | 160.92 |
| RS | 5,466 | 890,898.54 | 162.99 |
| PR | 5,045 | 811,156.38 | 160.78 |
| SC | 3,637 | 623,086.43 | 171.32 |
| BA | 3,380 | 616,645.82 | 182.44 |

SP 是订单量和销售额最高的州。

### 5.6 Logistics

已完成配送订单：

- Delivered orders: **96,478**
- On-time orders: **88,652**
- Late orders: **7,826**
- Late rate: **8.11%**

地区配送分析显示，不同州之间的平均配送时间和延迟率存在差异。

例如：

- RR：平均配送时间 29.34 天，但订单量只有 41
- SP：平均配送时间 8.70 天，订单量 40,501
- RJ：平均配送时间 15.24 天，订单量 12,350
- MG：平均配送时间 11.95 天，订单量 11,354

因此，对于订单量非常小的州，需要谨慎解读其平均配送时间。

### 5.7 Monthly Logistics

部分月份存在较明显的延迟率波动：

- 2018-03：21.36%
- 2018-02：15.99%
- 2017-11：14.31%
- 2018-08：10.39%
- 2018-05：8.24%

2016-09 和 2016-12 的订单量极低，因此不适合用于判断平台正常物流趋势。

### 5.8 Logistics × Review

正常配送和延迟配送订单的评价结果：

| Delivery Status | Orders | Average Review Score | 1-Star Rate |
|---|---:|---:|---:|
| On time | 88,660 | 4.2937 | 6.60% |
| Late | 7,699 | 2.5667 | 46.15% |

延迟配送用户的平均评分明显低于正常配送用户，且 1 星评价占比明显更高。

这里的结论应理解为**关联关系**，不能仅凭该分析直接证明延迟配送导致低评分。

## 6. Data Quality Notes

项目过程中进行了以下数据质量检查：

- 主键重复检查
- 主键 NULL 检查
- 商品价格异常检查
- 运费异常检查
- 商品属性异常检查
- 评价数据重复检查
- 评价评分分布检查
- 订单状态分布检查

部分商品存在重量或尺寸为 0 的情况，需要结合业务规则进一步判断是否属于真实缺失值或异常值。

`order_reviews` 中存在部分 `review_id` 重复情况，因此评价分析时需要注意数据粒度。

## 7. SQL Techniques

本项目使用的主要 SQL 技术包括：

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `COUNT`
- `SUM`
- `AVG`
- `CASE WHEN`
- `JOIN`
- `CTE`
- Window Functions
- `RANK()`
- `ROW_NUMBER()`
- `DATE_FORMAT()`
- `DATEDIFF()`

其中重点处理了订单、支付、商品、客户之间的一对多关系，避免直接 JOIN 导致指标重复计算。

## 8. Dashboard Plan

计划使用 Power BI 构建三页数据看板：

### Page 1 — Executive Overview

- Total Orders
- Revenue
- Average Order Value
- Late Delivery Rate
- Monthly Revenue
- Revenue by State

### Page 2 — Customer & Product

- Customer Purchase Frequency
- Repeat Purchase Rate
- Top Product Categories
- Category Sales
- Category Revenue

### Page 3 — Logistics & Review

- Average Delivery Days
- Late Delivery Rate
- Late Rate by State
- Monthly Late Rate
- Review Score by Delivery Status

## 9. Repository Structure

```text
olist-ecommerce-analysis/
├── README.md
├── analysis_results.md
└── dashboard/
    └── screenshots/
```

## 10. Notes

本项目主要用于展示本人在：

- MySQL / SQL
- 数据清洗与数据质量检查
- 多表关联
- CTE 与窗口函数
- 商业指标分析
- 客户分析
- 商品分析
- 地区分析
- 物流分析
- 数据可视化

方面的实践能力。

后续将继续完善 Power BI Dashboard，并补充更完整的业务分析与可视化结果。
