select  left_w_order
        , count(*) as left_count
from skytaxi.airport_visit
where id_driver in  (select id_driver from
                        (
                            select *
                                    , rank() over (order by total_wait_time desc) as wait_rank
                            
                            from 
                            (
                            
                                select id_driver
                                        , sum(time_left - time_came) as total_wait_time
                                from skytaxi.airport_visit
                                    where id_driver in  (select id_driver 
                                                        from skytaxi.airport_visit
                                                            group by id_driver 
                                                            having count(*) > 1 
                                                        )
                                group by id_driver
                                order by total_wait_time desc
                            ) t1
                        ) t2
                        where wait_rank <= 10
                    )
group by left_w_order
