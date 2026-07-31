import os
import django

# Configuración del entorno de Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'refaccionaria_core.settings')
django.setup()

from sistema.models import Categoria, MarcaAuto, ModeloAuto, Proveedor, Producto

def poblar_datos():
    print("Iniciando la carga de datos de prueba...")

    # 1. Crear Categorías
    cat_frenos, _ = Categoria.objects.get_or_create(nombre="Frenos", descripcion="Balatas, discos, tambores")
    cat_aceites, _ = Categoria.objects.get_or_create(nombre="Aceites y Fluídos", descripcion="Aceites de motor, anticongelantes, granel")
    cat_filtros, _ = Categoria.objects.get_or_create(nombre="Filtros", descripcion="Filtros de aire, aceite y gasolina")

    # 2. Crear Marcas y Modelos de Auto
    marca_nissan, _ = MarcaAuto.objects.get_or_create(nombre="Nissan")
    marca_chevy, _ = MarcaAuto.objects.get_or_create(nombre="Chevrolet")

    modelo_tsuru, _ = ModeloAuto.objects.get_or_create(
        marca=marca_nissan, nombre="Tsuru III", anio_inicio=1992, anio_fin=2017
    )
    modelo_aveo, _ = ModeloAuto.objects.get_or_create(
        marca=marca_chevy, nombre="Aveo", anio_inicio=2008, anio_fin=2018
    )

    # 3. Crear Proveedor
    prov_gonher, _ = Proveedor.objects.get_or_create(
        nombre="Distribuidora Gonher", telefono="5551234567", email="contacto@gonher.com"
    )

    # 4. Crear Productos de Prueba

    # Producto 1: Pieza normal con compatibilidad (Balatas)
    prod1, creado1 = Producto.objects.get_or_create(
        sku="BAL-TSU-01",
        defaults={
            'nombre': "Balatas Delanteras Tsuru III",
            'descripcion': "Juego de balatas cerámicas delanteras",
            'categoria': cat_frenos,
            'proveedor': prov_gonher,
            'precio_costo': 180.00,
            'precio_venta': 280.00,
            'stock_actual': 12.00,
            'stock_minimo': 3.00,
            'es_granel': False,
            'unidad_medida': 'Pieza'
        }
    )
    if creado1:
        prod1.aplicaciones.add(modelo_tsuru)

    # Producto 2: Producto a Granel (Aceite por litro)
    prod2, creado2 = Producto.objects.get_or_create(
        sku=None, # Sin SKU por ser a granel/suelto
        nombre="Aceite 20W-50 Multigrado (Suelto/Granel)",
        defaults={
            'descripcion': "Aceite de motor despachado por litro",
            'categoria': cat_aceites,
            'proveedor': prov_gonher,
            'precio_costo': 45.00,
            'precio_venta': 75.00,
            'stock_actual': 50.50, # 50.5 Litros
            'stock_minimo': 10.00,
            'es_granel': True,
            'unidad_medida': 'Litro'
        }
    )

    # Producto 3: Producto con Stock Bajo (Alerta de Inventario)
    prod3, creado3 = Producto.objects.get_or_create(
        sku="FIL-AVE-99",
        defaults={
            'nombre': "Filtro de Aceite Aveo 1.6L",
            'descripcion': "Filtro blindado de aceite sintético",
            'categoria': cat_filtros,
            'proveedor': prov_gonher,
            'precio_costo': 50.00,
            'precio_venta': 95.00,
            'stock_actual': 2.00, # Stock por debajo del mínimo (Alerta)
            'stock_minimo': 5.00,
            'es_granel': False,
            'unidad_medida': 'Pieza'
        }
    )
    if creado3:
        prod3.aplicaciones.add(modelo_aveo)

    print("¡Datos de prueba cargados exitosamente!")

if __name__ == '__main__':
    poblar_datos()