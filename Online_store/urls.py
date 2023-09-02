from . import settings
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static

urlpatterns = [
    path('', include('StoreApp.urls')),
    path('grappelli/', include('grappelli.urls')),
    path('admin/', admin.site.urls)
] + static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
