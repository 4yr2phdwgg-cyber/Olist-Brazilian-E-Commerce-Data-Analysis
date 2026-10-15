with t1 as(select
o1.customer_id,
o1.order_id,
o2.customer_unique_id,
o2.customer_state
from orders o1
join customers o2
on o1.customer_id=o2.customer_id
where order_status='delivered'),
t2 as(select
order_id,
sum(payment_value)as rev
from order_payments
group by order_id),
t3 as(select
t2.order_id,
t2.rev,
t1.customer_unique_id,
t1.customer_state
from t2
join t1
on t2.order_id=t1.order_id)
select
customer_state as state,
count(order_id) as orders,
count(customer_unique_id) as customers,
sum(rev) as revenue,
sum(rev)/count(order_id) as AOV
from t3
group by customer_state