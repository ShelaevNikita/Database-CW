/* DATABASE online_electronics_store, 
   SCHEMA str */

CREATE TABLE IF NOT EXISTS str.device_category (
	id 				 SERIAL 				PRIMARY KEY,
	category_name	 VARCHAR(50)			NOT NULL UNIQUE,
	top_category_id	 INT
);

ALTER TABLE str.device_category ADD FOREIGN KEY (top_category_id)
		REFERENCES str.device_category(id) ON UPDATE CASCADE ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS str.device_criteria (
	id 				SERIAL 				PRIMARY KEY,
	crit_name		VARCHAR(50)			NOT NULL,
	param_int 		str.int_natural,
	param_varchar	VARCHAR(50),
	param_dec		DEC(5, 2),
	param_bool		BOOLEAN,
	CHECK (((param_varchar IS NULL) AND (param_dec     IS NULL) AND (param_bool IS NULL))
		OR ((param_int 	   IS NULL) AND (param_dec     IS NULL) AND (param_bool IS NULL))
		OR ((param_int 	   IS NULL) AND (param_varchar IS NULL) AND (param_dec  IS NULL))
		OR ((param_int 	   IS NULL) AND (param_varchar IS NULL) AND (param_bool IS NULL)))
);

CREATE TABLE IF NOT EXISTS str.category_criteria (
	id 				SERIAL 		PRIMARY KEY,
	category_id 	INT			NOT NULL
		REFERENCES str.device_category(id) ON UPDATE CASCADE ON DELETE CASCADE,
	criteria_id 	INT			NOT NULL
		REFERENCES str.device_criteria(id) ON UPDATE CASCADE ON DELETE CASCADE,
	device_id		INT
		REFERENCES str.device(id) ON UPDATE CASCADE ON DELETE SET NULL,
	UNIQUE (category_id, criteria_id, device_id)
);

-- Alter table device
ALTER TABLE IF EXISTS str.device
	DROP COLUMN IF EXISTS device_type,
	DROP COLUMN IF EXISTS camera,
	DROP COLUMN IF EXISTS OS_info,
	DROP COLUMN IF EXISTS RAM_capacity,
	DROP COLUMN IF EXISTS internal_memory_capacity;

DROP TYPE IF EXISTS str.device_type_enum CASCADE;
