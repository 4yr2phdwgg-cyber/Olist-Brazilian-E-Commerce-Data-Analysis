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
where order_status='delivered')
select
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
on t1.order_id=r.order_id
