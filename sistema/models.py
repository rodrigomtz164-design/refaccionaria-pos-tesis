from django.db import models
from django.contrib.auth.models import AbstractUser

# ==========================================
# 1. USUARIOS Y ROLES (Admin, Seller, Stocker)
# ==========================================
class Rol(models.Model):
    nombre = models.CharField(max_length=50, unique=True)
    descripcion = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.nombre


class Usuario(AbstractUser):
    rol = models.ForeignKey(Rol, on_delete=models.PROTECT, null=True, blank=True)
    telefono = models.CharField(max_length=15, blank=True, null=True)

    # Evita el choque de permisos con el usuario por defecto de Django
    groups = models.ManyToManyField(
        'auth.Group',
        related_name='usuario_set',
        blank=True,
        help_text='Los grupos a los que pertenece este usuario.'
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='usuario_set_permissions',
        blank=True,
        help_text='Permisos específicos para este usuario.'
    )

    def __str__(self):
        return f"{self.username} - {self.rol.nombre if self.rol else 'Sin Rol'}"

# ==========================================
# 2. CLASIFICACIÓN DE AUTOS Y REFACCIONES
# ==========================================
class Categoria(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    descripcion = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.nombre


class MarcaAuto(models.Model):
    nombre = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.nombre


class ModeloAuto(models.Model):
    marca = models.ForeignKey(MarcaAuto, on_delete=models.CASCADE, related_name='modelos')
    nombre = models.CharField(max_length=100)
    anio_inicio = models.IntegerField(help_text="Año inicial de compatibilidad (ej. 2010)")
    anio_fin = models.IntegerField(help_text="Año final de compatibilidad (ej. 2015)")

    class Meta:
        unique_together = ('marca', 'nombre', 'anio_inicio', 'anio_fin')

    def __str__(self):
        return f"{self.marca.nombre} {self.nombre} ({self.anio_inicio}-{self.anio_fin})"


class Proveedor(models.Model):
    nombre = models.CharField(max_length=150)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    direccion = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.nombre


# ==========================================
# 3. INVENTARIO / PRODUCTOS (REFACCIONES)
# ==========================================
class Producto(models.Model):
    # SKU / Código de barras (Alfanumérico personalizado, permite nulos para venta a granel)
    sku = models.CharField(max_length=50, unique=True, null=True, blank=True)
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField(blank=True, null=True)
    
    categoria = models.ForeignKey(Categoria, on_delete=models.PROTECT, related_name='productos')
    proveedor = models.ForeignKey(Proveedor, on_delete=models.SET_NULL, null=True, blank=True)
    
    # Compatibilidad con múltiples vehículos
    aplicaciones = models.ManyToManyField(ModeloAuto, blank=True, related_name='productos_compatibles')

    precio_costo = models.DecimalField(max_digits=10, decimal_places=2)
    precio_venta = models.DecimalField(max_digits=10, decimal_places=2)
    
    # Soporte para decimales en ventas a granel (litros, metros, etc.)
    stock_actual = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    stock_minimo = models.DecimalField(max_digits=10, decimal_places=2, default=5.00, help_text="Alerta de stock bajo")
    
    es_granel = models.BooleanField(default=False, help_text="Marcar si se vende suelto/granel sin código")
    unidad_medida = models.CharField(max_length=20, default='Pieza', help_text="Ej. Pieza, Litro, Metro")
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sku or 'SIN-SKU'} - {self.nombre}"


# ==========================================
# 4. VENTAS, COTIZACIONES Y AUDITORÍA
# ==========================================
class Venta(models.Model):
    NIVELES_DESCUENTO = [
        (0.00, 'Sin Descuento (0%)'),
        (0.02, 'Nivel 1 (2%)'),
        (0.05, 'Nivel 2 (5%)'),
        (0.08, 'Nivel 3 (8%)'),
    ]

    vendedor = models.ForeignKey(Usuario, on_delete=models.PROTECT, related_name='ventas')
    fecha_venta = models.DateTimeField(auto_now_add=True)
    descuento_aplicado = models.DecimalField(max_digits=4, decimal_places=2, choices=NIVELES_DESCUENTO, default=0.00)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f"Venta #{self.id} - {self.fecha_venta.strftime('%Y-%m-%d %H:%M')}"


class DetalleVenta(models.Model):
    venta = models.ForeignKey(Venta, on_delete=models.CASCADE, related_name='detalles')
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    cantidad = models.DecimalField(max_digits=10, decimal_places=2)
    precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.cantidad} x {self.producto.nombre} en Venta #{self.venta.id}"


class Cotizacion(models.Model):
    vendedor = models.ForeignKey(Usuario, on_delete=models.PROTECT)
    cliente_nombre = models.CharField(max_length=150, blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f"Cotización #{self.id} - {self.cliente_nombre or 'Cliente Mostrador'}"


class LogAuditoria(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True)
    accion = models.CharField(max_length=255)
    fecha_hora = models.DateTimeField(auto_now_add=True)
    detalles = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"[{self.fecha_hora.strftime('%Y-%m-%d %H:%M')}] {self.usuario}: {self.accion}"