from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    # Login y Logout
    path('login/', auth_views.LoginView.as_view(template_name='sistema/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='login'), name='logout'),
    
    # Redirección según Rol y Dashboards
    path('', views.dashboard, name='dashboard'),
    path('dashboard/admin/', views.dashboard_admin, name='dashboard_admin'),
    path('dashboard/almacen/', views.dashboard_almacen, name='dashboard_almacen'),
    path('dashboard/ventas/', views.dashboard_ventas, name='dashboard_ventas'),

    # Inventario / Tabla General
    path('productos/', views.lista_productos, name='lista_productos'),
    path('productos/editar/<int:producto_id>/', views.editar_producto, name='editar_producto'),
    path('productos/toggle-estado/<int:producto_id>/', views.toggle_estado_producto, name='toggle_estado_producto'),

    # Carga Masiva de Catálogos / Proveedores
    path('proveedores/cargar-excel/', views.cargar_catalogo_proveedor, name='cargar_catalogo_proveedor'),
    path('proveedores/buscar-ajax/', views.buscar_proveedores_ajax, name='buscar_proveedores_ajax'),

    # Punto de Venta / Caja Mostrador
    path('pos/', views.pos_ventas, name='pos_ventas'),
    path('pos/procesar-venta/', views.procesar_venta, name='procesar_venta'),

    # Historial de Ventas y Corte de Caja Formal
    path('ventas/', views.lista_ventas, name='lista_ventas'),
    path('corte-caja/', views.corte_caja_view, name='corte_caja'),
    path('corte-caja/efectuar/', views.efectuar_cierre_caja, name='efectuar_cierre_caja'),
    path('corte-caja/imprimir/<int:corte_id>/', views.imprimir_corte_ticket, name='imprimir_corte_ticket'),

    # Ticket de Venta
    path('ventas/ticket/<int:venta_id>/', views.imprimir_ticket_venta, name='imprimir_ticket_venta'),

    # Cotizaciones
    path('cotizacion/guardar/', views.guardar_cotizacion, name='guardar_cotizacion'),
    path('cotizaciones/', views.lista_cotizaciones, name='lista_cotizaciones'),
    path('cotizaciones/imprimir/<int:cotizacion_id>/', views.generar_cotizacion_pdf, name='generar_cotizacion_pdf'),
    path('cotizaciones/cargar-pos/<int:cotizacion_id>/', views.cargar_cotizacion_pos, name='cargar_cotizacion_pos'),

    # Administración Interna y Descuentos Dinámicos
    path('usuarios/', views.lista_usuarios, name='lista_usuarios'),
    path('usuarios/crear/', views.crear_usuario, name='crear_usuario'),
    path('usuarios/editar/<int:usuario_id>/', views.editar_usuario, name='editar_usuario'),
    path('auditoria/', views.lista_auditoria, name='lista_auditoria'),
    path('administracion/descuentos/', views.gestion_descuentos, name='gestion_descuentos'),
]