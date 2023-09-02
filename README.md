# Online electronics store: Интернет-магазин электронных устройств (смартфоны, планшеты, ноутбуки и т. д.)

- БД состоит из **21-и** таблицы и хранит информацию, которая необходима для работы интернет-магазина
- Используется схема (SCHEME) **_str_** (store)

# Описание таблиц

### customer

- Хранит профили/личную информацию покупателей:

id | SERIAL | PK
--- | --- | ---
login, password | VARCHAR(50) | login (UNIQUE) и пароль для входа в личный кабинет
first_name, second_name | VARCHAR(50) | Имя и фамилия пользователя
gender | CHAR ('F' or 'M') | -\
date_of_birth | DATE | --- Информация о пользователе
age | SMALLINT | -/ 
phone | VARCHAR(20) | Телефон пользователя
email | VARCHAR(100) | Почта/email пользователя
registration_date | DATE | Дата регистрации пользователя в системе

### company

- Информация о компаниях, устройства которых продаются в магазине:

id | SERIAL | PK
--- | --- | ---
company_name | VARCHAR(25) | Название компании (UNIQUE)
company_website | VARCHAR(100) | Официальный сайт компании (в России) (UNIQUE)
country, city | VARCHAR(50) | Адрес главного офиса компании 

### office

- Информация о помещениях (магазины и склады), принадлежащих интернет-магазину:

id | SERIAL | PK
--- | --- | ---
store_number | INT | Номер магазина/склада (UNIQUE)
store_type | VARCHAR(10) | Тип помещения (магазин или склад)
city, street | VARCHAR(50) | -\ 
house_number | VARCHAR(15) | --- Адрес магазина/склада 
apartment | SMALLINT | -/
square | DEC(11, 2) | Площадь помещения

### employee

- Информация о работниках интернет-магазина:

id | SERIAL | PK
--- | --- | ---
personal_number | INT | Персональный номер работника (UNIQUE)
employee_password | VARCHAR(50) | Пароль для входа в личный кабинет работника
first_name, second_name | VARCHAR(50) | Имя и фамилия работника
gender | CHAR ('F' or 'M') | -\
date_of_birth | DATE | --- Информация о работнике
age | SMALLINT | -/
date_of_employment | DATE | Дата принятия на работу
contract_number | VARCHAR(10) | Номер трудового договора
employee_position | VARCHAR(50) | Должность работника
chief_id | INT | ID начальника (FK) (UPD: CASCADE, DEL: SET NULL)
office_id | INT | ID места работы (магазина или склада) (FK) (UPD: CASCADE, DEL: SET NULL)
salary | DEC(11, 2) | Зарплата работника (в рублях)
phone | VARCHAR(20) | Телефон работника 
email | VARCHAR(100) | Почта/email работника

### processor_CPU

- Информация о процессорах (CPU), которые установлены в продаваемых устройствах:

id | SERIAL | PK
--- | --- | ---
CPU_manufacturer | ENUM | Производитель процессора
CPU_line | VARCHAR(15) | Линейка (серия) процессоров
CPU_model | VARCHAR(25) | Модель процессора
frequency | DEC(4, 2) | Средняя частота работы процессора (в ГГц)
number_of_cores | SMALLINT | Количество ядер в процессоре

### device

- Информация об различных электронных устройствах, которые продаются в магазине:

id | SERIAL | PK
--- | --- | ---
device_name | VARCHAR(100) | Название устройства (UNIQUE)
company_id | INT | ID компании (FK) (UPD: CASCADE, DEL: SET NULL)
price | DEC(11, 2) | Цена устройства (в рублях)
rating | DEC(2, 1) | Рейтинг устройства (определяется по отзывам пользователей)
warranty | SMALLINT | Срок гарантийного обслуживания (в месяцах) 
release_year | SMALLINT | Год выхода устройства
height, width, thickness | DEC(11, 2) | Размеры устройства (в мм)
weight | INT | Вес устройства (в граммах)
colour, material | VARCHAR(25) | Цвет и материал корпуса
screen_size | VARCHAR(12) | Размер экрана
processor_id | INT | ID используемого процессора (FK) (UPD: CASCADE, DEL: SET NULL)
battery_capacity | INT | Ёмкость аккумулятора (в мАч)

### image

- Хранит список фотографий/изображений для каждого продаваемого устройства:

id | SERIAL | PK
--- | --- | ---
device_id | INT | ID устройства (FK) (UPD: CASCADE, DEL: CASCADE)
URI_image | VARCHAR(250) | URI-путь, по которому хранится эта фотография (UNIQUE)
image_type | ENUM | Формат изображения (PNG, JPEG, BMP и др.)
company_for_image | VARCHAR(500) | Описание фотографии (при необходимости)

### feedback

- Хранит список оставленных пользователями отзывов об устройствах:

feedback_number | SERIAL | Номер отзыва (PK)
--- | --- | ---
customer_id | INT | ID пользователя (FK) (UPD: CASCADE, DEL: SET NULL)
device_id | INT | ID устройства (FK) (UPD: CASCADE, DEL: CASCADE)
date_of_feedback | DATE | Дата написания отзыва
rating_of_device | DEC(2, 1) | Рейтинг устройства, который поставил пользователь
flag_of_purchase | BOOLEAN | Оставивший отзыв пользователь покупал это устройство или нет?
comment_feedback | VARCHAR(1000) | Комментарий/отзыв пользователя

### basket

- Хранит список устройств, которые пользователи выбрали для покупки, но ещё не купили (**_Корзина_**):

basket_number | SERIAL | Номер заказа/записи в **_Корзине_** (PK)
--- | --- | ---
customer_id | INT | ID пользователя (FK) (UPD: CASCADE, DEL: CASCADE)
device_id | INT | ID выбранного устройства (FK) (UPD: CASCADE, DEL: CASCADE)
device_volume | SMALLINT | Количество устройств в записи
date_device_added | DATE | Дата добавления записи в **_Корзину_**

### favorite_device

- Хранит список устройств, которые пользователи смотрели / просматривали:

customer_id | INT | ID пользователя (PK, FK) (UPD: CASCADE, DEL: CASCADE)
--- | --- | ---
device_id | INT | ID выбранного устройства (PK, FK) (UPD: CASCADE, DEL: CASCADE)
like_flag | BOOLEAN | Пользователь просто смотрел это устройство (Нет) или отметил его как **Нравится** (Да)?
date_last_view | DATE | Дата последнего просмотра устройства пользователем

### purchase_order

- Список заказов, совершённых пользователями:

id | SERIAL | PK
--- | --- | ---
customer_id | INT | ID пользователя (FK) (UPD: CASCADE, DEL: CASCADE)
order_number | INT | Номер покупки/заказа (UNIQUE)
courier_id | INT | ID работника-курьера (если доставка курьером) (FK) (UPD: CASCADE, DEL: SET NULL)
office_id | INT | ID магазина (FK) (UPD: CASCADE, DEL: SET DEFAULT)
date_of_purchase | DATE | Дата покупки
date_of_delivery | DATE | Дата выдачи заказа покупателю
order_flag | ENUM | Состояние заказа ('Выполнен', 'Запланирован' и т.д.)
comment_for_order | VARCHAR(500) | Комментарий о состоянии заказа (при необходимости)

### purchased_device

- Хранит список устройств, заказанных/купленных пользователями:

purchase_order_id | INT | ID заказа (PK, FK) (UPD: CASCADE, DEL: CASCADE)
--- | --- | ---
device_id | INT | ID выбранного устройства (PK, FK) (UPD: CASCADE, DEL: CASCADE)
device_price | DEC(11, 2) | Цена устройства в момент покупки
device_count | SMALLINT | Количество данных устройств в заказе

### budget

- Хранит информацию о доходах и расходах всех магазинов/складов:

id | SERIAL | PK
--- | --- | ---
office_id | INT | ID магазина/склада (FR) (UPD: CASCADE, DEL: SET NULL)
date_added | DATE | Дата добавления записи
billing_month, billing_year | SMALLINT | Расчётный месяц и год
monthly_income, monthly_expense, monthly_profit | DEC(14, 2) | Доходы, расходы и прибыль магазина/склада за расчётный месяц (в рублях)
comment_for_budget | VARCHAR(100) | Комментарий об источниках доходов/расходов (при необходимости)

### warehouse_of_device

- Информация об устройствах, которые находятся в данный момент в магазинах / на складах:

warehouse_id | INT | ID склада (PK, FK) (UPD: CASCADE, DEL: CASCADE)
--- | --- | ---
device_id | INT | ID устройства (PK, FK) (UPD: CASCADE, DEL: CASCADE)
quantity | SMALLINT | Количество выбранных устройств в магазине / на складе

### provider

- Информация о внешних поставщиках устройств (например, компания по перевозке грузов):

id | SERIAL | PK
--- | --- | ---
company_name | VARCHAR(30) | Название компании-поставщика (UNIQUE)
city | VARCHAR(50) | Город, в котором находится главный офис компании
phone | VARCHAR(20) | Телефон компании
email | VARCHAR(100) | Почта/email компании для заказа поставок

### transport

- Хранит список грузовых машин, принадлежащих интернет-магазину:

id | SERIAL | PK
--- | --- | ---
car_name | VARCHAR(50) | Полное название автомобиля
car_number | VARCHAR(16) | Госномер машины (UNIQUE)
car_flag | ENUM | Состояние машины в текущий момент времени ('Свободна', 'В ремонте' и др.)
load_capacity | SMALLINT | Грузоподъёмность грузовой машины (в кг)
city | VARCHAR(50) | Город, в котором машина сейчас находится
comment_transport | VARCHAR(500) | Комментарии по состоянию машины (при необходимости)

### shipment

- Список поставок различных устройств "внутри" интернет-магазина или от поставщика:

id | SERIAL | PK
--- | --- | ---
provider_id | INT | ID поставщика устройств (если поставка от внешнего поставщика) (FK) (UPD: CASCADE, DEL: SET NULL)
delivery_from_id | INT | ID магазина / склада, с которого перевозят устройства (если поставка "внутри" интернет-магазина) (FK) (UPD: CASCADE, DEL: SET NULL)
delivery_to_id | INT | ID магазина / склада, которому доставляют устройства (FK) (UPD: CASCADE, DEL: CASCADE)
responsible_person_id | INT | ID работника, ответственного за поставку устройств (FK) (UPD: CASCADE, DEL: SET NULL)
driver_id | INT | ID работника-водителя (FK) (UPD: CASCADE, DEL: SET NULL)
transport_id | INT | ID используемой грузовой машины (FK) (UPD: CASCADE, DEL: SET NULL)
date_of_shipment | DATE | Дата поставки устройств в магазин / на склад
shipment_flag | ENUM | Состояние поставки ('Выполнена', 'Планируется', 'Отменена' и т.д.)
comment_shipment | VARCHAR(500) | Комментарий по состоянию поставки

### device_of_shipment

- Хранит список устройств, успешно доставленных или планируемых к доставке в магазин / на склад:

shipment_id | INT | ID поставки (PK, FK) (UPD: CASCADE, DEL: CASCADE)
--- | --- | ---
device_id | INT | ID устройства (PK, FK) (UPD: CASCADE, DEL: CASCADE)
device_count | SMALLINT | Количество выбранных устройств в поставке

### device_category

- Таблица добавляется в скрипте **_alter_lab1.sql_**
- Список категорий (подкатегорий) устройств:

id | SERIAL | PK
--- | --- | ---
category_name | VARCHAR(50) | Название категории (UNIQUE)
top_category | INT | ID более высокой категории по иерархии категорий (FK) (UPD: CASCADE, DEL: SET NULL)

### device_criteria

- Таблица добавляется в скрипте **_alter_lab1.sql_**
- Список названий характеристик и их значения:

id | SERIAL | PK
--- | --- | ---
crit_name | VARCHAR(50) | Название характеристики
param_int, param_varchar, param_dec, param_bool | ... | Значение характеристики (не обязательно)

### category_criteria

- Таблица добавляется в скрипте **_alter_lab1.sql_**
- Связь между категориями, характеристиками и устройствами

id | SERIAL | PK
--- | --- | ---
category_id | INT | ID категории (FK) (UPD: CASCADE, DEL: CASCADE)
criteria_id | INT | ID характеристики (FK) (UPD: CASCADE, DEL: CASCADE)
device_id | INT | ID устройства (FK) (UPD: CASCADE, DEL: SET NULL)

# Дополнительная информация

- Дата последнего изменения БД: 01.06.2021
- Выполнил студент:
> Шелаев Н., 3530901/80201,   email: shelaev.nr@edu.spbstu.ru