SELECT   is_trial
       , name_partner
       , buy_rank
       , COUNT(*) AS cnt
FROM
   (
      SELECT a.*
             , RANK() OVER (PARTITION BY user_id ORDER BY date_purchase) AS buy_rank
             , name_partner
      FROM skycinema.client_sign_up a 
        JOIN skycinema.partner_dict b 
        ON a.partner = b.id_partner
   ) AS t
GROUP BY is_trial, name_partner, buy_rank
ORDER BY is_trial, name_partner, buy_rank
