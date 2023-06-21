/*Задача 1 способ 1*/

select  case when user_id in(
                            select 
                                    user_id 
                            from skyeng_db.payments
                                where status_name = 'success'
                                group by user_id
                                having avg(classes) > 25 and count(*) > 3
                                ) then 1 
                                else 0 end as user_flag
        , avg(class_end_datetime -  class_start_datetime) as avg_duration
from skyeng_db.classes
    where class_status = 'success'
    and date_trunc('year', class_start_datetime) = '2016-01-01'
    and class_end_datetime - class_start_datetime between interval '20 minute' and interval '3 hour'
    group by user_flag

/*Задача 1 способ 2*/

select case when b.user_id is not null then 1 else 0 end as user_flag
        , avg(class_end_datetime -  class_start_datetime) as avg_duration
from skyeng_db.classes a 
                        left join (
                            select 
                                    user_id 
                            from skyeng_db.payments
                                where status_name = 'success'
                                group by user_id
                                having avg(classes) > 25 and count(*) > 3
                            ) b
                        on a.user_id = b.user_id
    where class_status = 'success'
    and date_trunc('year', class_start_datetime) = '2016-01-01'
    and class_end_datetime - class_start_datetime between interval '20 minute' and interval '3 hour'
    group by user_flag
