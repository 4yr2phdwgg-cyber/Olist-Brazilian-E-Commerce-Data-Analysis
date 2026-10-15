with t1 as(
select order_id, date_format(order_purchase_timestamp,'%y_%m') as dat 
from orders 
where order_status='delivered'
), 
t2 as(
select p.order_id,sum(p.payment_value) as revenue,t1.dat 
from order_payments p 
join t1 on p.order_id=t1.order_id 
group by p.order_id, t1.dat
) 
select dat,count(order_id) as orders,sum(revenue) as rev 
from t2
group by dat; 
