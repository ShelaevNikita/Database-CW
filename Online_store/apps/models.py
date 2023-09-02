import datetime as dt

from django.db import models
from django.contrib.postgres.fields import ArrayField
from django.urls import reverse
from django.utils import timezone

class Customer(models.Model):
    id = models.AutoField(primary_key = True)
    login = models.CharField(unique = True, max_length = 50)
    password = models.CharField(max_length = 50)
    first_name = models.CharField(max_length = 50)
    second_name = models.CharField(max_length = 50)

    GENDER = [('F', 'Female'), ('M', 'Male')]

    gender = models.CharField(max_length = 1, choices = GENDER)
    date_of_birth = models.DateField()
    age = models.PositiveSmallIntegerField()
    phone = models.CharField(max_length = 20)
    email = models.EmailField(max_length = 100)
    registration_date = models.DateField() # default = timezone.now().date()

    class Meta:
        db_table = 'customer'
        ordering = ['-registration_date']
        verbose_name = 'Покупатель'
        verbose_name_plural = 'Покупатели'

    def __str__(self):
        return (f'{self.login}')

class Company(models.Model):
    id = models.AutoField(primary_key = True)
    company_name = models.CharField(unique = True, max_length = 25)
    company_website = models.URLField(unique = True, max_length = 100)
    country = models.CharField(max_length = 50)
    city = models.CharField(max_length = 50, blank = True, null = True)

    class Meta:
        db_table = 'company'
        verbose_name = 'Компания'
        verbose_name_plural = 'Компании'

    def __str__(self):
        return self.company_name

class Office(models.Model):
    id = models.AutoField(primary_key = True)
    store_number = models.PositiveIntegerField(unique = True)

    STORE_TYPE = [('warehouse', 'Warehouse'), ('store', 'Store')]

    store_type = models.CharField(max_length = 10, choices = STORE_TYPE)
    city = models.CharField(max_length = 50)
    street = models.CharField(max_length = 50)
    house_number = models.CharField(max_length = 15)
    apartment = models.PositiveSmallIntegerField(default = 1)
    square = models.DecimalField(max_digits = 11, decimal_places = 2)

    class Meta:
        db_table = 'office'
        ordering = ['store_number']
        verbose_name = 'Магазин'
        verbose_name_plural = 'Магазины'       

    def __str__(self):
        return str(self.store_number)

class Employee(models.Model):
    id = models.AutoField(primary_key = True)
    personal_number = models.PositiveIntegerField(unique = True)
    employee_password = models.CharField(max_length = 50)
    first_name = models.CharField(max_length = 50)
    second_name = models.CharField(max_length = 50)
    
    GENDER = [('F', 'Female'), ('M', 'Male')]

    gender = models.CharField(max_length = 1, choices = GENDER)
    date_of_birth = models.DateField()
    age = models.PositiveSmallIntegerField()
    date_of_employment = models.DateField() # default = timezone.now().date()
    contract_number = models.CharField(max_length = 10)
    employee_position = models.CharField(max_length = 50)
    chief = models.ForeignKey('self', on_delete = models.SET_NULL, blank = True, null = True)
    office = models.ForeignKey(Office, on_delete = models.SET_NULL, blank = True, null = True)
    salary = models.DecimalField(max_digits = 11, decimal_places = 2)
    phone = models.CharField(max_length = 20)
    email = models.EmailField(max_length = 100)

    class Meta:
        db_table = 'employee'
        unique_together = (('date_of_employment', 'contract_number'))
        verbose_name = 'Работник'
        verbose_name_plural = 'Работники'

    def __str__(self):
        return (f'{self.first_name} | {self.second_name}')

class ProcessorCPU(models.Model):
    id = models.AutoField(primary_key = True)
    cpu_manufacturer = models.CharField(max_length = 30)
    cpu_line = models.CharField(max_length = 15)
    cpu_model = models.CharField(max_length = 25)
    frequency = models.DecimalField(max_digits = 4, decimal_places = 2)
    number_of_cores = models.PositiveSmallIntegerField()

    class Meta:
        db_table = 'processor_cpu'
        unique_together = (('cpu_manufacturer', 'cpu_line', 'cpu_model'))
        verbose_name = 'Процессор'
        verbose_name_plural = 'Процессоры'

    def __str__(self):
        return (f'{self.cpu_manufacturer} {self.cpu_line} {self.cpu_model}')

class Device(models.Model):
    id = models.AutoField(primary_key = True)
    device_name = models.CharField(unique = True, max_length = 100)
    company = models.ForeignKey(Company, on_delete = models.SET_NULL, blank = True, null = True)
    price = models.DecimalField(max_digits = 11, decimal_places = 2)
    rating = models.DecimalField(max_digits = 2, decimal_places = 1, default = 2.5)
    warranty = models.PositiveSmallIntegerField()
    release_year = models.PositiveSmallIntegerField()
    height = models.DecimalField(max_digits = 11, decimal_places = 2)
    width = models.DecimalField(max_digits = 11, decimal_places = 2)
    thickness = models.DecimalField(max_digits = 11, decimal_places = 2)
    weight = models.PositiveIntegerField()
    colour = models.CharField(max_length = 25)
    material = models.CharField(max_length = 25)
    screen_size = models.CharField(max_length = 12, blank = True, null = True)
    processor = models.ForeignKey(ProcessorCPU, on_delete = models.SET_NULL, blank = True, null = True)
    battery_capacity = models.PositiveIntegerField(null = True)

    class Meta:
        db_table = 'device'
        ordering = ['device_name']
        verbose_name = 'Устройство'
        verbose_name_plural = 'Устройства'  

    def __str__(self):
        return self.device_name

class Image(models.Model):
    id = models.AutoField(primary_key = True)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    uri_image = models.CharField(max_length = 250)

    IMAGE_TYPE = [('PNG', '.png'), ('GIF', '.gif'), ('JPEG', '.jpeg'), ('JPG', '.jpg'), ('BMP', '.bmp'), ('TIFF', '.tiff')]

    image_type = models.CharField(max_length = 4, choices = IMAGE_TYPE)
    comment_for_image = models.CharField(max_length = 500, blank = True, null = True)

    class Meta:
        db_table = 'image'
        ordering = ['uri_image']
        verbose_name = 'Картинка'
        verbose_name_plural = 'Картинки'        

    def __str__(self):
        return self.uri_image

class Feedback(models.Model):
    feedback_number = models.AutoField(primary_key = True)
    customer = models.ForeignKey(Customer, on_delete = models.SET_NULL, blank = True, null = True)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    date_of_feedback = models.DateField() # default = timezone.now().date()
    rating_of_device = models.DecimalField(max_digits = 2, decimal_places = 1, default = 2.5)
    flag_of_purchase = models.BooleanField(default = True)
    comment_feedback = models.CharField(max_length = 1000, blank = True, null = True)

    class Meta:
        db_table = 'feedback'
        unique_together = (('customer', 'device'))
        ordering = ['-date_of_feedback']
        verbose_name = 'Отзыв'
        verbose_name_plural = 'Отзывы'       

    def __str__(self):
        return (f'{self.feedback_number} - {self.customer} -> {self.device}')

class Basket(models.Model):
    basket_number = models.AutoField(primary_key = True)
    customer = models.ForeignKey(Customer, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    device_volume = models.PositiveSmallIntegerField(default = 1)
    date_device_added = models.DateField() # default = timezone.now().date()

    class Meta:
        db_table = 'basket'
        unique_together = (('customer', 'device', 'date_device_added'))
        ordering = ['-date_device_added']
        verbose_name = 'Корзина'
        verbose_name_plural = 'Корзины'      

    def __str__(self):
        return (f'{self.customer} -> {self.device}')

class FavoriteDevice(models.Model):
    id = models.AutoField(primary_key = True)
    customer = models.ForeignKey(Customer, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    like_flag = models.BooleanField(default = False)
    date_last_view = models.DateField() # default = timezone.now().date()

    class Meta:
        db_table = 'favorite_device'
        unique_together = (('customer', 'device'))
        ordering = ['-date_last_view']
        verbose_name = 'Понравившееся устройство'
        verbose_name_plural = 'Понравившиеся устройства'     

    def __str__(self):
        return (f'{self.customer} like {self.device}')

class PurchaseOrder(models.Model):
    id = models.AutoField(primary_key = True)
    customer = models.ForeignKey(Customer, on_delete = models.CASCADE)
    order_number = models.PositiveIntegerField(unique = True)
    courier = models.ForeignKey(Employee, on_delete = models.SET_NULL, blank = True, null = True)
    office = models.ForeignKey(Office, on_delete = models.CASCADE, default = 1)
    date_of_purchase = models.DateField() # default = timezone.now().date()
    date_of_delivery = models.DateField() # default = timezone.now().date()

    ORDER_FLAG_TYPE = [('Planned', 'Planned'), ('In progress', 'In progress'), \
        ('Completed', 'Completed'), ('Canceled', 'Canceled'), ('Postponed', 'Postponed')]

    order_flag = models.CharField(max_length = 15, choices = ORDER_FLAG_TYPE)
    comment_for_order = models.CharField(max_length = 500, blank = True, null = True)

    class Meta:
        db_table = 'purchase_order'
        ordering = ['-order_number']
        verbose_name = 'Заказ'
        verbose_name_plural = 'Заказы'

    def __str__(self):
        return (f'{self.customer} -> {self.order_number}')

class PurchasedDevice(models.Model):
    id = models.AutoField(primary_key = True)
    purchase_order = models.ForeignKey(PurchaseOrder, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    device_price = models.DecimalField(max_digits = 11, decimal_places = 2)
    device_count = models.PositiveSmallIntegerField(default = 1)

    class Meta:
        db_table = 'purchased_device'
        unique_together = (('device', 'purchase_order'))
        verbose_name = 'Устройство в заказе'
        verbose_name_plural = 'Устройства в заказах'

    def __str__(self):
        return (f'{self.purchase_order} -> {self.device}')

class Budget(models.Model):
    id = models.AutoField(primary_key = True)
    office = models.ForeignKey(Office, on_delete = models.SET_NULL, blank = True, null = True)
    date_added = models.DateField() # default = timezone.now().date()
    billing_month = models.PositiveSmallIntegerField()
    billing_year = models.PositiveSmallIntegerField()
    monthly_income = models.DecimalField(max_digits = 14, decimal_places = 2)
    monthly_expense = models.DecimalField(max_digits = 14, decimal_places = 2)
    monthly_profit = models.DecimalField(max_digits = 14, decimal_places = 2)
    comment_for_budget = models.CharField(max_length = 100, blank = True, null = True)

    class Meta:
        db_table = 'budget'
        unique_together = (('office', 'billing_month', 'billing_year'))
        ordering = ['-billing_year', '-billing_month']
        verbose_name = 'Бюджет'
        verbose_name_plural = 'Бюджеты'

    def __str__(self):
        return (f'{self.billing_month}.{self.billing_year}')

class WarehouseOfDevice(models.Model):
    id = models.AutoField(primary_key = True)
    warehouse = models.ForeignKey(Office, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    quantity = models.PositiveSmallIntegerField(default = 1)

    class Meta:
        db_table = 'warehouse_of_device'
        unique_together = (('device', 'warehouse'))
        verbose_name = 'Устройство на складе'
        verbose_name_plural = 'Устройства на складах'

    def __str__(self):
        return (f'{self.warehouse} -> {self.device}')

class Provider(models.Model):
    id = models.AutoField(primary_key = True)
    company_name = models.CharField(unique = True, max_length = 30)
    city = models.CharField(max_length = 50)
    phone = models.CharField(max_length = 20)
    email = models.EmailField(max_length = 100)

    class Meta:
        db_table = 'provider'
        verbose_name = 'Поставщик'
        verbose_name_plural = 'Поставщики'

    def __str__(self):
        return self.company_name

class Transport(models.Model):
    id = models.AutoField(primary_key = True)
    car_name = models.CharField(max_length = 50)
    car_number = models.CharField(unique = True, max_length = 16)

    CAR_FLAG_TYPE = [('Available', 'Available'), ('Under repair', 'Under repair'), ('Busy', 'Busy'), ('Moving out', 'Moving out')]

    car_flag = models.CharField(max_length = 15, choices = CAR_FLAG_TYPE)
    load_capacity = models.PositiveSmallIntegerField()
    city = models.CharField(max_length = 50)
    comment_transport = models.CharField(max_length = 500, blank = True, null = True)

    class Meta:
        db_table = 'transport'
        ordering = ['car_name']
        verbose_name = 'Машина'
        verbose_name_plural = 'Машины'

    def __str__(self):
        return (f'{self.car_name} | {self.car_number}')

class Shipment(models.Model):
    id = models.AutoField(primary_key = True)
    provider = models.ForeignKey(Provider, on_delete = models.SET_NULL, blank = True, null = True)
    delivery_from = models.ForeignKey(Office, related_name = 'delivery_from_id', on_delete = models.SET_NULL, blank = True, null = True)
    delivery_to = models.ForeignKey(Office, related_name = 'delivery_to_id', on_delete = models.CASCADE)
    responsible_person = models.ForeignKey(Employee, related_name = 'responsible_person_id', on_delete = models.SET_NULL, blank = True, null = True)
    driver = models.ForeignKey(Employee, related_name = 'driver_id', on_delete = models.SET_NULL, blank = True, null = True)
    transport = models.ForeignKey(Transport, on_delete = models.SET_NULL, blank = True, null = True)
    date_of_shipment = models.DateField() # default = timezone.now().date()

    ORDER_FLAG_TYPE = [('Planned', 'Planned'), ('In progress', 'In progress'), \
        ('Completed', 'Completed'), ('Canceled', 'Canceled'), ('Postponed', 'Postponed')]

    shipment_flag = models.CharField(max_length = 15, choices = ORDER_FLAG_TYPE)
    comment_shipment = models.CharField(max_length = 500, blank = True, null = True)

    class Meta:
        db_table = 'shipment'
        unique_together = (('delivery_to', 'responsible_person', 'driver', 'transport', 'date_of_shipment'))
        ordering = ['-date_of_shipment']
        verbose_name = 'Поставка'
        verbose_name_plural = 'Поставки'

    def __str__(self):
        return (f'{self.delivery_from} -> {self.delivery_to}')

class DeviceOfShipment(models.Model):
    id = models.AutoField(primary_key = True)
    shipment = models.ForeignKey(Shipment, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.CASCADE)
    device_count = models.PositiveSmallIntegerField(default = 1)

    class Meta:
        db_table = 'device_of_shipment'
        unique_together = (('device', 'shipment'))
        verbose_name = 'Устройство в поставке'
        verbose_name_plural = 'Устройства в поставках'

    def __str__(self):
        return (f'{self.shipment} -> {self.device}')

class DeviceCategory(models.Model):
    id = models.AutoField(primary_key = True)
    category_name = models.CharField(unique = True, max_length = 50)
    top_category = models.ForeignKey('self', on_delete = models.SET_NULL, blank = True, null = True)

    class Meta:
        db_table = 'device_category'
        verbose_name = 'Категория устройства'
        verbose_name_plural = 'Категории устройств'

    def __str__(self):
        return self.category_name

class DeviceCriteria(models.Model):
    id = models.AutoField(primary_key = True)
    crit_name = models.CharField(max_length = 50)
    param_int = models.IntegerField(blank = True, null = True)
    param_varchar = models.CharField(max_length = 50, blank = True, null = True)
    param_dec = models.DecimalField(max_digits = 5, decimal_places = 2, blank = True, null = True)
    param_bool = models.BooleanField(blank = True, null = True)

    class Meta:
        db_table = 'device_criteria'
        verbose_name = 'Характеристика устройства'
        verbose_name_plural = 'Характеристики устройств'

    def __str__(self):
        return self.crit_name

class CategoryCriteria(models.Model):
    id = models.AutoField(primary_key = True)
    category = models.ForeignKey(DeviceCategory, on_delete = models.CASCADE)
    criteria = models.ForeignKey(DeviceCriteria, on_delete = models.CASCADE)
    device = models.ForeignKey(Device, on_delete = models.SET_NULL, blank = True, null = True)

    class Meta:
        managed = False
        db_table = 'category_criteria'
        unique_together = (('category', 'criteria', 'device'))
        verbose_name = 'Связь между категориями и критериями'
        verbose_name_plural = 'Связи между категориями и критериями'

    def __str__(self):
        return (f'{self.category} -> {self.criteria} | {self.device}')

