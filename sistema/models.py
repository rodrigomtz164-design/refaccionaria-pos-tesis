from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone
from datetime import timedelta

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
    sku = models.CharField(max_length=50, unique=True, null=True, blank=True)
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField(blank=True, null=True)
    
    categoria = models.ForeignKey(Categoria, on_delete=models.PROTECT, related_name='productos')
    proveedor = models.ForeignKey(Proveedor, on_delete=models.SET_NULL, null=True, blank=True)
    
    aplicaciones = models.ManyToManyField(ModeloAuto, blank=True, related_name='productos_compatibles')

    precio_costo = models.DecimalField(max_digits=10, decimal_places=2)
    precio_venta = models.DecimalField(max_digits=10, decimal_places=2)
    
    stock_actual = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    stock_minimo = models.DecimalField(max_digits=10, decimal_places=2, default=5.00, help_text="Alerta de stock bajo")
    
    es_granel = models.BooleanField(default=False, help_text="Marcar si se vende suelto/granel sin código")
    unidad_medida = models.CharField(max_length=20, default='Pieza', help_text="Ej. Pieza, Litro, Metro")
    
    activo = models.BooleanField(default=True, help_text="Permite pausar o reactivar el producto en el POS sin borrar su historial")
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        estado_str = "" if self.activo else " [INACTIVO]"
        return f"{self.sku or 'SIN-SKU'} - {self.nombre}{estado_str}"


class ListaPrecioProveedor(models.Model):
    proveedor_negocio = models.CharField(max_length=150, help_text="Ej. Honda Central, AutoZone Sur, Refaccionaria El Pistón")
    codigo_refaccion = models.CharField(max_length=100, blank=True, null=True)
    nombre_refaccion = models.CharField(max_length=200)
    precio_referencia = models.DecimalField(max_digits=10, decimal_places=2)
    telefono_contacto = models.CharField(max_length=30, blank=True, null=True)
    notas = models.TextField(blank=True, null=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.nombre_refaccion} (${self.precio_referencia}) - {self.proveedor_negocio}"


# ==========================================
# 4. DESCUENTOS CONFIGURABLES POR ADMIN
# ==========================================
class DescuentoConfig(models.Model):
    nombre = models.CharField(max_length=50, help_text="Ej. Descuento Mostrador, Amigo Mecánico")
    porcentaje = models.IntegerField(help_text="Porcentaje entero: 2, 5, 8, 10, 15...")
    activo = models.BooleanField(default=True)

    class Meta:
        ordering = ['porcentaje']

    def __str__(self):
        return f"{self.nombre} ({self.porcentaje}%)"


# ==========================================
# 5. CORTES DE CAJA, VENTAS Y AUDITORÍA
# ==========================================
class CorteCaja(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.PROTECT, related_name='cortes_realizados')
    fecha_cierre = models.DateTimeField(auto_now_add=True)
    total_cobrado = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    num_ventas = models.IntegerField(default=0)
    observaciones = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Corte #{self.id} - {self.fecha_cierre.strftime('%d/%m/%Y %H:%M')} por {self.usuario.username} (${self.total_cobrado})"


class Venta(models.Model):
    METODOS_PAGO = [
        ('EFECTIVO', 'Efectivo'),
        ('TARJETA', 'Tarjeta'),
        ('TRANSFERENCIA', 'Transferencia'),
    ]

    vendedor = models.ForeignKey(Usuario, on_delete=models.PROTECT, related_name='ventas')
    corte = models.ForeignKey(CorteCaja, on_delete=models.SET_NULL, null=True, blank=True, related_name='ventas_incluidas')
    fecha_venta = models.DateTimeField(auto_now_add=True)
    descuento_aplicado = models.DecimalField(max_digits=4, decimal_places=2, default=0.00)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    metodo_pago = models.CharField(max_length=20, choices=METODOS_PAGO, default='EFECTIVO', null=True, blank=True)

    def __str__(self):
        return f"Venta #{self.id} - {self.fecha_venta.strftime('%Y-%m-%d %H:%M')} ({self.metodo_pago or 'EFECTIVO'})"


class DetalleVenta(models.Model):
    venta = models.ForeignKey(Venta, on_delete=models.CASCADE, related_name='detalles')
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    cantidad = models.DecimalField(max_digits=10, decimal_places=2)
    precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.cantidad} x {self.producto.nombre} en Venta #{self.venta.id}"


class Cotizacion(models.Model):
    ESTADOS = [
        ('PENDIENTE', 'Pendiente'),
        ('CONVERTIDA', 'Convertida a Venta'),
        ('VENCIDA', 'Vencida'),
    ]

    vendedor = models.ForeignKey(Usuario, on_delete=models.PROTECT, related_name='cotizaciones')
    cliente_nombre = models.CharField(max_length=150, blank=True, null=True, default='Cliente Mostrador')
    cliente_telefono = models.CharField(max_length=20, blank=True, null=True)
    cliente_email = models.EmailField(blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    estado = models.CharField(max_length=20, choices=ESTADOS, default='PENDIENTE')

    @property
    def es_valida(self):
        return timezone.now() <= (self.fecha_creacion + timedelta(hours=24))

    def __str__(self):
        return f"Cotización #{self.id} - {self.cliente_nombre or 'Cliente Mostrador'}"


class DetalleCotizacion(models.Model):
    cotizacion = models.ForeignKey(Cotizacion, on_delete=models.CASCADE, related_name='detalles')
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    cantidad = models.DecimalField(max_digits=10, decimal_places=2)
    precio_cotizado = models.DecimalField(max_digits=10, decimal_places=2)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.cantidad} x {self.producto.nombre} en Cotización #{self.cotizacion.id}"


class LogAuditoria(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True)
    accion = models.CharField(max_length=255)
    fecha_hora = models.DateTimeField(auto_now_add=True)
    detalles = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"[{self.fecha_hora.strftime('%Y-%m-%d %H:%M')}] {self.usuario}: {self.accion}"