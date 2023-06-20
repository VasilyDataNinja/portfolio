SELECT  name_partner
        , COUNT(CASE WHEN buy_rank = 2 THEN 1 END) / COUNT(DISTINCT user_id)::FLOAT AS second_buy
        , COUNT(CASE WHEN buy_rank = 3 THEN 1 END) / COUNT(DISTINCT user_id)::FLOAT AS third_buy
        , COUNT(CASE WHEN buy_rank = 4 THEN 1 END) / COUNT(DISTINCT user_id)::FLOAT AS fourth_buy
        , COUNT(CASE WHEN buy_rank = 5 THEN 1 END) / COUNT(DISTINCT user_id)::FLOAT AS fifth_buy
        , COUNT(CASE WHEN buy_rank = 6 THEN 1 END) / COUNT(DISTINCT user_id)::FLOAT AS sixth_buy
FROM 
   (
      SELECT  a.*
             , RANK() OVER (PARTITION BY user_id ORDER BY date_purchase) AS buy_rank
             , name_partner
      FROM skycinema.client_sign_up a 
        JOIN skycinema.partner_dict b 
        ON a.partner = b.id_partner
   ) AS t1
GROUP BY name_partner
ORDER BY name_partner
