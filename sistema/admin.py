from django.contrib import admin
from .models import (
    Rol, Usuario, Categoria, Proveedor, MarcaAuto, 
    ModeloAuto, Producto, Venta, DetalleVenta, 
    Cotizacion, LogAuditoria
)

@admin.register(Rol)
class RolAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'descripcion')

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'rol', 'is_staff', 'is_active')
    list_filter = ('rol', 'is_staff', 'is_active')

@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'descripcion')

@admin.register(Proveedor)
class ProveedorAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'telefono', 'email')

@admin.register(MarcaAuto)
class MarcaAutoAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre')

@admin.register(ModeloAuto)
class ModeloAutoAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'marca', 'anio_inicio', 'anio_fin')
    list_filter = ('marca',)

@admin.register(Producto)
class ProductoAdmin(admin.ModelAdmin):
    list_display = ('sku', 'nombre', 'categoria', 'precio_venta', 'stock_actual', 'es_granel')
    list_filter = ('categoria', 'es_granel')
    search_fields = ('sku', 'nombre', 'codigo_barras')

admin.site.register(Venta)
admin.site.register(DetalleVenta)
admin.site.register(Cotizacion)
admin.site.register(LogAuditoria)