import memcache
import hashlib
import datetime as dt
import decimal
import os.path
import random

from .models import *
from django.db.models import Q
from re import sub

TIME_CACHE = 15

CLIENT = memcache.Client(('localhost', '11211'))

def device_of_category_cache(category, size):
    client = CLIENT
    str_cache = 'device_of_category_' + str(category)
    list_device = client.get(str_cache)
    if list_device is None:
        try: 
            dict_device = DeviceCategory.objects.get(id = category).categorycriteria_set.values('device')
            list_device = [v for _, v in dict_d.items() for dict_d in dict_device]
        except Exception as a: return []
        client.set(str_cache, list_device, time = TIME_CACHE)
    return list_device[:size]

def device_cache(size, start, category, price_min, price_max, flag_order):
    client = CLIENT
    start_new = sub(r'\s+', '_', start)
    str_cache = 'device_' + str(size) + '_' + start_new + '_' + str(category) + '_' + price_min + '_' + price_max
    list_device = client.get(str_cache)
    if list_device is None:
        list_device_category = device_of_category_cache(category, size)
        price_min_new = decimal.Decimal(price_min)
        price_max_new = decimal.Decimal(price_max)
        order = 'price'
        if flag_order == 2: order = '-price'
        try: list_device = Device.objects.filter(device_name__icontains = start, price__range = (price_min_new, price_max_new)).order_by(order, 'device_name')
        except Exception as a: return None
        if list_device_category: list_device = [querySet for querySet in list_device if querySet in list_device_category]
        client.set(str_cache, list_device, time = TIME_CACHE)
    return list_device[:size]

def customer_profile(customer_id):
    client = CLIENT
    str_cache = 'customer_check_' + str(customer_id)
    customer = client.get(str_cache)
    if customer is None: customer = Customer.objects.get(id = customer_id)
    return customer

def device_find(device_id):
    client = CLIENT
    str_cache = 'device_check_' + str(device_id)
    device = client.get(str_cache)
    if device is None: device = Device.objects.get(id = device_id)
    return device

def device_add_favorite(device, customer_id):
    client = CLIENT
    str_cache = 'device_favorite_' + str(device.id) + '_' + str(customer_id)
    favorite = client.get(str_cache)
    if favorite is None:
        customer = customer_profile(customer_id)
        try: favorite = FavoriteDevice.objects.get(device = device, customer = customer)        
        except Exception as e:
            try: 
                favorite = FavoriteDevice.objects.create(customer = customer, device = device, date_last_view = dt.date.today())
                favorite.save()
                client.set(str_cache, favorite, time = TIME_CACHE)
                return
            except Exception as e: return -1
    favorite.date_last_view = dt.date.today()
    favorite.save()
    return

def device_criteria_cache(device_id, customer, flag):
    client = CLIENT
    str_cache = 'device_criteria_' + str(device_id)
    device = None
    if flag == False: device = client.get(str_cache)
    if device is None:
        try: device = device_find(device_id)
        except Exception as a: return None
        client.set(str_cache, device, time = TIME_CACHE)
        if customer > 0: device_add_favorite(device, customer)
    return device

def category_cache(top_category):
    client = CLIENT
    str_cache = 'category_' + str(top_category)
    list_category = client.get(str_cache)
    if list_category is None:
        if top_category == 0: list_category = DeviceCategory.objects.order_by('category_name')
        else: 
            try: list_category = DeviceCategory.objects.filter(top_category = top_category)
            except Exception as a: return None
        client.set(str_cache, list_category, time = TIME_CACHE)
    return list_category

def create_new_customer(login, password, first_name, second_name, gender, date_of_birth, phone, email):
    try: 
        customer = Customer.objects.get(login = login)
        return -1
    except Exception as e: 
        date_now = dt.date.today()
        birthday = dt.datetime.strptime(date_of_birth, '%Y-%m-%d').date()
        age = (date_now - birthday) // dt.timedelta(days = 365.2425)
        if (age < 14) or (age > 120): return -2
        password_new = (hashlib.sha256(password.encode()).hexdigest())[:50]
        first_name_new = (first_name[0]).title() + first_name[1:]
        second_name_new = (second_name[0]).title() + second_name[1:]
        try:
            customer = Customer.objects.create(login = login, password = password_new, first_name = first_name_new, gender = gender, \
                second_name = second_name_new, date_of_birth = birthday, age = age, phone = phone, email = email, registration_date = date_now)
            customer.save()
            return 1
        except Exception as e: return -3

def customer_check(login, password):
    client = CLIENT
    login_new = sub(r'\s+', '_', login)
    str_cache = 'customer_check_' + login_new
    customer = client.get(str_cache)
    if customer is None:
        try: customer = Customer.objects.get(login = login)
        except Exception as e: return -1
        password_old = customer.password
        password_new = (hashlib.sha256(password.encode()).hexdigest())[:50]
        if password_new != password_old: return -1
        client.set(str_cache, customer, time = TIME_CACHE)
    return customer.id

def device_comment_cache(device_id, size, flag):
    client = CLIENT
    str_cache = 'list_comment_for_device_' + str(device_id)
    list_comment = None
    if flag == False: list_comment = client.get(str_cache)
    if list_comment is None:
        try: list_comment = device_find(device_id).feedback_set.all()
        except Exception as e: return []
        client.set(str_cache, list_comment, time = TIME_CACHE)
    return list_comment[:size]

def device_rating_update(rating, device):
    list_comment_count = (Feedback.objects.filter(device = device)).count()
    rating_old = device.rating
    if list_comment_count == 1: device.rating = rating
    elif rating_old > rating: device.rating = round((rating_old - rating / list_comment_count), 1)
    else: device.rating = round((rating_old + rating / list_comment_count), 1) 
    device.save()
    return

def comment_new(device_id, customer_id, rating, comment):
    client = CLIENT
    str_cache = 'list_comment_new_check_' + str(device_id) + '_' + str(customer_id)
    comment_old = client.get(str_cache)
    if comment_old is None:
        customer = customer_profile(customer_id)
        device = device_find(device_id)
        comment_count = Feedback.objects.filter(customer = customer, device = device).count()
        if comment_count > 0: return -1
        try:
           basket_list = Basket.objects.get(customer = customer, device = device)
           flag_buy = True
        except Exception as e: flag_buy = False
        comment_new = comment
        if comment == '': comment_new = None
        rating_new = decimal.Decimal(rating)
        try:
            comment_new = Feedback.objects.create(customer = customer, device = device, date_of_feedback = dt.date.today(), \
                rating_of_device = rating_new, flag_of_purchase = flag_buy, comment_feedback = comment_new)
            comment_new.save()
        except Exception as e: return -2
        client.set(str_cache, comment_new, time = TIME_CACHE)
        device_rating_update(rating_new, device)
        return 1
    return -1

def customer_profile_update(customer, login, password, first_name, second_name, gender, date_of_birth, phone, email):
    customer_old = customer_profile(customer)
    try:
        customer_check = (Customer.objects.get(login = login)).id
        if customer != customer_check: return -1
    except Exception as e: 
        customer_old.login = login
        if date_of_birth != '':
            birthday = dt.datetime.strptime(date_of_birth, '%Y-%m-%d').date()
            age = (dt.date.today() - birthday) // dt.timedelta(days = 365.2425)
            if (age < 14) or (age > 120): return -2
            customer_old.date_of_birth = birthday
            customer_old.age = age
        if password != '': customer_old.password = (hashlib.sha256(password.encode()).hexdigest())[:50]
        if gender != 'O': 
            if customer_old.gender == 'M': customer_old.gender = 'F'
            else: customer_old.gender = 'M'
        customer_old.first_name = (first_name[0]).title() + first_name[1:]
        customer_old.second_name = (second_name[0]).title() + second_name[1:]
        customer_old.phone = phone
        customer_old.email = email
        customer_old.save()
        return 1

def device_favorite_cache(customer, size, flag):
    client = CLIENT
    str_cache = 'list_favorite_device_' + str(customer)
    list_favorite = None
    if flag == False: list_favorite = client.get(str_cache)
    if list_favorite is None:
        try: list_favorite = (customer_profile(customer)).favoritedevice_set.all()
        except Exception as e: return []
        client.set(str_cache, list_favorite, time = TIME_CACHE)
    return list_favorite[:size]

def favorite_clear(customer):
    FavoriteDevice.objects.filter(customer = customer_profile(customer)).delete()

def basket_cache(customer, size, flag):
    client = CLIENT
    str_cache = 'list_basket_device_' + str(customer)
    list_basket = None
    if flag == False: list_basket = client.get(str_cache)
    if list_basket is None:
        try: list_basket = (customer_profile(customer)).basket_set.all()
        except Exception as e: return []
        client.set(str_cache, list_basket, time = TIME_CACHE)
    return list_basket[:size]

def basket_clear(device_id, customer):
    Basket.objects.get(customer = customer_profile(customer), device = device_find(device_id)).delete()

def device_basket(device_id, customer_id, volume):
    client = CLIENT
    str_cache = 'device_add_basket_' + str(customer_id) + '_' + str(device_id) + '_' + str(volume)
    basket = client.get(str_cache)
    if basket is None:
        customer = customer_profile(customer_id)
        device = device_find(device_id)
        date_now = dt.date.today()
        try: 
            basket = Basket.objects.get(device = device, customer = customer, date_device_added = date_now)
            return -1
        except Exception as e: 
            basket = Basket.objects.create(device = device, customer = customer, date_device_added = date_now, device_volume = volume)
            basket.save()
            client.set(str_cache, basket, time = TIME_CACHE - 5)
            return 1
    return -1

def device_image(device_id, size = 10):
    client = CLIENT
    str_cache = 'device_image_' + str(device_id)
    list_image = client.get(str_cache)
    if list_image is None: 
        try: list_image = device_find(device_id).image_set.all()
        except Exception as e: return []
        list_image_old = list_image
        list_image = []
        for image in list_image_old:
            if not os.path.exists(image.uri_image):
                with open('log.txt', 'a') as log: 
                    log.write(f'Error! {image.uri_image} for device {device_id} do not exist!!! Please check URI-path!\n')
                image.delete()
            else: 
                list_slash = ((image.uri_image).split('/'))[-3:]
                result_str = '/' + '/'.join(list_slash)
                list_image.append(result_str)
        client.set(str_cache, list_image, time = TIME_CACHE)
    return list_image[:size]

def company_all():
    client = CLIENT
    str_cache = 'company_all'
    list_company = client.get(str_cache)
    if list_company is None: 
        try: list_company = Company.objects.order_by('company_name')
        except Exception as e: return []
        client.set(str_cache, list_company, time = TIME_CACHE)
    return list_company

def processor_all():
    client = CLIENT
    str_cache = 'processor_all'
    list_processor = client.get(str_cache)
    if list_processor is None: 
        try: list_processor = ProcessorCPU.objects.order_by('cpu_manufacturer')
        except Exception as e: return []
        client.set(str_cache, list_processor, time = TIME_CACHE)
    return list_processor

def device_from_crit(list_crit):
    device_list = []
    for crit in list_crit:
        for cat_crit in crit.categorycriteria_set.all():
            device = cat_crit.device
            if device is not None: device_list.append(device)
    return set(device_list)

def criteria_filter(os_info, ram, rom, back_camera, max_cameras, sim):
    client = CLIENT
    str_cache = 'device_criteria_' + str(ram) + '_' + str(ram) + '_' + str(back_camera) + '_' + str(max_cameras) + '_' + sim
    list_device = client.get(str_cache)
    if list_device is None:
        os_list = ['Android', 'iOS', 'Windows', 'Lunix', 'Ubuntu', 'Windows Phone', 'Fedora']
        list_device = set(Device.objects.all())
        if ram > 0:
            device_ram = device_from_crit(DeviceCriteria.objects.filter(crit_name = 'RAM capacity', param_int__gte = ram))
            list_device = list_device & device_ram
        if rom > 0:
            device_rom = device_from_crit(DeviceCriteria.objects.filter(crit_name = 'Maximum memory capacity', param_int__gte = rom))
            list_device = list_device & device_rom
        if back_camera > 0:
            device_back = device_from_crit(DeviceCriteria.objects.filter(crit_name = 'Max back camera', param_int__gte = back_camera))
            list_device = list_device & device_back
        if max_cameras > 0:
            device_max_camera = device_from_crit(DeviceCriteria.objects.filter(crit_name = 'Number of back cameras', param_int__gte = max_cameras))
            list_device = list_device & device_max_camera
        if sim != 'ANY?':
            device_sim = device_from_crit(DeviceCriteria.objects.filter(crit_name = 'SIM format', param_varchar__icontains = sim))
            list_device = list_device & device_sim
        if os_info != 'ANY?':
            device_os_info = DeviceCriteria.objects.filter(crit_name = 'OS info')
            if os_info == 'Other':
                for os_name in os_list: device_os_info = device_os_info.exclude(param_varchar__icontains = os_name)
            else: device_os_info = device_os_info.filter(param_varchar__icontains = os_info)
            list_device = list_device & device_from_crit(device_os_info)
        client.set(str_cache, list_device, time = TIME_CACHE)
    return list_device

def device_filter(start, size, price_min, price_max, flag_order, category, company, processor, rating, \
        warranty, os_info, year_max, ram, rom, front_camera, max_camera, sim):
    client = CLIENT
    str_cache = 'device_' + str(size) + '_' + start + '_' + str(category) + '_' + price_min + '_' + price_max + '_' + company \
        + '_' + processor + '_' + rating + '_' + str(max_camera)
    str_cache = sub(r'\s+', '_', str_cache)
    list_device = client.get(str_cache)
    if list_device is None:
        price_min_new = decimal.Decimal(price_min)
        price_max_new = decimal.Decimal(price_max)
        order = 'price'
        if flag_order == 2: order = '-price'
        if category == 'ANY?': category_id = 0
        else: category_id = (DeviceCategory.objects.get(category_name = category)).id
        list_device = Device.objects.filter(device_name__icontains = start, price__range = (price_min_new, price_max_new)).order_by(order, 'device_name')
        rating_new = decimal.Decimal(rating)
        release_year = dt.date.today().year - year_max
        list_device = list_device.filter(rating__gte = rating_new, warranty__gte = warranty, release_year__gte = release_year)
        list_device = set(list_device)
        if company != 'ANY?': 
            company_device = Company.objects.get(company_name = company).device_set.all()
            list_device = list_device & set(company_device)
        if processor != 'ANY?':
            list_crit = processor.split('|')
            processor_device = ProcessorCPU.objects.get(cpu_manufacturer = list_crit[0], cpu_line = list_crit[1], cpu_model = list_crit[2]).device_set.all()
            list_device = list_device & set(processor_device)
        list_device = list_device & (criteria_filter(os_info, ram, rom, front_camera, max_camera, sim))
        client.set(str_cache, list_device, time = TIME_CACHE)
    return (category_id, list(list_device)[:size])

def criteria_all(device_id, category):
    client = CLIENT
    str_cache = 'criteria_all_' + str(device_id) + '_' + str(category)
    list_criteria = client.get(str_cache)
    if list_criteria is None:
        list_criteria = []
        list_crit = CategoryCriteria.objects.filter(device = device_find(device_id))
        if category > 0: 
            cat = DeviceCategory.objects.get(id = category)
            list_crit.filter(category = cat)
            list_criteria.append(['Category', cat])
        set_crit_name = set()
        for QuerySet in list_crit:
            criteria = QuerySet.criteria
            crit_name = criteria.crit_name
            if crit_name in set_crit_name: continue
            set_crit_name.add(crit_name)
            if criteria.param_int is not None: list_criteria.append([crit_name, criteria.param_int])
            elif criteria.param_varchar is not None: list_criteria.append([crit_name, criteria.param_varchar])
            elif criteria.param_dec is not None: list_criteria.append([crit_name, criteria.param_dec])
            else: list_criteria.append([crit_name, criteria.param_bool])
        client.set(str_cache, list_criteria, time = TIME_CACHE)
    return list_criteria

def device_from_basket(customer, basket_numbers):
    client = CLIENT
    str_cache = 'device_from_basket_' + str(customer) + '_' + str(basket_numbers[0])
    list_result = client.get(str_cache)
    if list_result is None:
        device_list = []
        price_total = decimal.Decimal('0.0')
        token = ''
        for basket_id in basket_numbers:
            basket = Basket.objects.get(basket_number = int(basket_id))
            device = basket.device
            volume = basket.device_volume
            price_total += device.price * volume
            token += (str(device.id) + '|' + str(volume) + '_')
            device_list.append([device, volume])
        token = str(price_total) + '_' + token[:-1]
        list_result = (token, price_total, device_list)
        client.set(str_cache, list_result, time = TIME_CACHE + 10)
    return list_result

def store_choose(token, flag):
    client = CLIENT
    token_new = token.replace(',', '|')
    str_cache = 'store_shooce_' + token_new + '_' + str(flag)
    list_result = client.get(str_cache)
    if list_result is None:
        flag_new = flag
        token_list = token.split('_')
        price_total = token_list[0]
        token_list = token_list[1:]
        device_list = [token_entry.split('|')[0] for token_entry in token_list]
        device_list = [device_find(int(device_id)) for device_id in device_list]
        volume_list = [int(token_entry.split('|')[1]) for token_entry in token_list]       
        if flag == 1:
            list_store = []
            dict_device = dict()
            for it in range(len(volume_list)): dict_device[device_list[it]] = volume_list[it]
            warehouse = WarehouseOfDevice.objects.filter(device__in = device_list).order_by('warehouse')
            try: 
                office_last = (warehouse[0]).warehouse
                size = 0
                for office in warehouse:
                    if office_last != office.warehouse:
                        if size >= len(device_list): list_store.append(office_last)  
                        size = 0
                    for device in device_list:
                        if (office.device == device) and (office.quantity >= dict_device[device]): size += 1
                    office_last = office.warehouse
            except Exception as e: flag_new = 2
            if not list_store: flag_new = 2
            device_list = []
            for key in dict_device.keys(): device_list.append([key, dict_device[key]])
        if flag_new == 2: list_store = Office.objects.all()
        list_result = (flag_new, token, price_total, device_list, list_store)
        client.set(str_cache, list_result, time = TIME_CACHE)
    return list_result

def order_finish(customer, token, store, courier_flag):
    order_number = random.randint(1000000, 10000000)
    try: office = store.split('|')[2]
    except Exception as e: return -1
    date_now = dt.date.today()
    date_of_delivery = date_now + dt.timedelta(days = random.randint(1, 7))
    courier = None
    cust = customer_profile(customer)
	office_new = Office.objects.get(store_number = office)
    if courier_flag == 2: 
        courier = Employee.objects.filter(office = office_new, employee_position = 'courier')
		if not courier:  Employee.objects.filter(employee_position = 'courier')
        courier = random.choice(courier)
    try:  
        order = PurchaseOrder.objects.create(customer = cust, order_number = order_number, courier = courier, \
            office = office_new, date_of_purchase = date_now, date_of_delivery = date_of_delivery, order_flag = 'Planned')
        order.save()
    except Exception as e: return -1
    token_list = (token.split('_'))[1:]
    device_list = [token_entry.split('|')[0] for token_entry in token_list]
    device_list = [device_find(int(device_id)) for device_id in device_list]
    volume_list = [int(token_entry.split('|')[1]) for token_entry in token_list]  
    for it in range(len(volume_list)):
        try: 
            purchased_device = PurchasedDevice.objects.create(purchase_order = order, device = device_list[it], \
                device_price = device_list[it].price, device_count = volume_list[it])
            purchased_device.save()
        except Exception as e: return -1
        Basket.objects.filter(customer = cust, device = device_list[it]).delete()
    return 1

def return_list_order(customer, flag):
    client = CLIENT
    str_cache = 'all_order_for_' + str(customer)
    list_result = None
    if not flag: list_result = client.get(str_cache)
    if list_result is None:
        try: list_result = PurchaseOrder.objects.filter(customer = customer_profile(customer))
        except Exception as e: return []
        client.set(str_cache, list_result, time = TIME_CACHE)
    return list_result

def order_delete(order_number):
    order = PurchaseOrder.objects.get(order_number = order_number)
    if order.order_flag == 'Planned':
        order.order_flag == 'Canceled'
        order.save()
        return 1
    else: return -1

def order_device(order_number):
    client = CLIENT
    str_cache = 'order_device_' + str(order_number)
    list_result = client.get(str_cache)
    if list_result is None: 
        purchase_order = PurchaseOrder.objects.get(order_number = order_number)
        list_result = PurchasedDevice.objects.filter(purchase_order = purchase_order)
        total_price = decimal.Decimal('0.0')
        for device in list_result: total_price += (device.device_count * device.device_price)
        list_result = (list_result, total_price)
        client.set(str_cache, list_result, time = TIME_CACHE)
    return list_result
