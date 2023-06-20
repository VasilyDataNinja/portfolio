with first_payments as 
        (
        select  user_id
                , min(date_trunc('day', transaction_datetime)) as first_payment_date
        from skyeng_db.payments
            where status_name = 'success'
        group by user_id
        )
, all_dates as 
        (
        select generate_series('2016-01-01'::date, '2016-12-31'::date, '1 day'::interval) as dt
        )
, payments_by_dates as 
        (
        select user_id
                , date_trunc('day', transaction_datetime) as payment_date
                , sum(classes) as transaction_balance_change
        from skyeng_db.payments
            where status_name = 'success'
        group by user_id, payment_date
        order by user_id
        )
, all_dates_by_user as
        (
        select *
        
        from first_payments a 
            join all_dates b
            on a.first_payment_date <= b.dt
        )
, classes_by_dates as
        (
        select  user_id
                , date_trunc('day', class_start_datetime) as class_date
                , count(id_class)*-1 as classes
        from skyeng_db.classes
            where class_status in('success','failed_by_student')
            and class_type != 'trial'
        group by user_id, class_date
        )
, payments_by_dates_cumsum as
        (
        select a.user_id
                , dt
                , coalesce(transaction_balance_change,0) as transaction_balance_change
                , sum(coalesce(transaction_balance_change,0)) over (partition by a.user_id order by dt rows between unbounded preceding and current row) as transaction_balance_change_cs
        from all_dates_by_user a
            left join payments_by_dates b
            on a.user_id = b.user_id 
            and a.dt = b.payment_date
        )
, classes_by_dates_dates_cumsum as 
        (
        select a.user_id
                , dt
                , coalesce(classes,0) as classes
                , sum(coalesce(classes,0)) over (partition by a.user_id order by dt rows between unbounded preceding and current row) as classes_cs
        from all_dates_by_user a 
            left join classes_by_dates b
            on a.user_id = b.user_id and a.dt = b.class_date
        )
, balances as
        (
        select a.user_id
                , a.dt
                , transaction_balance_change
                , transaction_balance_change_cs
                , classes
                , classes_cs
                , classes_cs + transaction_balance_change_cs as balance
        from payments_by_dates_cumsum a
            join classes_by_dates_dates_cumsum b
            on a.user_id = b.user_id and a.dt = b.dt
        )
select *
from balances
/*Убрать дни когда баланс студента не менялся*/
-- where (transaction_balance_change != 0 or classes != 0)
/*Если потребуется посмотреть балансы определённого студента*/
-- and user_id = 1953678
order by user_id, dt
limit 1000
