from django.urls import path
from . import views

app_name = 'StoreApp'

urlpatterns = [
    path(r'', views.device, name = 'device'),
    path(r'<int:customer_id>', views.device, name = 'device'),
    path(r'device/<int:device_id>/<int:category>/<int:customer>/', views.criteria, name = 'device_criteria'),
    path(r'device/crit_all/<int:device_id>/<int:category>/<int:customer>/', views.criteria_all, name = 'criteria_all'),
    path(r'device/crit_no/<int:device_id>/<int:category>/<int:customer>/', views.criteria_no, name = 'criteria_no'),
    path(r'device/search/<int:category>/<int:customer>/', views.device_search, name = 'device_search'),
    path(r'device/comment_new/<int:device_id>/<int:category>/<int:customer>/', views.comment_new, name = 'comment_new'),
    path(r'category/<int:customer>/', views.category, name = 'category'),
    path(r'category/<str:category_name>_<int:category_id>/<int:customer>/', views.category_next, name = 'category_next'),
    path(r'customer/registration/<int:customer>/', views.customer_registration, name = 'customer_registration'),
    path(r'customer/registration/new/<int:customer>/', views.customer_new, name = 'customer_new'),
    path(r'customer/entry/<int:customer>/', views.customer_entry, name = 'customer_entry'),
    path(r'customer/entry/check/<int:customer>/', views.customer_entry_check, name = 'customer_entry_check'),
    path(r'customer/exit/', views.customer_exit, name = 'customer_exit'),
    path(r'customer/profile/<int:customer>/', views.customer_profile, name = 'customer_profile'),
    path(r'customer/profile/edit/<int:customer>/', views.customer_profile_edit, name = 'customer_profile_edit'),
    path(r'favorite/<int:customer>/', views.favorite_device, name = 'favorite_device'),
    path(r'basket/<int:customer>/', views.basket, name = 'basket'),
    path(r'basket/<int:device_id>/<int:customer>/', views.device_add_basket, name = 'device_add_basket'),
    path(r'favorite/clear/<int:customer>/', views.favorite_clear, name = 'favorite_clear'),
    path(r'basket/clear/<int:device_id>/<int:customer>', views.device_from_basket, name = 'device_from_basket'),
    path(r'category/clear/<int:customer>/', views.device_clear_category, name = 'device_clear_category'),
    path(r'filter/<int:customer>/', views.device_filter, name = 'filter'),
    path(r'filter/edit/<int:customer>/', views.device_edit_filter, name = 'edit_filter'),
    path(r'order_no/<int:customer>/', views.order_no, name = 'order_no'),
    path(r'order_begin/<int:customer>/', views.create_order, name = 'create_order'),
    path(r'order_next/<int:customer>/', views.order_next, name = 'order_next'),
    path(r'order_store/<int:customer>/<str:token>/', views.order_store, name = 'order_store'),
    path(r'order_finish/<int:customer>/<str:token>/', views.order_finish, name = 'order_finish'),
    path(r'order/<int:customer>/', views.order, name = 'order'),
    path(r'order_delete/<int:customer>/<int:order_number>/', views.order_delete, name = 'order_delete'),
    path(r'order_device/<int:customer>/<int:order_number>/', views.order_device, name = 'order_device')
]
