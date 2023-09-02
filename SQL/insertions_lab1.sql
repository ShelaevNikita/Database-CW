/* DATABASE online_electronics_store, 
   SCHEMA str */

SET datestyle TO "Postgres, DMY";

-- Insert 10 rows into customer
INSERT INTO str.customer (login, password, first_name, second_name, gender,
	date_of_birth, age, phone, email, registration_date) VALUES
	('admin', '234ef45aabb', 'John', 'Green', 'M', '14-07-1999', 21,
		'+7-(900)-555-3535', 'john.green@gmail.com', '01-01-2020'),
	('kaitlynnZ', 'ba564aaeeff', 'Kaitlynn', 'Zemler', 'F', '25-06-1976', 44,
		'+7-(983)-835-1022', 'kzemler0@aol.com', '13-09-2020'),
	('madelene091219', '69feab6098ffa', 'Madelene', 'McAuley', 'F', '09-12-1984', 36,
		'+7-(135)-538-8031', 'mmcauley2@comcast.net', '12-09-2020'),
	('24demetre16', 'abc259bbaa964', 'Demetre', 'Wastie', 'M', '24-12-2005', 15,
		'+7-(138)-457-4526', 'dwastie3@phoca.cz', '22-03-2020'),
	('wsteedman4', '96eefab56c90a', 'Weber', 'Steedman', 'M', '05-08-1978', 42,
		'+7-(168)-725-3112', 'wsteedman4@de.vu', '04-01-2020'),
	('loree1708', 'ba8c5e42ff97ab', 'Loree', 'Retallick', 'F', '17-08-1980', 40,
		'+7-(851)-366-0580', 'lretallick5@fda.gov', '03-02-2020'),
	('cummineBuddie', '2175bc21ca4f6', 'Buddie', 'Cummine', 'M', '26-01-1968', 53,
		'+7-(157)-998-0112', 'bcummine6@infoseek.co', '09-08-2019'),
	('091976TestinR', '9fc56acfe9036f', 'Rufus', 'Testin', 'M', '11-09-1976', 44, 
		'+7-(106)-667-3332', 'rtestin7@blog.com', '18-03-2019'),
	('porter_fuge2003', '548abc854acee847', 'Porter', 'Fuge', 'M', '02-03-2003', 18,
		'+7-(954)-564-6032', 'pfuge8@edu.spbstu.com', '15-01-2020'),
	('ales_heijnen_2020', 'aabbcc854ff87edde', 'Alessandra', 'Heijnen', 'F', '12-03-2001', 20,
		'+7-(481)-211-4751', 'aheijnen9@oracle.com', '19-03-2020');

-- Insert 10 rows into company
INSERT INTO str.company (company_name, company_website, country, city) VALUES
	('ASUS', 'https://www.asus.com/ru/', 'China', 'Taipei'),
	('Huawei', 'https://huawei.ru/', 'China', 'Shenzhen'),
	('Vivo', 'https://www.vivo.com/ru/', 'China', 'Dongguan'),
	('DEXP', 'https://dexp.club/', 'Russia', 'Vladivostok'),
	('Apple', 'https://www.apple.com/ru/', 'USA', 'Cupertino'),
	('Samsung', 'https://www.samsung.com/ru/', 'Republic of Korea', 'Suwon'),
	('Acer', 'https://www.acer.com/ac/ru/RU/content/home', 'China', 'Taipei'),
	('Hewlett-Packard\HP', 'https://hp-rus.com/', 'USA', 'Palo Alto'),
	('Lenovo', 'https://www.lenovo.com/ru/ru/', 'China', 'Beijing'),
	('Xiaomi Corporation\Xiaomi', 'https://www.mi.com/ru/', 'China', 'Beijing');

-- Insert 10 rows into office
INSERT INTO str.office (store_number, store_type, city, street, 
	house_number, apartment, square) VALUES
	(5,   'store', 'Saint Petersburg', 'Nevsky Avenue', '153', 2, 50.4),
	(45,  'store', 'Saint Petersburg', 'Polytechnic Street', '31', 1, 40.1),
	(87,  'store', 'Saint Petersburg', 'Ligovsky Avenue', '196', 4, 75.8),
	(14,  'store', 'Moscow', 'Tverskoy Boulevard', '19', 3, 65.7),
	(121, 'store', 'Moscow', 'Sadovnicheskaya embankment', '23', 1, 80.7),
	(11,  'store', 'Moscow', 'Avenue Mira', '97', 4, 54.1),
	(9,   'store', 'Saint Petersburg', 'Embankment of the Obvodny Canal', '93A', 3, 106.7),
	(100, 'warehouse', 'Saint Petersburg', 'Engels Avenue', '62', 1, 150.5),
	(200, 'warehouse', 'Saint Petersburg', 'Zanevsky Avenue', '28', 10, 120.1),
	(300, 'warehouse', 'Moscow', '1st Tverskaya-Yamskaya Street', '34', 1, 215.4);

-- Insert 10 rows into employee
INSERT INTO str.employee (personal_number, employee_password, first_name,
	second_name, gender, date_of_birth, age, date_of_employment, contract_number,
	employee_position, office_id, salary, phone, email) VALUES
	(772, '954ffebbcc123', 'Gearard', 'Runcieman', 'M', '04-05-1995', 25, '10-09-2020',
		'5421A', 'driver', NULL, 113065.0, '+7-(507)-821-3089', 'gruncieman0@meetup.com'),
	(754, '654ffcce345a1b', 'Sidoney', 'Marsie', 'F', '18-04-1990', 31, '06-06-2019',
		'651', 'store administrator', 1, 118638, '+7-(263)-418-9098', 'smarsie1@scribd.com'),
	(798, '954ffd10987dbc', 'Vivia', 'Yuryatin', 'F', '21-02-1998', 23, '29-01-2021',
		'845A', 'store administrator', 5, 143557, '+7-(416)-497-7630', 'vyuryatin2@nature.com'),
	(180, 'abcd965cc74a102', 'Nonna', 'Ledekker', 'F', '08-04-1992', 29, '10-06-2020',
		'5421A', 'seller-assistant', 1, 175324, '+7-(407)-162-3843', 'nledekker3@yellowpages.com'),
	(177, '96da712cd55ea', 'Caldwell', 'Jacquot', 'M', '30-10-2000', 20, '24-12-2019',
		'9651B', 'store manager', 2, 126529, '+7-(724)-177-1840', 'cjacquot4@cloudflare.com'),
	(722, '963fea571dbc5', 'Koren', 'Greenhouse', 'F', '09-01-1976', 45, '07-10-2020',
		'9985N', 'seller-assistant', 1, 98100, '+7-(308)-239-7147', 'kgreenhouse5@odnoklassniki.ru'),
	(103, 'abc985db456ac', 'Pippy', 'Tompion', 'F', '16-04-1995', 26,  '08-05-2020',
		'N134A', 'porter', 9, 85423.0, '+7-(498)-561-0181', 'ptompion6@eepurl.com'),
	(977, '352fc48dc10a0c', 'Jocko', 'Cotta', 'M', '14-03-2002', 19, '14-05-2019',
		'125V212A', 'porter', 10, 109198.4, '+7-(168)-692-0941', 'jcotta7@aboutads.info'),
	(300, '954ffcea625dd7eeabc', 'Ralf', 'Wilcocke', 'M', '02-06-1985', 35, '03-05-2019',
		'654D', 'courier', NULL, 146876.1, '+7-(669)-942-4151', 'rwilcocke8@virginia.edu'),
	(934, '652718a548c521b', 'Lorne', 'Pepineaux', 'M', '29-04-1983', 37, '02-09-2020',
		'9651B', 'courier', NULL, 130079, '+7-(596)-175-9245', 'lpepineaux9@etsy.com');

-- Add chiefs for employees
UPDATE str.employee SET chief_id = 5 WHERE (office_id = 2 OR employee_position = 'driver') AND id != 5;
UPDATE str.employee SET chief_id = 2 WHERE office_id = 1 AND id != 2;
UPDATE str.employee SET chief_id = 3 WHERE employee_position = 'courier';

-- Insert 10 rows into processor_CPU
INSERT INTO str.processor_CPU (CPU_manufacturer, CPU_line, CPU_model, frequency, number_of_cores) VALUES
	('Intel', 'Celeron', 'N4020', 1.9, 2),
	('Huawei', 'HiSilicon', 'Kirin 710F', 2.2, 8),
	('Apple', 'Bionic', 'Apple A14', 2.99, 6),
	('Apple', 'Bionic', 'A12Z', 2.49, 8),
	('Qualcomm', 'Snapdragon', '720G', 2.1, 8),
	('MediaTek', 'MediaTek', 'MT8765', 1.3, 4),
	('MediaTek', 'MediaTek', 'MT6739WA', 1.28, 4),
	('Qualcomm', 'Snapdragon', '865 Plus', 2.5, 8),
	('AMD', 'Athlon', 'Gold 3150U', 2.85, 2),
	('Intel', 'Core i7', '1165G7', 3.75, 4);

-- Insert 10 rows into device
INSERT INTO str.device (device_name, company_id, price, rating, warranty, release_year, height,
	width, thickness, weight, colour, material, screen_size, processor_id, battery_capacity) VALUES
	('Huawei P40 Lite E 64 GB', 2, 10100.50, 4.5, 12, 2020, 159.8, 76.1,
		8.13, 176, 'black', 'plastic', '1560x720', 2, 4000),
	('Vivo V20 128 GB', 3, 28500.00, 4.7, 12, 2020, 161.3, 74.2,
		7.38, 171, 'blue', 'glass', '2400x1080', 5, 4000),
	('DEXP AL250 32 GB', 4, 4600.50, 3.5, 6, 2020, 132.5, 68.9,
		8.25, 215, 'grey', 'plastic', '960x480', 7, 3000),
	('Apple iPhone 12 Pro Max 512 GB', 5, 128799.99, 4.8, 12, 2020, 160.8, 78.1,
		7.4, 226, 'blue', 'metal\glass', '2778x1284', 3, 3687),
	('Lenovo Tab M7 TB-7305X 32 GB', 9, 8500.15, 3.7, 12, 2020, 176.33, 102.85,
		8.25, 237, 'silver', 'metal\plastic', '1024x600', 6, 3500),
	('Samsung Galaxy Tab S7 128 GB', 6, 62999.50, 4.9, 12, 2020, 185.0, 285.0,
		5.7, 575, 'black', 'metal', '2800x1752', 8, 10090),
	('Apple iPad Pro 2020 128 GB', 5, 69999.99, 4.7, 12, 2020, 247.6, 178.5,
		5.9, 471, 'gold', 'metal', '2388x1668', 4, 8900),
	('ASUS Laptop E210MA-GJ003T', 1, 24999.50, 4.5, 12, 2020, 279.0, 191.0,
		16.9, 1050, 'white', 'plastic', '1366x768', 1, 38),
	('Acer Swift 5 SF514-55TA-725A', 7, 102099.0, 4.9, 12, 2020, 329.0, 228.0,
		14.95, 970, 'green', 'metal', '1920x1080', 10, 56),
	('HP Laptop 15-gw0040ur', 8, 38999.0, 4.9, 12, 2020, 358.5, 242.0,
		19.9, 1740, 'grey', 'plastic', '1920x1080', 9, 41);

-- Insert 10 rows into image
INSERT INTO str.image (device_id, URI_image, image_type, comment_for_image) VALUES
	(10, 'file://server/products/hp_laptop/images/top.png', 'PNG', 'Top view of the laptop'),
	(8, 'file://server/products/asus_laptop/images/front.png', 'PNG', 'Front view of the laptop'),
	(1, 'file://server/products/huawei_phone_p40/images/front.jpeg', 'JPEG', 'Front view'),
	(6, 'file://server/products/samsung_tablet_galaxy/images/box.png', 'PNG', 'Tablet box'),
	(2, 'file://server/products/vivo_phone_v20/images/front.jpeg', 'JPEG', 'Front view of the phone'),
	(1, 'file://server/products/huawei_phone_p40/images/back.bmp', 'BMP', 'Back view'),
	(1, 'file://server/products/huawei_phone_p40/images/box.gif', 'GIF', NULL),
	(5, 'file://server/products/lenovo_tablet_m7/images/front.png', 'PNG', 'Front view of the laptop'),
	(1, 'file://server/products/huawei_phone_p40/images/ruler.png', 'PNG', 'Phone along with the ruler'),
	(9, 'file://server/products/acer_laptop_swift5/images/top.bmp', 'BMP', NULL);

-- Insert 10 rows into feedback
INSERT INTO str.feedback (device_id, customer_id, date_of_feedback, 
	rating_of_device, flag_of_purchase, comment_feedback) VALUES
	(1, 8, '19-04-2020', 4.7, true, NULL),
	(2, 8, '27-02-2020', 4.5, true, 'Cool! :)'),
	(1, 7, '14-08-2019', 3.9, false, 'Not enough internal memory'),
	(10, 4, '20-06-2020', 4.2, true, NULL),
	(9, 1, '04-01-2021', 3.7, false, 'High price!'),
	(5, 8, '13-06-2019', 4.5, true, NULL),
	(8, 8, '13-02-2021', 4.7, true, '2 cores too small for normal operation'),
	(4, 3, '01-04-2020', 4.6, true, NULL),
	(10, 10, '03-10-2020', 4.8, true, NULL),
	(7, 5, '01-05-2020', 3.5, true, 'My son liked it very much. It is a good device.');

-- Insert 10 rows into basket
INSERT INTO str.basket (device_id, customer_id, device_volume, date_device_added) VALUES
	(1, 2, 1, '20-05-2019'),  (2, 8, 3, '22-01-2021'), 
	(8, 10, 2, '23-01-2020'), (9, 4, 1, '23-11-2019'), 
	(7, 7, 5, '18-05-2020'),  (5, 7, 1, '11-10-2019'),
	(1, 1, 1, '03-04-2020'),  (1, 9, 2, '10-01-2020'),
	(8, 7, 2, '18-10-2020'),  (5, 6, 1, '26-06-2019');

-- Insert 10 rows into favorite_device
INSERT INTO str.favorite_device (device_id, customer_id, like_flag, date_last_view) VALUES
	(5, 7, false, '15-09-2020'), (7, 1, true, '28-01-2021'), 
	(7, 2, false, '28-01-2021'), (9, 4, false, '14-07-2020'), 
	(1, 8, false, '20-09-2019'), (4, 9, true, '15-11-2019'),
	(4, 2, false, '13-02-2021'), (5, 9, false, '11-02-2021'),
	(8, 7, false, '28-11-2020'), (5, 8, true, '28-02-2021');

-- Insert 10 rows into purchase_order
INSERT INTO str.purchase_order (customer_id, order_number, courier_id,
	date_of_purchase, date_of_delivery, office_id, order_flag, comment_for_order) VALUES
	(2, 1, 9, '01-01-2021', '03-02-2021', 1, 'Completed', 'Payment by card'),
	(5, 2, NULL, '19-04-2021', '20-04-2021', 1, 'Planned', NULL),
	(6, 45, NULL, '23-12-2020', '01-01-2021', 2, 'Canceled', 'The client refused the device'),
	(5, 984, 10, '13-01-2021', '15-03-2021', 5, 'Planned', NULL),
	(10, 7854, NULL, '18-12-2020', '21-01-2021', 5, 'Completed', 'Cash'),
	(9, 54, 9, '11-12-2020', '31-12-2020', 6, 'Completed', NULL),
	(1, 8, NULL, '23-12-2020', '30-03-2021', 3, 'Planned', NULL),
	(3, 10, NULL, '09-01-2021', '20-01-2021', 4, 'Completed', 'Card'),
	(5, 87, 10, '15-03-2021', '20-03-2021', 7, 'In progress', NULL),
	(8, 90, NULL, '09-01-2021', '10-02-2021', 3, 'Completed', 'Payment by cash');

-- Insert 10 rows into purchased_device
INSERT INTO str.purchased_device (device_id, purchase_order_id, device_price, device_count) VALUES
	(8, 2, 23999.99, 3), (10, 1, 41000.85, 2), 
	(7, 2, 65000.2, 1),  (1, 5, 9500.1, 1), 
	(3, 1, 5500.0, 3),   (8, 9, 23950.0, 2),
	(9, 9, 105002.8, 2), (4, 6, 140520.99, 1),
	(5, 6, 8999.99, 1),  (7, 8, 64500.50, 1);

-- Insert 10 rows into budget
INSERT INTO str.budget (office_id, date_added, billing_month, billing_year, 
	monthly_income, monthly_expense, monthly_profit, comment_for_budget) VALUES
	(1, '05-12-2020', 11, 2020, 748512.2, 215478.9, 533033.3, 'Many orders in a month'),
	(10, '09-05-2019', 3, 2019, 195379.65, 436826.55, -241446.9, NULL),
	(NULL, '06-12-2019', 11, 2019, 0, 206383.0, -206383.0, 'Payment of interest on the loan'),
	(1, '13-09-2020', 5, 2020, 602416.57, 125506.25, 476910.32, NULL),
	(5, '28-11-2020', 7, 2020, 869240.85, 623346.55, 245894.3, 'Large number of employees'),
	(1, '09-01-2020', 11, 2019, 294613.97, 267847.57, 26766.4, NULL),
	(7, '07-09-2020', 7, 2020, 654015.26, 917201.94, -263186.68, 'Repair'),
	(4, '24-05-2020', 4, 2020, 702295.23, 893942.06, -191646.83, NULL),
	(6, '01-02-2021', 1, 2021, 361798.19, 539706.55, -177908.36, 'The office has recently opened'),
	(6, '07-05-2020', 4, 2020, 410141.87, 276101.87, 134040.0, NULL);

-- Insert 10 rows into warehouse_of_device
INSERT INTO str.warehouse_of_device (device_id, warehouse_id, quantity) VALUES
	(5, 8, 50),   (7, 10, 12), (4, 9, 15),  (1, 8, 20), (1, 9, 16),
	(10, 10, 35), (2, 8, 27),  (1, 10, 15), (5, 9, 56), (6, 8, 60);

-- Insert 10 rows into provider
INSERT INTO str.provider (company_name, city, phone, email) VALUES
	('Gruzosphere', 'Saint Petersburg', '8-(812)-248-8824', 'gruzosfera@yandex.ru'), 
	('Gruzovichkoff', 'Saint Petersburg', '+7-(812)-603-9908', '911@gruzovichkof.ru'),
	('Agora Freight', 'Moscow', '+7-(495)-136-5633', 'sales@agorafreight.com'),
	('Gazelkin', 'Saint Petersburg', '8-(812)-200-3287', 'zakaz.corp@gazelkin.ru'),
	('DA-TRANS', 'Moscow', '8-(495)-999-0630', 'zapros@datrans.ru'),
	('TEC Avtoritet', 'Yaroslavl', '+7-(495)-792-4050', 'tek-avtoritet@yandex.ru'),
	('TrancTechnoGroup\TTG', 'Moscow', '+7-(495)-481-2262', 'zapros@ttggroup.ru'),
	('Delovyye Linii', 'Moscow', '8-(800)-100-8000', 'pismo@dellin.ru'),
	('PEK', 'Saint Petersburg', '+7-(495)-660-1111', 'pecom@pecom.ru'),
	('SDEK', 'Novosibirsk', '+7-(495)-009-0405', 'msk@cdek.ru');

-- Insert 10 rows into transport
INSERT INTO str.transport (car_name, car_number, car_flag,
	load_capacity, city, comment_transport) VALUES
	('GAZel NEXT A31R22-80', 'K952ON\35\RUS', 'Available', 3500, 'Saint Petersburg', NULL), 
	('VALDAI NEXT', 'M356DD\78\RUS', 'Available', 8700, 'Saint Petersburg', NULL),
	('GAZel BIZNES 2705-757', 'N877KK\198\RUS', 'Busy', 3500, 'Saint Petersburg', 'Performs delivery'),
	('GAZel NEXT A31R22-80', 'F712RL\98\RUS', 'Under repair', 3500,
		'Saint Petersburg', 'Passes Technical Inspection'),
	('KAMAZ 43118-50', 'R125TT\98\RUS', 'Moving out', 21600, 'Tver', 'Going to St. Petersburg'),
	('GAZel NEXT A31R22-80', 'H994KD\77\RUS', 'Available', 3500, 'Moscow', NULL),
	('KAMAZ 5350-66 D5', 'G856FT\199\RUS', 'Busy', 17000, 'Moscow', 'Performs delivery'),
	('KAMAZ 43118-50', 'D854DR\98\RUS', 'Available', 21600, 'Moscow', NULL),
	('GAZel BIZNES 2705-757', 'L852LD\98\RUS', 'Busy', 3500, 'Moscow', 'Performs delivery'),
	('KAMAZ 65117-48 A5', 'R548FH\76\RUS', 'Busy', 24000, 'Moscow', 'Knocking in the engine');

-- Insert 10 rows into shipment
INSERT INTO str.shipment (provider_id, delivery_from_id, 
	delivery_to_id, responsible_person_id, driver_id, transport_id, 
	date_of_shipment, shipment_flag, comment_shipment) VALUES
	(NULL, 8, 1, 2, 1, 1, '12-01-2021', 'Completed', NULL), 
	(2, NULL, 8, 10, NULL, NULL, '03-04-2021', 'Planned', NULL),
	(NULL, 9, 2, 5, 1, 10, '12-12-2022', 'Completed', NULL),
	(NULL, 9, 3, 9, 10, 5, '10-03-2021', 'In progress', NULL),
	(3, NULL, 10, 8, 1, 2, '02-02-2021', 'Completed', NULL),
	(NULL, 8, 3, 5, 10, 5, '15-01-2021', 'Postponed', 'The car broke down'),
	(5, NULL, 9, 9, NULL, NULL, '14-02-2021', 'Completed', NULL),
	(7, NULL, 8, 9, 1, NULL, '19-02-2021', 'Canceled', 'The delivery price is too high'),
	(NULL, 3, 1, 2, 2, 9, '22-12-2020', 'Completed', NULL),
	(NULL, 9, 1, 4, 1, 9, '15-03-2021', 'Planned', NULL);

-- Insert 10 rows into device_of_shipment
INSERT INTO str.device_of_shipment (shipment_id, device_id, device_count) VALUES
	(1, 5, 30), (5, 8, 40), (5, 9, 50), (7, 1, 45), (9, 7, 15),
	(9, 8, 35), (2, 8, 55), (9, 5, 49), (1, 7, 50), (4, 6, 28);
	
-- Insert 10 rows into device_category
INSERT INTO str.device_category (category_name) VALUES
	('phones'), ('tablets'), ('watches'), ('e-books'), ('SLR cameras'), ('laptops'),
	('servers'), ('gadgets'), ('computers'), ('gadgets and computers');
	
UPDATE str.device_category SET top_category_id = 8 WHERE (id >= 1 AND id <= 4);
UPDATE str.device_category SET top_category_id = 9 WHERE (id = 6 OR id = 7);
UPDATE str.device_category SET top_category_id = 10 WHERE (id = 8 OR id = 9);

-- Insert 10 rows into device_criteria
INSERT INTO str.device_criteria (crit_name, param_int, param_varchar, param_dec, param_bool) VALUES
	('Network', 4, NULL, NULL, NULL), ('Bluetooth', NULL, NULL, 5.0, NULL),
	('Number of front cameras', 3, NULL, NULL, NULL), ('OS info', NULL, 'Windows 10 Home', NULL, NULL),
	('OS info', NULL, 'iOS 14', NULL, NULL), ('Wi-Fi', 5, NULL, NULL, NULL),
	('Maximum memory capacity', 512, NULL, NULL, NULL), ('Screen refresh rate', 60, NULL, NULL, NULL),
	('Fingerprint scanner', NULL, NULL, NULL, false), ('Type of RAM', NULL, 'DDR4', NULL, NULL);

-- Insert 10 rows into category_criteria
INSERT INTO str.category_criteria (category_id, criteria_id, device_id) VALUES
	(1, 1, 1), (10, 2, 1), (10, 3, 1), (10, 4, 8), (10, 5, 4),
	(10, 6, 8), (8, 7, 1), (6, 8, 8), (6, 9, 8), (9, 10, 8);
		
-- Must be 10 rows
SELECT id, login, first_name, second_name FROM str.customer;

-- Must be 10 rows
SELECT * FROM str.company;

-- Must be 10 rows
SELECT id, store_number, store_type, city, street FROM str.office;

-- Must be 10 rows
SELECT id, personal_number, first_name, second_name, chief_id,
	office_id, salary FROM str.employee ORDER BY id;

-- Must be 10 rows
SELECT * FROM str.processor_CPU;

-- Must be 10 rows
SELECT id, device_name, company_id, processor_id, price FROM str.device;

-- Must be 10 rows
SELECT id, device_id, image_type FROM str.image;

-- Must be 10 rows
SELECT feedback_number, device_id, customer_id, 
	date_of_feedback, rating_of_device FROM str.feedback;

-- Must be 10 rows
SELECT * FROM str.basket;

-- Must be 10 rows
SELECT * FROM str.favorite_device;

-- Must be 10 rows
SELECT id, customer_id, office_id, date_of_purchase, 
	date_of_delivery, order_flag FROM str.purchase_order;
	
-- Must be 10 rows
SELECT * FROM str.purchased_device;

-- Must be 10 rows
SELECT id, office_id, date_added, billing_month, 
	billing_year, monthly_profit FROM str.budget;

-- Must be 10 rows
SELECT * FROM str.warehouse_of_device;

-- Must be 10 rows
SELECT * FROM str.provider;

-- Must be 10 rows
SELECT car_name, car_number, car_flag, city FROM str.transport;

-- Must be 10 rows
SELECT delivery_from_id, delivery_to_id, responsible_person_id,  
	date_of_shipment, shipment_flag FROM str.shipment;

-- Must be 10 rows
SELECT * FROM str.device_of_shipment;

-- Must be 10 rows
SELECT category_name, top_category_id, criteria FROM str.device_category ORDER BY id;

-- Must be 10 rows
SELECT * FROM str.device_criteria;

-- Must be 10 rows
SELECT * FROM str.category_criteria;