with c as(select
c.customer_unique_id,
c.customer_state,
o.order_id
from orders o
join customers c
on o.customer_id=c.customer_id),
t2 as(select
c.order_id,
c.customer_unique_id,
c.customer_state,
sum(p.payment_value)as pay
from c
join order_payments p
on c.order_id=p.order_id
group by order_id)
select
customer_state as state,
count(order_id)as orders,
count(customer_unique_id)as customers,
sum(pay)as rev
from t2
group by customer_state



