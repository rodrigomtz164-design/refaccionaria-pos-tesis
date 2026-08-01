import json
from decimal import Decimal
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.db.models import Q
from django.http import JsonResponse, HttpResponse
from django.db import transaction
from django.utils import timezone
from datetime import timedelta

from .models import (
    Producto, Categoria, MarcaAuto, ModeloAuto, 
    Venta, DetalleVenta, Cotizacion, DetalleCotizacion, LogAuditoria
)

@login_required
def dashboard(request):
    """
    Redirige al panel correspondiente según el rol del usuario logueado.
    """
    usuario = request.user
    
    if usuario.rol and usuario.rol.nombre == 'Administrador':
        return render(request, 'sistema/dashboard_admin.html')
    elif usuario.rol and usuario.rol.nombre == 'Almacenista':
        return render(request, 'sistema/dashboard_almacen.html')
    elif usuario.rol and usuario.rol.nombre == 'Vendedor':
        return render(request, 'sistema/dashboard_ventas.html')
    else:
        return render(request, 'sistema/dashboard_admin.html')


@login_required
def lista_productos(request):
    """
    Muestra la tabla general de productos con filtros dinámicos por SKU/nombre,
    categoría, marca y modelo de auto.
    """
    productos = Producto.objects.select_related('categoria', 'proveedor').prefetch_related('aplicaciones__marca').all()

    query = request.GET.get('q', '').strip()
    categoria_id = request.GET.get('categoria', '')
    marca_id = request.GET.get('marca', '')

    if query:
        productos = productos.filter(
            Q(sku__icontains=query) | Q(nombre__icontains=query)
        )

    if categoria_id:
        productos = productos.filter(categoria_id=categoria_id)

    if marca_id:
        productos = productos.filter(aplicaciones__marca_id=marca_id).distinct()

    categorias = Categoria.objects.all()
    marcas = MarcaAuto.objects.all()

    context = {
        'productos': productos,
        'categorias': categorias,
        'marcas': marcas,
        'query': query,
        'categoria_id': categoria_id,
        'marca_id': marca_id,
    }
    return render(request, 'sistema/lista_productos.html', context)


@login_required
def pos_ventas(request):
    """
    Vista principal para el Punto de Venta (POS) / Caja Mostrador.
    """
    productos = Producto.objects.filter(stock_actual__gt=0).select_related('categoria').prefetch_related('aplicaciones__marca')
    categorias = Categoria.objects.all()
    marcas = MarcaAuto.objects.all()

    context = {
        'productos': productos,
        'categorias': categorias,
        'marcas': marcas,
    }
    return render(request, 'sistema/pos_ventas.html', context)


@login_required
def procesar_venta(request):
    """
    Procesa el cobro de la venta: descuenta el inventario en MySQL,
    marcar la cotización como CONVERTIDA (si aplica) y guarda en auditoría.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            carrito = data.get('carrito', [])
            porcentaje_descuento = float(data.get('descuento', 0))
            paga_con = Decimal(str(data.get('paga_con', 0)))
            cotizacion_id = data.get('cotizacion_id', None)

            if not carrito:
                return JsonResponse({'success': False, 'message': 'La nota de venta está vacía.'})

            descuento_decimal = Decimal(str(porcentaje_descuento / 100))

            with transaction.atomic():
                subtotal_venta = Decimal('0.00')
                items_a_procesar = []

                for item in carrito:
                    producto = Producto.objects.select_for_update().get(id=item['id'])
                    cant = Decimal(str(item['cantidad']))

                    if producto.stock_actual < cant:
                        raise Exception(f'Stock insuficiente para: {producto.nombre}. Disponible: {producto.stock_actual}')

                    precio_unitario = Decimal(str(item['precio']))
                    subtotal_item = precio_unitario * cant
                    subtotal_venta += subtotal_item

                    items_a_procesar.append({
                        'producto': producto,
                        'cantidad': cant,
                        'precio_unitario': precio_unitario,
                        'subtotal': subtotal_item
                    })

                monto_descuento = subtotal_venta * descuento_decimal
                total_venta = subtotal_venta - monto_descuento

                venta = Venta.objects.create(
                    vendedor=request.user,
                    descuento_aplicado=descuento_decimal,
                    subtotal=subtotal_venta,
                    total=total_venta
                )

                for item in items_a_procesar:
                    DetalleVenta.objects.create(
                        venta=venta,
                        producto=item['producto'],
                        cantidad=item['cantidad'],
                        precio_unitario=item['precio_unitario'],
                        subtotal=item['subtotal']
                    )

                    item['producto'].stock_actual -= item['cantidad']
                    item['producto'].save()

                # Si la venta proviene de una cotización, la marcamos como CONVERTIDA
                if cotizacion_id:
                    try:
                        cot = Cotizacion.objects.get(id=cotizacion_id)
                        cot.estado = 'CONVERTIDA'
                        cot.save()
                    except Cotizacion.DoesNotExist:
                        pass

                LogAuditoria.objects.create(
                    usuario=request.user,
                    accion=f"Venta registrada #{venta.id}",
                    detalles=f"Total: ${total_venta:.2f} | Descuento: {porcentaje_descuento}%"
                )

            return JsonResponse({
                'success': True, 
                'venta_id': venta.id, 
                'paga_con': float(paga_con),
                'cambio': float(paga_con - total_venta),
                'message': '¡Venta realizada con éxito!'
            })

        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

    return JsonResponse({'success': False, 'message': 'Método no permitido.'})


@login_required
def editar_producto(request, producto_id):
    """
    Permite al Almacenista / Administrador actualizar en tiempo real
    el precio de venta y stock disponible de un producto.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            producto = Producto.objects.get(id=producto_id)

            nuevo_precio = Decimal(str(data.get('precio_venta', producto.precio_venta)))
            nuevo_stock = Decimal(str(data.get('stock_actual', producto.stock_actual)))
            
            precio_anterior = producto.precio_venta
            stock_anterior = producto.stock_actual

            producto.precio_venta = nuevo_precio
            producto.stock_actual = nuevo_stock
            producto.save()

            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Edición de Producto #{producto.id} ({producto.sku or 'GRANEL'})",
                detalles=f"Precio: ${precio_anterior} -> ${nuevo_precio} | Stock: {stock_anterior} -> {nuevo_stock}"
            )

            return JsonResponse({'success': True, 'message': 'Producto actualizado correctamente.'})

        except Producto.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'El producto no existe.'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

    return JsonResponse({'success': False, 'message': 'Método no permitido.'})


# ==========================================
# VISTAS DE COTIZACIONES Y TICKETS
# ==========================================

@login_required
def guardar_cotizacion(request):
    """
    Guarda una cotización generada desde el POS sin descontar inventario.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            carrito = data.get('carrito', [])
            cliente_nombre = data.get('cliente_nombre', 'Cliente Mostrador').strip() or 'Cliente Mostrador'
            cliente_telefono = data.get('cliente_telefono', '').strip()

            if not carrito:
                return JsonResponse({'success': False, 'message': 'La cotización no puede estar vacía.'})

            with transaction.atomic():
                subtotal_cotizacion = Decimal('0.00')
                detalles_a_crear = []

                for item in carrito:
                    producto = Producto.objects.get(id=item['id'])
                    cant = Decimal(str(item['cantidad']))
                    precio = Decimal(str(item['precio']))
                    subtotal_item = cant * precio
                    subtotal_cotizacion += subtotal_item

                    detalles_a_crear.append({
                        'producto': producto,
                        'cantidad': cant,
                        'precio_cotizado': precio,
                        'subtotal': subtotal_item
                    })

                cotizacion = Cotizacion.objects.create(
                    vendedor=request.user,
                    cliente_nombre=cliente_nombre,
                    cliente_telefono=cliente_telefono,
                    subtotal=subtotal_cotizacion,
                    total=subtotal_cotizacion,
                    estado='PENDIENTE'
                )

                for d in detalles_a_crear:
                    DetalleCotizacion.objects.create(
                        cotizacion=cotizacion,
                        producto=d['producto'],
                        cantidad=d['cantidad'],
                        precio_cotizado=d['precio_cotizado'],
                        subtotal=d['subtotal']
                    )

                LogAuditoria.objects.create(
                    usuario=request.user,
                    accion=f"Cotización generada #{cotizacion.id}",
                    detalles=f"Cliente: {cliente_nombre} | Total: ${subtotal_cotizacion:.2f}"
                )

            return JsonResponse({'success': True, 'cotizacion_id': cotizacion.id, 'message': 'Cotización guardada exitosamente.'})

        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

    return JsonResponse({'success': False, 'message': 'Método no permitido.'})


@login_required
def lista_cotizaciones(request):
    """
    Muestra la lista de cotizaciones registradas con sus respectivos estados y vigencia.
    """
    cotizaciones = Cotizacion.objects.select_related('vendedor').prefetch_related('detalles').order_by('-fecha_creacion')
    
    query = request.GET.get('q', '').strip()
    if query:
        cotizaciones = cotizaciones.filter(
            Q(id__icontains=query) | Q(cliente_nombre__icontains=query)
        )

    ahora = timezone.now()
    for cot in cotizaciones:
        if cot.estado == 'PENDIENTE' and ahora > (cot.fecha_creacion + timedelta(hours=24)):
            cot.estado = 'VENCIDA'
            cot.save(update_fields=['estado'])

    context = {
        'cotizaciones': cotizaciones,
        'query': query
    }
    return render(request, 'sistema/lista_cotizaciones.html', context)


@login_required
def generar_cotizacion_pdf(request, cotizacion_id):
    """
    Renderiza la vista previa oficial para impresión o descarga PDF de la cotización.
    """
    cotizacion = get_object_or_404(Cotizacion.objects.prefetch_related('detalles__producto'), id=cotizacion_id)
    fecha_expiracion = cotizacion.fecha_creacion + timedelta(hours=24)

    context = {
        'cotizacion': cotizacion,
        'fecha_expiracion': fecha_expiracion,
    }
    return render(request, 'sistema/cotizacion_pdf.html', context)


@login_required
def cargar_cotizacion_pos(request, cotizacion_id):
    """
    Recupera una cotización y devuelve sus items con los PRECIOS VIGENTES DEL DÍA
    para ser cargados en el Punto de Venta.
    """
    try:
        cotizacion = get_object_or_404(Cotizacion.objects.prefetch_related('detalles__producto'), id=cotizacion_id)
        
        if not cotizacion.es_valida:
            return JsonResponse({
                'success': False, 
                'message': 'Esta cotización ha superado las 24 horas de vigencia y está vencida.'
            })

        items = []
        hubo_cambio_precio = False

        for det in cotizacion.detalles.all():
            prod = det.producto
            precio_actual = prod.precio_venta
            
            if precio_actual != det.precio_cotizado:
                hubo_cambio_precio = True

            items.append({
                'id': prod.id,
                'sku': prod.sku or 'SIN-SKU',
                'nombre': prod.nombre,
                'precio': float(precio_actual),
                'precio_original_cotizado': float(det.precio_cotizado),
                'cantidad': float(det.cantidad),
                'stock_disponible': float(prod.stock_actual),
                'es_granel': prod.es_granel,
                'unidad_medida': prod.unidad_medida
            })

        return JsonResponse({
            'success': True,
            'cotizacion_id': cotizacion.id,
            'cliente_nombre': cotizacion.cliente_nombre,
            'items': items,
            'hubo_cambio_precio': hubo_cambio_precio
        })

    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})


@login_required
def imprimir_ticket_venta(request, venta_id):
    """
    Renderiza la plantilla en formato de Ticket de Venta Térmico para su impresión directa.
    """
    venta = get_object_or_404(Venta.objects.prefetch_related('detalles__producto').select_related('vendedor'), id=venta_id)
    
    paga_con = request.GET.get('paga_con', Decimal('0.00'))
    try:
        paga_con = Decimal(str(paga_con))
    except:
        paga_con = venta.total

    cambio = paga_con - venta.total if paga_con >= venta.total else Decimal('0.00')

    context = {
        'venta': venta,
        'paga_con': paga_con,
        'cambio': cambio,
    }
    return render(request, 'sistema/ticket_venta.html', context)