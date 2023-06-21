select t1.mm
        , class_cnt
        , user_cnt
        , total_payment
from
(
select date_trunc('month', class_start_datetime) as mm
        , count(case when class_status = 'success' then 1 end) as class_cnt
        , count(user_id) as user_cnt
from skyeng_db.classes
where date_trunc('year', class_start_datetime) = '2017-01-01'
group by mm
) t1
full join

(
select date_trunc('month', transaction_datetime) as mm
        , sum(payment_amount) as total_payment
from skyeng_db.payments
where payment_amount > 0 and date_trunc('year', transaction_datetime) = '2017-01-01'
group by mm
) t2
on t1.mm = t2.mm
