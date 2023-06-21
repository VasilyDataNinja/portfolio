with port_a as (
                select 
                    id_port
                from skytaxi.airport_visit
                group by id_port
                having count(*) > 100
                ),  
id_driver_a as (
                select id_driver
                from skytaxi.airport_visit
                group by id_driver
                having sum(time_left - time_came) > interval '12 hour'
                )
select  avg(time_left - time_came) as avg_wait_time
        , count(case when left_w_order = 1 then 1 else null end)/count(*)::float as flag_left_w_order
from skytaxi.airport_visit
    where id_driver in (select * from id_driver_a) and id_port in (select * from port_a)
