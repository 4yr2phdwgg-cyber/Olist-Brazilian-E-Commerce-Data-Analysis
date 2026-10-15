with t1 as(select
order_purchase_timestamp as tim,
order_id,
customer_id
from orders
where order_status='delivered'),
t2 as(select
c.customer_unique_id as id,
c.customer_state as state,
t1.order_id,
t1.tim
from t1
join customers c
on t1.customer_id=c.customer_id),
t3 as(select
t2.id,
t2.state,
t2.order_id,
t2.tim,
round(sum(p.payment_value),2)as pay
from t2
join order_payments p
on t2.order_id=p.order_id
group by t2.id,t2.state,t2.order_id,t2.tim
)
select
id,
state,
count(order_id) as orders, 
round(sum(pay),2) as money, 
max(tim) as last_buy_time 
from t3
group by id,state;







