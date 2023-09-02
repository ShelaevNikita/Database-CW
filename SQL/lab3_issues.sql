/* DATABASE online_electronics_store, 
   SCHEMA str */

/* 1) Вывести 10 категорий, товары которых имели наибольший относительный рост (в количестве продаж единиц) 
	за последний месяц по отношению к предыдущему: */

CREATE OR REPLACE VIEW str.cat_max_10 AS	
	WITH dev_count AS (
			SELECT dev.id AS dev_id, SUM(purch_devc.device_count) AS device_day_sum,
			purch_order.date_of_purchase AS date_of_purchase FROM 
			(str.device dev INNER JOIN str.purchased_device purch_devc ON purch_devc.device_id = dev.id)
				INNER JOIN str.purchase_order purch_order ON purch_devc.purchase_order_id = purch_order.id
			WHERE purch_order.date_of_purchase BETWEEN (CURRENT_DATE - integer '60') AND CURRENT_DATE
			GROUP BY (dev.id, date_of_purchase)),
		cat_last_count AS (
			SELECT cat.category_name AS cat_name, SUM(dev_count.device_day_sum) AS cat_month_sum FROM 
			(str.device_category cat INNER JOIN str.category_criteria cat_crit ON cat.id = cat_crit.category_id)
				INNER JOIN dev_count ON cat_crit.device_id = dev_count.dev_id
			WHERE dev_count.date_of_purchase BETWEEN (CURRENT_DATE - integer '60') AND (CURRENT_DATE - integer '30')
			GROUP BY cat_name),
		cat_now_count AS (
			SELECT cat.category_name AS cat_name, SUM(dev_count.device_day_sum) AS cat_month_sum FROM 
			(str.device_category cat INNER JOIN str.category_criteria cat_crit ON cat.id = cat_crit.category_id)
				INNER JOIN dev_count ON cat_crit.device_id = dev_count.dev_id
			WHERE dev_count.date_of_purchase BETWEEN (CURRENT_DATE - integer '30') AND CURRENT_DATE
			GROUP BY cat_name)
	SELECT COALESCE(cat_now.cat_name, cat_last.cat_name) AS category_name,
		(COALESCE(cat_now.cat_month_sum, 0) - COALESCE(cat_last.cat_month_sum, 0))::INT AS month_inc
		FROM cat_last_count cat_last FULL JOIN cat_now_count cat_now ON cat_now.cat_name = cat_last.cat_name
		ORDER BY month_inc DESC
		LIMIT 10;
	
CREATE OR REPLACE FUNCTION str.device_inc_10()
	RETURNS TABLE (category_name VARCHAR(50), month_inc INT) AS $$
	DECLARE
		month_now SMALLINT;  year_now SMALLINT; 
		month_last SMALLINT; year_last SMALLINT;		
	BEGIN	
		month_now = EXTRACT(MONTH FROM CURRENT_DATE);
		year_now = EXTRACT(YEAR FROM CURRENT_DATE);
		IF month_now = 1 THEN month_last = 12; year_last = year_now - 1;
			ELSE month_last = month_now - 1; year_last = year_now; END IF;
	RETURN QUERY		
	WITH dev_count AS (
			SELECT dev.id AS dev_id, SUM(purch_devc.device_count) AS device_month_sum,
			EXTRACT(MONTH FROM purch_order.date_of_purchase) AS month_order,
			EXTRACT(YEAR FROM purch_order.date_of_purchase) AS year_order FROM 
			(str.device dev INNER JOIN str.purchased_device purch_devc ON purch_devc.device_id = dev.id)
				INNER JOIN str.purchase_order purch_order ON purch_devc.purchase_order_id = purch_order.id
			WHERE EXTRACT(YEAR FROM purch_order.date_of_purchase) >= year_last	
			GROUP BY (dev.id, month_order, year_order)),
		cat_last_count AS (
			SELECT cat.category_name AS cat_name, SUM(dev_count.device_month_sum) AS cat_month_sum FROM 
			(str.device_category cat INNER JOIN str.category_criteria cat_crit ON cat.id = cat_crit.category_id)
				INNER JOIN dev_count ON cat_crit.device_id = dev_count.dev_id
			WHERE ((dev_count.month_order = month_last) AND (dev_count.year_order = year_last))
			GROUP BY (cat.category_name, dev_count.month_order)),
		cat_now_count AS (
			SELECT cat.category_name AS cat_name, SUM(dev_count.device_month_sum) AS cat_month_sum FROM 
			(str.device_category cat INNER JOIN str.category_criteria cat_crit ON cat.id = cat_crit.category_id)
				INNER JOIN dev_count ON cat_crit.device_id = dev_count.dev_id
			WHERE ((dev_count.month_order = month_now) AND (dev_count.year_order = year_now))	
			GROUP BY (cat.category_name, dev_count.month_order))
		SELECT COALESCE(cat_now.cat_name, cat_last.cat_name) AS category_name,
			(COALESCE(cat_now.cat_month_sum, 0) - COALESCE(cat_last.cat_month_sum, 0))::INT AS month_inc
			FROM cat_last_count cat_last FULL JOIN cat_now_count cat_now ON cat_now.cat_name = cat_last.cat_name
			ORDER BY month_inc DESC
			LIMIT 10;	
	END;		
$$ LANGUAGE plpgsql;			
	
-- 2) Вывести товары, которые никогда не были куплены в заданном офисе:

CREATE OR REPLACE FUNCTION str.no_device_in_office(office_number INT) 
	RETURNS TABLE (device_name VARCHAR(100), price INT, rating DEC(2, 1)) AS $$
	SELECT device_name, price, rating FROM str.device
	WHERE id NOT IN (SELECT purch_devc.device_id FROM 
		(str.office offc INNER JOIN str.purchase_order purord ON purord.office_id = offc.id) 
			INNER JOIN str.purchased_device purch_devc ON purch_devc.purchase_order_id = purord.id
		WHERE offc.store_number = office_number);
$$ LANGUAGE SQL;	

-- 3) Вывести месяц, в который было наибольшее количество первых заказов пользователей в абсолютном выражении:

-- Только месяц
CREATE OR REPLACE VIEW str.max_first_orders_month AS
	WITH first_orders AS (
		SELECT MIN(purch_order.date_of_purchase) AS date_purch FROM
			str.customer cust INNER JOIN str.purchase_order purch_order 
				ON purch_order.customer_id = cust.id
			GROUP BY cust.login)
	SELECT COUNT(EXTRACT(MONTH FROM date_purch)) AS first_orders,
			EXTRACT(MONTH FROM date_purch) AS month_order
		FROM first_orders
		GROUP BY month_order
		HAVING COUNT(EXTRACT(MONTH FROM date_purch)) >= ALL 
			(SELECT COUNT(EXTRACT(MONTH FROM date_purch)) AS first_orders 
			FROM first_orders
			GROUP BY EXTRACT(MONTH FROM date_purch));		

-- Год и месяц		
CREATE OR REPLACE VIEW str.max_first_orders_year AS
	WITH first_orders AS (
		SELECT MIN(purch_order.date_of_purchase) AS date_purch FROM
			str.customer cust INNER JOIN str.purchase_order purch_order 
				ON purch_order.customer_id = cust.id
			GROUP BY cust.login)
	SELECT COUNT(EXTRACT(MONTH FROM date_of_purchase)) AS first_orders,
		EXTRACT(MONTH FROM date_of_purchase) AS month_order,
		EXTRACT(YEAR FROM date_of_purchase) AS year_order
		FROM str.purchase_order
		GROUP BY (year_order, month_order)
		HAVING COUNT(EXTRACT(MONTH FROM date_of_purchase)) >= ALL 
			(SELECT COUNT(EXTRACT(MONTH FROM date_of_purchase)) AS first_orders 
			FROM str.purchase_order
			GROUP BY (EXTRACT(YEAR FROM date_of_purchase), EXTRACT(MONTH FROM date_of_purchase)));		
