import json
from decimal import Decimal
from datetime import datetime, time, timedelta
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.db.models import Q, Sum, F
from django.http import JsonResponse, HttpResponse
from django.db import transaction
from django.utils import timezone

from .models import (
    Producto, Categoria, MarcaAuto, ModeloAuto, 
    Venta, DetalleVenta, Cotizacion, DetalleCotizacion, LogAuditoria, Usuario, Rol
)
from .decorators import admin_required, almacen_required, vendedor_required


def get_rango_dia_local():
    """Devuelve el inicio y fin del día actual en hora local exacta para evitar fallos de timezone con MySQL."""
    ahora_local = timezone.localtime(timezone.now())
    inicio_dia = timezone.make_aware(datetime.combine(ahora_local.date(), time.min))
    fin_dia = timezone.make_aware(datetime.combine(ahora_local.date(), time.max))
    return inicio_dia, fin_dia, ahora_local.date()


@login_required
def dashboard(request):
    usuario = request.user
    if usuario.rol and usuario.rol.nombre == 'Administrador':
        return dashboard_admin(request)
    elif usuario.rol and usuario.rol.nombre == 'Almacenista':
        return dashboard_almacen(request)
    elif usuario.rol and usuario.rol.nombre == 'Vendedor':
        return dashboard_ventas(request)
    else:
        return dashboard_admin(request)


@admin_required
def dashboard_admin(request):
    inicio_dia, fin_dia, hoy = get_rango_dia_local()
    
    # Rango exacto de ventas de HOY
    ventas_hoy_qs = Venta.objects.filter(fecha_venta__range=(inicio_dia, fin_dia))
    total_ventas_hoy = ventas_hoy_qs.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_ventas_hoy = ventas_hoy_qs.count()
    
    productos_bajo_stock = Producto.objects.filter(stock_actual__lte=F('stock_minimo'))
    cant_bajo_stock = productos_bajo_stock.count()
    cotizaciones_mes = Cotizacion.objects.count()

    # Gráfica de Ventas
    ventas_recientes = Venta.objects.order_by('-fecha_venta')[:10]
    labels_ventas = [timezone.localtime(v.fecha_venta).strftime("%H:%M") for v in reversed(ventas_recientes)]
    data_ventas = [float(v.total) for v in reversed(ventas_recientes)]

    context = {
        'total_ventas_hoy': total_ventas_hoy,
        'num_ventas_hoy': num_ventas_hoy,
        'cant_bajo_stock': cant_bajo_stock,
        'cotizaciones_mes': cotizaciones_mes,
        'productos_bajo_stock': productos_bajo_stock,
        'labels_ventas': json.dumps(labels_ventas),
        'data_ventas': json.dumps(data_ventas),
    }
    return render(request, 'sistema/dashboard_admin.html', context)


@almacen_required
def dashboard_almacen(request):
    total_productos = Producto.objects.count()
    productos_bajo = Producto.objects.filter(stock_actual__lte=F('stock_minimo')).select_related('categoria')
    total_stock_bajo = productos_bajo.count()

    categorias = Categoria.objects.all()
    cat_nombres = []
    cat_cantidades = []

    for cat in categorias:
        count = Producto.objects.filter(categoria=cat).count()
        if count > 0:
            cat_nombres.append(cat.nombre)
            cat_cantidades.append(count)

    context = {
        'total_productos': total_productos,
        'total_stock_bajo': total_stock_bajo,
        'productos_bajo': productos_bajo,
        'cat_nombres': json.dumps(cat_nombres),
        'cat_cantidades': json.dumps(cat_cantidades),
        'categorias': categorias,
    }
    return render(request, 'sistema/dashboard_almacen.html', context)


@vendedor_required
def dashboard_ventas(request):
    inicio_dia, fin_dia, hoy = get_rango_dia_local()
    
    ventas_hoy = Venta.objects.filter(vendedor=request.user, fecha_venta__range=(inicio_dia, fin_dia)).order_by('fecha_venta')
    total_monto_hoy = ventas_hoy.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_ventas_hoy = ventas_hoy.count()
    
    cotizaciones_vendedor = Cotizacion.objects.filter(vendedor=request.user).count()

    labels_ventas_turno = [timezone.localtime(v.fecha_venta).strftime("%H:%M") for v in ventas_hoy]
    data_ventas_turno = [float(v.total) for v in ventas_hoy]

    context = {
        'total_monto_hoy': total_monto_hoy,
        'num_ventas_hoy': num_ventas_hoy,
        'cotizaciones_vendedor': cotizaciones_vendedor,
        'labels_ventas_turno': json.dumps(labels_ventas_turno),
        'data_ventas_turno': json.dumps(data_ventas_turno),
    }
    return render(request, 'sistema/dashboard_ventas.html', context)


@almacen_required
def lista_productos(request):
    if request.method == 'POST':
        try:
            sku = request.POST.get('sku', '').strip()
            nombre = request.POST.get('nombre', '').strip()
            categoria_id = request.POST.get('categoria')
            precio_venta = Decimal(request.POST.get('precio_venta', '0'))
            stock_actual = Decimal(request.POST.get('stock_actual', '0'))
            stock_minimo = Decimal(request.POST.get('stock_minimo', '5'))
            es_granel = request.POST.get('es_granel') == '1'
            unidad_medida = request.POST.get('unidad_medida', 'Pieza').strip()

            categoria = Categoria.objects.get(id=categoria_id) if categoria_id else None

            nuevo_prod = Producto.objects.create(
                sku=sku or None,
                nombre=nombre,
                categoria=categoria,
                precio_venta=precio_venta,
                stock_actual=stock_actual,
                stock_minimo=stock_minimo,
                es_granel=es_granel,
                unidad_medida=unidad_medida
            )

            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Alta de Producto #{nuevo_prod.id}",
                detalles=f"Producto '{nombre}' (SKU: {sku}) creado con stock {stock_actual} {unidad_medida}"
            )
            return redirect('lista_productos')
        except Exception:
            pass

    productos = Producto.objects.select_related('categoria', 'proveedor').prefetch_related('aplicaciones__marca').all()

    query = request.GET.get('q', '').strip()
    categoria_id = request.GET.get('categoria', '')
    marca_id = request.GET.get('marca', '')
    filtro = request.GET.get('filtro', '')

    if filtro == 'stock_bajo':
        productos = productos.filter(stock_actual__lte=F('stock_minimo'))

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
        'filtro': filtro,
    }
    return render(request, 'sistema/lista_productos.html', context)


@vendedor_required
def pos_ventas(request):
    productos = Producto.objects.filter(stock_actual__gt=0).select_related('categoria').prefetch_related('aplicaciones__marca')
    categorias = Categoria.objects.all()
    marcas = MarcaAuto.objects.all()

    context = {
        'productos': productos,
        'categorias': categorias,
        'marcas': marcas,
    }
    return render(request, 'sistema/pos_ventas.html', context)


@vendedor_required
def procesar_venta(request):
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

                # Marca la cotización como CONVERTIDA de manera explícita
                if cotizacion_id:
                    try:
                        cot = Cotizacion.objects.get(id=int(cotizacion_id))
                        cot.estado = 'CONVERTIDA'
                        cot.save(update_fields=['estado'])
                    except (Cotizacion.DoesNotExist, ValueError, TypeError):
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


@almacen_required
def editar_producto(request, producto_id):
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


@vendedor_required
def lista_ventas(request):
    """ Historial completo de ventas con opción de consultar/imprimir cada ticket """
    ventas = Venta.objects.select_related('vendedor').prefetch_related('detalles__producto').order_by('-fecha_venta')
    
    query = request.GET.get('q', '').strip()
    fecha_filtro = request.GET.get('fecha', '').strip()

    if query:
        ventas = ventas.filter(
            Q(id__icontains=query) | Q(vendedor__username__icontains=query)
        )

    if fecha_filtro:
        try:
            fecha_obj = datetime.strptime(fecha_filtro, "%Y-%m-%d").date()
            inicio = timezone.make_aware(datetime.combine(fecha_obj, time.min))
            fin = timezone.make_aware(datetime.combine(fecha_obj, time.max))
            ventas = ventas.filter(fecha_venta__range=(inicio, fin))
        except ValueError:
            pass

    context = {
        'ventas': ventas,
        'query': query,
        'fecha_filtro': fecha_filtro,
    }
    return render(request, 'sistema/lista_ventas.html', context)


@vendedor_required
def corte_caja_view(request):
    inicio_dia, fin_dia, hoy = get_rango_dia_local()
    
    ventas_turno = Venta.objects.filter(fecha_venta__range=(inicio_dia, fin_dia)).order_by('-fecha_venta')
    cotizaciones_turno = Cotizacion.objects.filter(fecha_creacion__range=(inicio_dia, fin_dia)).count()

    total_cobrado = ventas_turno.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_notas = ventas_turno.count()

    context = {
        'total_cobrado': total_cobrado,
        'num_notas': num_notas,
        'cotizaciones_turno': cotizaciones_turno,
        'ventas_turno': ventas_turno,
        'fecha_corte': hoy,
    }
    return render(request, 'sistema/corte_caja.html', context)


@vendedor_required
def guardar_cotizacion(request):
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


@vendedor_required
def lista_cotizaciones(request):
    cotizaciones = Cotizacion.objects.select_related('vendedor').prefetch_related('detalles').exclude(estado__in=['CONVERTIDA', 'PROCESADA']).order_by('-fecha_creacion')
    
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


@vendedor_required
def generar_cotizacion_pdf(request, cotizacion_id):
    cotizacion = get_object_or_404(Cotizacion.objects.prefetch_related('detalles__producto'), id=cotizacion_id)
    fecha_expiracion = cotizacion.fecha_creacion + timedelta(hours=24)

    context = {
        'cotizacion': cotizacion,
        'fecha_expiracion': fecha_expiracion,
    }
    return render(request, 'sistema/cotizacion_pdf.html', context)


@vendedor_required
def cargar_cotizacion_pos(request, cotizacion_id):
    try:
        cotizacion = get_object_or_404(Cotizacion.objects.prefetch_related('detalles__producto'), id=cotizacion_id)
        
        if cotizacion.estado in ['CONVERTIDA', 'PROCESADA']:
            return JsonResponse({
                'success': False, 
                'message': 'Esta cotización ya fue convertida en una venta anterior.'
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


@vendedor_required
def imprimir_ticket_venta(request, venta_id):
    venta = get_object_or_404(Venta.objects.prefetch_related('detalles__producto').select_related('vendedor'), id=venta_id)
    
    paga_con = request.GET.get('paga_con', Decimal('0.00'))
    try:
        paga_con = Decimal(str(paga_con))
    except Exception:
        paga_con = venta.total

    cambio = paga_con - venta.total if paga_con >= venta.total else Decimal('0.00')

    context = {
        'venta': venta,
        'paga_con': paga_con,
        'cambio': cambio,
    }
    return render(request, 'sistema/ticket_venta.html', context)


@admin_required
def lista_usuarios(request):
    usuarios = Usuario.objects.select_related('rol').all()
    return render(request, 'sistema/lista_usuarios.html', {'usuarios': usuarios})


@admin_required
def crear_usuario(request):
    error = None
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        first_name = request.POST.get('first_name', '')
        last_name = request.POST.get('last_name', '')
        rol_id = request.POST.get('rol_id')

        if Usuario.objects.filter(username=username).exists():
            error = "El nombre de usuario ya existe."
        else:
            rol = Rol.objects.get(id=rol_id) if rol_id else None
            user = Usuario.objects.create_user(
                username=username,
                password=password,
                first_name=first_name,
                last_name=last_name,
                rol=rol
            )
            LogAuditoria.objects.create(
                usuario=request.user if request.user.is_authenticated else None,
                accion="Creación de Usuario",
                detalles=f"Se creó el usuario '{username}' con rol '{rol.nombre if rol else 'Sin Rol'}'"
            )
            return redirect('lista_usuarios')

    roles = Rol.objects.all()
    return render(request, 'sistema/crear_usuario.html', {'roles': roles, 'error': error})


@admin_required
def editar_usuario(request, usuario_id):
    usuario_editar = get_object_or_404(Usuario, id=usuario_id)

    if usuario_editar.is_superuser:
        return redirect('lista_usuarios')

    error = None

    if request.method == 'POST':
        password = request.POST.get('password', '').strip()
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        rol_id = request.POST.get('rol_id')
        is_active = request.POST.get('is_active') == 'on'

        usuario_editar.first_name = first_name
        usuario_editar.last_name = last_name
        usuario_editar.is_active = is_active

        if password:
            usuario_editar.set_password(password)

        if rol_id:
            usuario_editar.rol = Rol.objects.get(id=rol_id)
        else:
            usuario_editar.rol = None

        usuario_editar.save()

        LogAuditoria.objects.create(
            usuario=request.user,
            accion="Edición de Usuario",
            detalles=f"Se actualizaron los datos del usuario '{usuario_editar.username}'"
        )
        return redirect('lista_usuarios')

    roles = Rol.objects.all()
    context = {
        'usuario_editar': usuario_editar,
        'roles': roles,
        'error': error
    }
    return render(request, 'sistema/editar_usuario.html', context)


@admin_required
def lista_auditoria(request):
    logs = LogAuditoria.objects.select_related('usuario').order_by('-fecha_hora')[:100]
    return render(request, 'sistema/lista_auditoria.html', {'logs': logs})