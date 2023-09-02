from django.shortcuts import render
from django.urls import reverse
from django.http import HttpResponse, Http404, HttpResponseRedirect
from . import middleware

def device(request, size = 25, start = ' ', message = '', customer_id = 0, category = 0, price_min = '100', price_max = '1000000', flag = 1):
    list_device = middleware.device_cache(size, start, category, price_min, price_max, flag)
    return render(request, 'StoreApp/device.html', {'list_device':list_device, \
        'customer':customer_id, 'category':category, 'message':message})

def criteria(request, device_id, category = 0, customer = 0, message = '', flag = False, size = 50, flag_all = False):
    device = middleware.device_criteria_cache(device_id, customer, flag)
    list_comment = middleware.device_comment_cache(device_id, size, flag)
    list_image = middleware.device_image(device_id)
    list_criteria = []
    if flag_all: list_criteria = middleware.criteria_all(device_id, category)
    return render(request, 'StoreApp/device_criteria.html', {'device':device, 'customer':customer, 'category':category, 'flag':flag_all, \
        'list_criteria':list_criteria, 'list_comment':list_comment, 'list_image':list_image, 'message':message})

def device_search(request, customer = 0, category = 0):
    try: start = (request.POST['device_search']).strip()
    except Exception as e: start = ' '
    try: size = int(request.POST['size'])
    except Exception as e: size = 25
    price_min = request.POST['price_min']
    price_max = request.POST['price_max']
    flag_order = int(request.POST['order'])
    return device(request, size, start, '', customer, category, price_min, price_max, flag_order)

def category(request, category_name = '', top_category = 0, customer = 0):
    list_category = middleware.category_cache(top_category)
    if list_category: return render(request, 'StoreApp/device_category.html', {'list_category':list_category, 'customer':customer})
    category_name_new = category_name
    if category_name != '': category_name_new = (category_name[0]).title() + category_name[1:]
    return device(request, message = f'All devices of the selected \'{category_name_new}\'', customer_id = customer, category = top_category)

def category_next(request, category_name, category_id, customer = 0):
    return category(request, category_name, category_id, customer)

def customer_registration(request, message = '', customer = 0):
   return render(request, 'StoreApp/customer_registration.html', {'message':message, 'customer':customer})

def customer_entry(request, message = '', customer = 0):
    return render(request, 'StoreApp/customer_entry.html', {'message':message, 'customer':customer})

def customer_new(request, customer = 0):
    password = request.POST['password']
    password_again = request.POST['password_again']
    if password != password_again: return customer_registration(request, 'Passwords don\'t match :(', customer)
    gender = request.POST['gender']
    login = request.POST['login']
    first_name = request.POST['first_name']
    second_name = request.POST['second_name']
    date_of_birth = request.POST['date_of_birth']
    phone = request.POST['phone']
    email = request.POST['email']
    result = middleware.create_new_customer(login, password, first_name, second_name, gender, date_of_birth, phone, email)
    if result > 0: return customer_entry(request, message = 'Registration was successful, please, log in to system', customer = customer)
    elif result == -1: return customer_registration(request, 'This login is already used, please, come up with another one', customer)
    elif result == -2: return customer_registration(request, 'Are you under 14 yet?', customer)
    else: return customer_registration(request, 'Invalid data. Check the input', customer)

def customer_entry_check(request, customer = 0):
    login = request.POST['login']
    password = request.POST['password']
    result = middleware.customer_check(login, password)
    if result > 0: return device(request, message = f'Welcome {login}!!!', customer_id = result)
    else: return customer_entry(request, 'The login or password is incorrect. Please try again!', customer)

def comment_new(request, device_id, category, customer):
    rating = request.POST['rating']
    comment = request.POST['comment']
    result = middleware.comment_new(device_id, customer, rating, comment)
    flag = False
    if result == -1: message = 'You have already left a comment for this device :('
    elif result == -2: message = 'Invalid data. Check the input'
    else:
        flag = True
        message = 'Your comment was added successfully!!!'
    return criteria(request, device_id = device_id, category = category, customer = customer, message = message, flag = flag)

def customer_exit(request):
    return device(request, message = 'You have successfully logged out!!!', customer_id = 0)

def customer_profile(request, customer, message = ''):
    cust = middleware.customer_profile(customer)
    return render(request, 'StoreApp/customer_profile.html', {'message':message, 'customer':cust.id, 'profile':cust})

def customer_profile_edit(request, customer):
    password = request.POST['password']
    if password is None: password = ''
    password_again = request.POST['password_again']
    if password_again is None: password_again = ''
    if password != password_again: return customer_profile(request, customer, 'Passwords don\'t match :(')
    gender = request.POST['gender']
    login = request.POST['login']
    first_name = request.POST['first_name']
    second_name = request.POST['second_name']
    date_of_birth = request.POST['date_of_birth']
    phone = request.POST['phone']
    email = request.POST['email']
    result = middleware.customer_profile_update(customer, login, password, first_name, second_name, gender, date_of_birth, phone, email)
    if result > 0: return device(request, message = 'Profile updated successfully!', customer_id = customer)
    elif result == -1: return customer_profile(request, customer, 'This login is already used, please, come up with another one')
    else: return customer_profile(request, customer, 'You remember your age, don\'t you?')

def favorite_device(request, customer, flag = False, size = 50):
    list_device = middleware.device_favorite_cache(customer, size, flag)
    return render(request, 'StoreApp/favorite_device.html', {'list_favorite':list_device, 'customer':customer})

def favorite_clear(request, customer):
    middleware.favorite_clear(customer)
    return favorite_device(request, customer = customer, flag = True)

def device_add_basket(request, device_id, customer):
    try: volume = int(request.POST['basket_size'])
    except Exception as e: volume = 1
    result = middleware.device_basket(device_id, customer, volume)
    if result == 1: message = 'Devices added to basket successfully!'
    else: message = 'You have already added this device to your basket today. Try again tomorrow!'
    return criteria(request, device_id = device_id, customer = customer, message = message)

def basket(request, customer, flag = False, size = 50, flag_order = 0, token = '', \
                        price = 0.0, list_device = [], list_store = [], message = ''):
    list_basket = list_device
    if not list_device: list_basket = middleware.basket_cache(customer, size, flag)
    return render(request, 'StoreApp/basket.html', {'list_basket':list_basket, 'customer':customer, \
        'flag_order':flag_order, 'token':token, 'price':price, 'list_store':list_store, 'message':message})

def device_from_basket(request, device_id, customer):
    middleware.basket_clear(device_id, customer)
    return basket(request, customer, True)

def device_clear_category(request, customer):
    return device(request, customer_id = customer, category = 0)

def device_filter(request, customer):
    list_category = middleware.category_cache(0)
    list_company = middleware.company_all()
    list_processor = middleware.processor_all()
    return render(request, 'StoreApp/device_filter.html', {'list_category':list_category, 'customer':customer, \
        'list_company':list_company, 'list_processor':list_processor})

def device_edit_filter(request, customer):
    try: start = (request.POST['device_search']).strip()
    except Exception as e: start = ' '
    try: size = int(request.POST['size'])
    except Exception as e: size = 25
    price_min = request.POST['price_min']
    price_max = request.POST['price_max']
    flag_order = int(request.POST['order'])
    category = request.POST['category']
    company = request.POST['company']
    processor = request.POST['processor']
    rating = request.POST['rating']
    warranty = int(request.POST['warranty'])
    os_info = request.POST['os_info']
    year_max = int(request.POST['year_max'])
    ram = int(request.POST['ram'])
    rom = int(request.POST['rom'])
    back_camera = int(request.POST['back_camera'])
    max_cameras = int(request.POST['max_cameras'])
    sim = request.POST['sim_search']
    category, list_device = middleware.device_filter(start, size, price_min, price_max, flag_order, category, company, processor, rating, \
        warranty, os_info, year_max, ram, rom, back_camera, max_cameras, sim)
    return render(request, 'StoreApp/device.html', {'list_device':list_device, 'customer':customer, 'category':category, 'message':'Filter!!!'})

def criteria_all(request, device_id, category = 0, customer = 0):
    return criteria(request, device_id = device_id, category = category, customer = customer, flag_all = True)

def criteria_no(request, device_id, category = 0, customer = 0):
    return criteria(request, device_id = device_id, category = category, customer = customer, flag_all = False)

def order_no(request, customer):
    return basket(request, customer = customer, flag_order = 0)

def create_order(request, customer):
    return basket(request, customer = customer, flag_order = 1)

def order_next(request, customer, size = 50):
    basket_numbers = request.POST.getlist('device_choose')
    if not basket_numbers: return order_no(request, customer)
    token, price_total, list_device = middleware.device_from_basket(customer, basket_numbers[:size])
    return basket(request, customer = customer, flag_order = 2, token = token, price = price_total, list_device = list_device)

def order_store(request, customer, token):
    flag = int(request.POST['order'])
    flag_new, token, price_total, device_list, list_store = middleware.store_choose(token, flag)
    message = ''
    if flag_new != flag: message = 'Выбранных устройств в наличии не оказалось!'
    return basket(request, customer = customer, flag_order = 3, token = token, price = price_total, \
        list_device = device_list, list_store = list_store, message = message)

def order(request, customer, flag = False, message = '', list_device = []):
    list_order = middleware.return_list_order(customer, flag)
    return render(request, 'StoreApp/order.html', {'list_order':list_order, 'customer':customer, 'message':message, 'list_device':list_device})

def order_finish(request, customer, token):
    store = request.POST['office_set']
    courier_flag = int(request.POST['courier'])
    result = middleware.order_finish(customer, token, store, courier_flag)
    if result == 1: message = 'Заказ успешно добавлен'
    else: message = 'Что-то пошло не так, повторите попытку!'
    return order(request, customer = customer, message = message)

def order_delete(request, customer, order_number):
    result = middleware.order_delete(order_number)
    if result == 1: message = 'Заказ был успешно отменен'
    else: message = 'Можно отменить только Запланированные заказы'
    return order(request, customer = customer, flag = True, message = message)

def order_device(request, customer, order_number):
    list_device = middleware.order_device(order_number)
    return order(request, customer = customer, flag = False, message = f'Информация о заказе {order_number}', list_device = list_device)
