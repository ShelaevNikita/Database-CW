-- DATABASE online_electronics_store

SET datestyle TO "Postgres, DMY";

-- Create Schema
CREATE SCHEMA IF NOT EXISTS str;

CREATE DOMAIN str.phone_code 		AS VARCHAR(20) 
	CHECK (VALUE ~ '^\+?\d{1,3}-[(]\d{3}[)]-\d{3}-\d{4}$');

CREATE DOMAIN str.email_code 		AS VARCHAR(100) 
	CHECK (VALUE ~ '^[A-Za-z0-9._-]+@([a-z]+\.)+[a-z]+$');

CREATE DOMAIN str.name_check 		AS VARCHAR(50)
	CHECK (VALUE ~ '^[A-Z][A-Za-z -]*$');
	
CREATE DOMAIN str.date_check 		AS DATE 
	CHECK (VALUE BETWEEN DATE '01-01-2010' AND CURRENT_DATE); 
	
CREATE DOMAIN str.rating_check 		AS DEC(2, 1)
	CHECK (VALUE BETWEEN 0.0 AND 5.0);
	
CREATE DOMAIN str.int_natural		AS INT 			CHECK (VALUE > 0);

CREATE DOMAIN str.smallint_natural 	AS SMALLINT 	CHECK (VALUE > 0);

CREATE DOMAIN str.decimal_check 	AS DEC(11, 2) 	CHECK (VALUE >= 0.00);

CREATE DOMAIN str.address_check 	AS VARCHAR(50)
	CHECK (VALUE ~ '^[0-9A-Z][A-Za-z0-9 -\\]*$');	

CREATE TYPE str.device_type_enum  AS ENUM ('phone', 'tablet', 'laptop', 'PC', 'watch');

CREATE TYPE str.image_type_enum   AS ENUM ('PNG', 'GIF', 'JPEG', 'JPG', 'BMP', 'TIFF');

CREATE TYPE str.flag_of_work 	  AS ENUM ('Planned', 'In progress', 'Completed', 'Canceled', 'Postponed');
	
CREATE TYPE str.car_flag_enum 	  AS ENUM ('Available', 'Under repair', 'Busy', 'Moving out');

CREATE TYPE str.manufacturer_enum AS ENUM ('Intel', 'AMD', 'Huawei', 'Apple', 'Qualcomm', 'MediaTek', 'Spreadtrum');

-- Create 18 tables
CREATE TABLE IF NOT EXISTS str.customer (
	id 					SERIAL 			 	 PRIMARY KEY,
	login 				VARCHAR(50) 	 	 NOT NULL UNIQUE,
	password 			VARCHAR(50) 	 	 NOT NULL CHECK (password ~ '^[A-Za-z0-9]+$'),
	first_name 			str.name_check 		 NOT NULL,
	second_name 		str.name_check 		 NOT NULL,
	gender 				CHAR			 	 NOT NULL CHECK (gender = 'F' OR gender = 'M'),
	date_of_birth 		DATE 			 	 NOT NULL 
		CHECK (date_of_birth BETWEEN DATE '01-01-1900' AND CURRENT_DATE),
	age 				SMALLINT 		 	 NOT NULL CHECK (age BETWEEN 14 AND 120),
	phone 				str.phone_code 		 NOT NULL,
	email 				str.email_code 		 NOT NULL,
	registration_date 	str.date_check 		 NOT NULL DEFAULT CURRENT_DATE,
  --CHECK (EXTRACT(YEAR FROM age(date_of_birth))::SMALLINT = age),
	CHECK (registration_date > date_of_birth)
);

CREATE TABLE IF NOT EXISTS str.company (
	id 				SERIAL 		  	  PRIMARY KEY,
	company_name	VARCHAR(25)   	  NOT NULL UNIQUE  
		CHECK (company_name ~ '^[A-Z][A-Za-z -\\]+$'),
	company_website VARCHAR(100)  	  NOT NULL UNIQUE CHECK (company_website ~ '^https:.*$'),	
	country			str.address_check NOT NULL,
	city 			str.address_check
);

CREATE TABLE IF NOT EXISTS str.office (
	id 				SERIAL 					PRIMARY KEY,
	store_number 	str.int_natural 		NOT NULL UNIQUE,
	store_type 		VARCHAR(10) 			NOT NULL CHECK (store_type ~ '^(store|warehouse)$'),
	city 			str.address_check 		NOT NULL,
	street 			str.address_check 		NOT NULL,
	house_number 	VARCHAR(15) 			NOT NULL 
		CHECK (house_number ~ '^[1-9][0-9]*[A-Za-z]*(-[1-9]){0,2}$'),
	apartment 		str.smallint_natural 	NOT NULL DEFAULT 1,
	square 			str.decimal_check 		NOT NULL
);

CREATE TABLE IF NOT EXISTS str.employee (
	id 					SERIAL 			 	 PRIMARY KEY,
	personal_number 	str.int_natural 	 NOT NULL UNIQUE,
	employee_password	VARCHAR(50) 	 	 NOT NULL CHECK (employee_password ~ '^[A-Za-z0-9]+$'),
	first_name 			str.name_check 		 NOT NULL,
	second_name 		str.name_check 		 NOT NULL,
	gender 				CHAR				 NOT NULL CHECK (gender = 'F' OR gender = 'M'),
	date_of_birth 		DATE 			 	 NOT NULL 
		CHECK (date_of_birth BETWEEN DATE '01-01-1900' AND CURRENT_DATE),
	age 				SMALLINT 		 	 NOT NULL CHECK (age BETWEEN 16 AND 75),
	date_of_employment  str.date_check 		 NOT NULL, 
	contract_number 	VARCHAR(10) 		 NOT NULL 
		CHECK (contract_number ~ '^[A-Z0-9]+$'),
	employee_position	VARCHAR(50) 	 	 NOT NULL CHECK (employee_position ~ '^[a-z -]+$'),
	chief_id 			INT,
	office_id 			INT
		REFERENCES str.office(id) ON UPDATE CASCADE ON DELETE SET NULL,
	salary 				str.decimal_check 	 NOT NULL,
	phone 				str.phone_code 		 NOT NULL,
	email 				str.email_code 		 NOT NULL,
  --CHECK (EXTRACT(YEAR FROM age(date_of_birth))::SMALLINT = age),
	CHECK (date_of_employment > date_of_birth),
	UNIQUE (date_of_employment, contract_number)
);

ALTER TABLE str.employee ADD FOREIGN KEY (chief_id)
		REFERENCES str.employee(id) ON UPDATE CASCADE ON DELETE SET NULL;
		
CREATE TABLE IF NOT EXISTS str.processor_CPU (
	id 					SERIAL 			  	  PRIMARY KEY,
	CPU_manufacturer 	str.manufacturer_enum NOT NULL,
	CPU_line 			VARCHAR(15) 	  	  NOT NULL CHECK (CPU_line ~ '^[A-Z][A-Za-z0-9 ]+$'),
	CPU_model 			VARCHAR(25)		  	  NOT NULL CHECK (CPU_model ~ '^[A-Za-z0-9 ]+$'),
	frequency 			DEC(4, 2) 		  	  NOT NULL CHECK (frequency >= 0.00),
	number_of_cores 	str.smallint_natural  NOT NULL DEFAULT 1,
	UNIQUE (CPU_manufacturer, CPU_line, CPU_model)
);

CREATE TABLE IF NOT EXISTS str.device (
	id 						 SERIAL 			  PRIMARY KEY,
	device_type 			 str.device_type_enum NOT NULL,
	device_name 			 VARCHAR(100) 		  NOT NULL UNIQUE 
		CHECK (device_name ~ '^[A-Z][A-Za-z0-9 -\\]+$'),
	company_id 				 INT 
		REFERENCES str.company(id) ON UPDATE CASCADE ON DELETE SET NULL,
	price 					 str.decimal_check 	  NOT NULL,
	rating 					 str.rating_check 	  NOT NULL DEFAULT 2.5,
	warranty 				 SMALLINT 			  NOT NULL CHECK (warranty >= 0),
	release_year 			 SMALLINT 			  NOT NULL,
	height 					 str.decimal_check 	  NOT NULL,
	width 					 str.decimal_check 	  NOT NULL,
	thickness 				 str.decimal_check 	  NOT NULL,
	weight 					 str.int_natural	  NOT NULL,
	colour 					 VARCHAR(25) 		  NOT NULL CHECK (colour ~ '^[a-z -\\]+$'),
	material 				 VARCHAR(25) 		  NOT NULL CHECK (material ~ '^[a-z -\\]+$') DEFAULT 'plastic',
	screen_size 			 VARCHAR(12) 		  CHECK (screen_size ~ '^[1-9][0-9]*x[1-9][0-9]*$'),
	OS_info 				 VARCHAR(25) 		  NOT NULL CHECK (OS_info ~ '^[A-Za-z0-9 -.]+$'),
	processor_id 			 INT
		REFERENCES str.processor_CPU(id) ON UPDATE CASCADE ON DELETE SET NULL,
	battery_capacity 		 str.int_natural,
	RAM_capacity 	 		 str.smallint_natural NOT NULL,
	internal_memory_capacity str.int_natural 	  NOT NULL,
	camera 					 VARCHAR(30) 
		CHECK (camera ~ '^([1-9][0-9]*\+?){1,7}\\?([1-9][0-9]*\+?){0,3}$'),
	CHECK (release_year BETWEEN 1970 AND (EXTRACT(YEAR FROM CURRENT_DATE)::SMALLINT))
);

CREATE TABLE IF NOT EXISTS str.image (
	id 					SERIAL 				PRIMARY KEY,
	device_id 			INT 				NOT NULL 
		REFERENCES str.device(id) ON UPDATE CASCADE ON DELETE CASCADE,
	URI_image 			VARCHAR(250) 		NOT NULL UNIQUE CHECK (URI_image ~ '^(file|C|D|E):.*$'),
	image_type 			str.image_type_enum NOT NULL,
	comment_for_image 	VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS str.feedback (
	feedback_number 	SERIAL 				PRIMARY KEY,
	customer_id 		INT 
		REFERENCES str.customer(id) ON UPDATE CASCADE ON DELETE SET NULL,
	device_id 			INT 				NOT NULL 
		REFERENCES str.device(id) 	ON UPDATE CASCADE ON DELETE CASCADE,
	date_of_feedback 	str.date_check 		NOT NULL DEFAULT CURRENT_DATE,
	rating_of_device 	str.rating_check 	NOT NULL DEFAULT 2.5,
	flag_of_purchase 	BOOLEAN 			NOT NULL DEFAULT true,
	comment_feedback 	VARCHAR(1000),
	UNIQUE (customer_id, device_id)
);

CREATE TABLE IF NOT EXISTS str.basket (
	basket_number 		SERIAL 					PRIMARY KEY,
	customer_id 		INT 					NOT NULL 
		REFERENCES str.customer(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id 			INT 					NOT NULL 
		REFERENCES str.device(id) 	ON UPDATE CASCADE ON DELETE CASCADE,
	device_volume 		str.smallint_natural 	NOT NULL DEFAULT 1,
	date_device_added	str.date_check 			NOT NULL DEFAULT CURRENT_DATE,
	UNIQUE (customer_id, device_id, date_device_added)
);

CREATE TABLE IF NOT EXISTS str.favorite_device (
	customer_id 	INT 			NOT NULL 
		REFERENCES str.customer(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id 		INT 			NOT NULL 
		REFERENCES str.device(id) 	ON UPDATE CASCADE ON DELETE CASCADE,
	like_flag 		BOOLEAN 		NOT NULL DEFAULT false,	
	date_last_view 	str.date_check  NOT NULL DEFAULT CURRENT_DATE,
	PRIMARY KEY (customer_id, device_id)
);

CREATE TABLE IF NOT EXISTS str.purchase_order (
	id 					SERIAL 				PRIMARY KEY,
	customer_id 		INT 				NOT NULL
		REFERENCES str.customer(id) ON UPDATE CASCADE ON DELETE CASCADE,
	order_number 		str.int_natural 	NOT NULL UNIQUE,
	courier_id 			INT 
		REFERENCES str.employee(id) ON UPDATE CASCADE ON DELETE SET NULL,
	office_id 			INT 				NOT NULL DEFAULT 1
		REFERENCES str.office(id) 	ON UPDATE CASCADE ON DELETE SET DEFAULT,
	date_of_purchase 	str.date_check 		NOT NULL DEFAULT CURRENT_DATE,
	date_of_delivery 	DATE 				NOT NULL,
	order_flag 			str.flag_of_work  	NOT NULL,
	comment_for_order	VARCHAR(500),
	CHECK (date_of_delivery >= date_of_purchase)
);

CREATE UNIQUE INDEX IF NOT EXISTS order_number_index ON str.purchase_order (order_number);

CREATE TABLE IF NOT EXISTS str.purchased_device (
	purchase_order_id 	INT 			 	 NOT NULL
		REFERENCES str.purchase_order(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id 			INT 			 	 NOT NULL 
		REFERENCES str.device(id) 		  ON UPDATE CASCADE ON DELETE CASCADE,
	device_price 		str.decimal_check 	 NOT NULL,
	device_count 		str.smallint_natural NOT NULL DEFAULT 1,
	PRIMARY KEY (device_id, purchase_order_id)
);

CREATE TABLE IF NOT EXISTS str.budget (
	id 					SERIAL 			PRIMARY KEY,
	office_id 			INT 
		REFERENCES str.office(id) ON UPDATE CASCADE ON DELETE SET NULL,
	date_added 			str.date_check 	NOT NULL DEFAULT CURRENT_DATE,
	billing_month 		SMALLINT 		NOT NULL CHECK (billing_month BETWEEN 1 AND 12),
	billing_year 		SMALLINT 		NOT NULL
		CHECK (billing_year BETWEEN 2010 AND (EXTRACT(YEAR FROM date_added)::SMALLINT)),
	monthly_income 		DEC(14, 2) 		NOT NULL CHECK (monthly_income >= 0.0),
	monthly_expense 	DEC(14, 2) 		NOT NULL CHECK (monthly_expense >= 0.0),
	monthly_profit 		DEC(14, 2) 		NOT NULL
		CHECK (monthly_profit = monthly_income - monthly_expense),
	comment_for_budget 	VARCHAR(100),	
	UNIQUE (office_id, billing_month, billing_year)
);

CREATE TABLE IF NOT EXISTS str.warehouse_of_device (
	warehouse_id INT 					NOT NULL 
		REFERENCES str.office(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id 	 INT 					NOT NULL 
		REFERENCES str.device(id) ON UPDATE CASCADE ON DELETE CASCADE,
	quantity 	 str.smallint_natural 	NOT NULL DEFAULT 1,
	PRIMARY KEY (device_id, warehouse_id)
);

CREATE TABLE IF NOT EXISTS str.provider (
	id 			 SERIAL 			PRIMARY KEY,
	company_name VARCHAR(30) 		NOT NULL UNIQUE CHECK (company_name ~ '^[A-Z][A-Za-z -\\]+$'), 
	city 		 str.address_check 	NOT NULL,	
	phone 		 str.phone_code 	NOT NULL,
	email 		 str.email_code 	NOT NULL
);

CREATE TABLE IF NOT EXISTS str.transport (
	id 				  SERIAL 				PRIMARY KEY,
	car_name 		  VARCHAR(50) 			NOT NULL CHECK (car_name ~ '^[A-Z][A-Za-z0-9 -\\]+$'),
	car_number 		  VARCHAR(16) 			NOT NULL UNIQUE 
		CHECK (car_number ~ '^[A-Z0-9 -]{6,8}\\?\d{0,3}\\[A-Z]{1,4}$'),
	car_flag 		  str.car_flag_enum 	NOT NULL,
	load_capacity 	  str.smallint_natural 	NOT NULL,
	city 			  str.address_check 	NOT NULL,
	comment_transport VARCHAR(500)	
);

CREATE TABLE IF NOT EXISTS str.shipment (
	id 						SERIAL 		 	 PRIMARY KEY,
	provider_id 			INT 
		REFERENCES str.provider(id)  ON UPDATE CASCADE ON DELETE SET NULL,
	delivery_from_id 		INT 
		REFERENCES str.office(id) 	 ON UPDATE CASCADE ON DELETE SET NULL,
	delivery_to_id 			INT 		 	 NOT NULL
		REFERENCES str.office(id) 	 ON UPDATE CASCADE ON DELETE CASCADE,
	responsible_person_id 	INT 
		REFERENCES str.employee(id)  ON UPDATE CASCADE ON DELETE SET NULL,
	driver_id 				INT
		REFERENCES str.employee(id)  ON UPDATE CASCADE ON DELETE SET NULL,
	transport_id 			INT 
		REFERENCES str.transport(id) ON UPDATE CASCADE ON DELETE SET NULL,
	date_of_shipment 		DATE 		 	 NOT NULL CHECK (date_of_shipment >= DATE '01-01-2010'),
	shipment_flag 			str.flag_of_work NOT NULL,
	comment_shipment 		VARCHAR(500),
	UNIQUE (delivery_to_id, responsible_person_id, driver_id, transport_id, date_of_shipment),
	CHECK ((provider_id IS NOT NULL AND delivery_from_id IS NULL) 
		OR (provider_id IS NULL AND delivery_from_id IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS str.device_of_shipment (
	shipment_id 	INT 			 	 NOT NULL
		REFERENCES str.shipment(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id 		INT 			 	 NOT NULL
		REFERENCES str.device(id) 	ON UPDATE CASCADE ON DELETE CASCADE,
	device_count 	str.smallint_natural NOT NULL DEFAULT 1,
	PRIMARY KEY (device_id, shipment_id)
);
