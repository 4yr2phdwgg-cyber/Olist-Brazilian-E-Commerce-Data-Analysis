with t1 as(select
o.order_id,
datediff(o.order_estimated_delivery_date,o.order_purchase_timestamp)as estimated,
datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)as actual,
case
when o.order_delivered_customer_date<= o.order_estimated_delivery_date
then 'on_time'
when o.order_delivered_customer_date> o.order_estimated_delivery_date
then 'late'
end as late_or_no,
c.customer_state as state
from orders o
join customers c
on o.customer_id=c.customer_id
where order_status='delivered'),
t2 as(select
t1.order_id,
t1.estimated,
t1.actual,
t1.late_or_no,
t1.state,
r.review_score,
case
when t1.late_or_no='late' then t1.actual-t1.estimated
else 0
end as late_days
from t1
join order_reviews r
on t1.order_id=r.order_id),
t3 as (select
state,count(*)as orders,
sum(
case
when late_or_no='late' then review_score
else 0
end)as latescores,
sum(
case
when late_or_no='on_time' then review_score
else 0
end)as ontimescores,
sum(review_score)as scores,
sum(case
when late_or_no='on_time' then 1
else 0
end) as on_time_orders,
sum(case
when late_or_no='late' then 1
else 0
end) as late_orders,
sum(actual)as ac,
sum(late_days)as late_days
from t2
group by state)
select
state,
orders,
on_time_orders,
late_orders,
ac/orders as avg_days,
late_days/late_orders as avg_late_days,
scores/orders as avg_score,
ontimescores/on_time_orders as avg_score_ontime,
latescores/late_orders as avg_score_late,
late_orders/(on_time_orders+late_orders)as late_rate
from t3
