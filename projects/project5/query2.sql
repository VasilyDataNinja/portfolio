/*Задача 2 способ 1*/

select  max_teaching_level
        , sum(class_end_datetime - class_start_datetime) as sum_teaching
from skyeng_db.classes a    join skyeng_db.teachers b 
                            on a.id_teacher = b.id_teacher
    where max_teaching_level is not null and user_id in ( 
                                                        select 
                                                            user_id
                                                        from skyeng_db.classes
                                                            where class_status = 'success'
                                                        group by user_id
                                                        having sum(class_end_datetime  - class_start_datetime) > interval '48 hour'
                                                        )
group by max_teaching_level
order by sum_teaching desc

/*Задача 2 способ 2*/

select  max_teaching_level
        , sum(class_end_datetime  - class_start_datetime) as sum_teaching
from skyeng_db.classes a    join skyeng_db.teachers b 
                            on a.id_teacher = b.id_teacher 
                                    left join ( 
                                                select 
                                                    user_id
                                                from skyeng_db.classes
                                                    where class_status = 'success'
                                                group by user_id
                                                having sum(class_end_datetime  - class_start_datetime) > interval '48 hour') c 
                                    on a.user_id = c.user_id
    where max_teaching_level is not null 
    and c.user_id is not null
group by max_teaching_level
order by sum_teaching desc
