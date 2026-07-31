from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    # Login y Logout
    path('login/', auth_views.LoginView.as_view(template_name='sistema/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='login'), name='logout'),
    
    # Redirección según Rol
    path('', views.dashboard, name='dashboard'),

    # Inventario / Tabla General
    path('productos/', views.lista_productos, name='lista_productos'),
]