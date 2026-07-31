from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('sistema.urls')),  # Incluye las rutas de la app sistema
]