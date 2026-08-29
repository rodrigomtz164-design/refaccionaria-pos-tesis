import openpyxl
import json
from decimal import Decimal
from datetime import datetime, time, timedelta
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db.models import Q, Sum, F, Count
from django.http import JsonResponse, HttpResponse
from django.db import transaction
from django.utils import timezone
from django.contrib.sessions.models import Session

from .models import (
    Producto, Categoria, MarcaAuto, ModeloAuto, 
    Venta, DetalleVenta, Cotizacion, DetalleCotizacion, LogAuditoria, Usuario, Rol,
    ListaPrecioProveedor, CorteCaja, DescuentoConfig
)
from .decorators import admin_required, almacen_required, vendedor_required


def get_rango_dia_local():
    """Devuelve el inicio y fin del día actual en hora local exacta para evitar fallos de timezone con MySQL."""
    ahora_local = timezone.localtime(timezone.now())
    inicio_dia = timezone.make_aware(datetime.combine(ahora_local.date(), time.min))
    fin_dia = timezone.make_aware(datetime.combine(ahora_local.date(), time.max))
    return inicio_dia, fin_dia, ahora_local.date()


def inicializar_descuentos_base():
    """Asegura que existan los descuentos predefinidos si la tabla está vacía."""
    if not DescuentoConfig.objects.exists():
        DescuentoConfig.objects.create(nombre="Descuento Mostrador", porcentaje=2, activo=True)
        DescuentoConfig.objects.create(nombre="Descuento Medio", porcentaje=5, activo=True)
        DescuentoConfig.objects.create(nombre="Descuento Taller", porcentaje=10, activo=True)
        DescuentoConfig.objects.create(nombre="Descuento Especial", porcentaje=15, activo=False)


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
    inicializar_descuentos_base()
    inicio_dia, fin_dia, hoy = get_rango_dia_local()
    
    ventas_hoy_qs = Venta.objects.filter(fecha_venta__range=(inicio_dia, fin_dia))
    total_ventas_hoy = ventas_hoy_qs.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_ventas_hoy = ventas_hoy_qs.count()
    
    cotizaciones_hoy_qs = Cotizacion.objects.filter(fecha_creacion__range=(inicio_dia, fin_dia))
    num_cotiz_hoy = cotizaciones_hoy_qs.count()
    cotizaciones_mes = Cotizacion.objects.count()

    total_operaciones_hoy = num_ventas_hoy + num_cotiz_hoy
    total_usuarios = Usuario.objects.count()
    
    sesiones_activas = Session.objects.filter(expire_date__gte=timezone.now())
    usuarios_online_ids = set()
    for s in sesiones_activas:
        data = s.get_decoded()
        uid = data.get('_auth_user_id')
        if uid:
            usuarios_online_ids.add(uid)
            
    usuarios_en_linea = Usuario.objects.filter(id__in=usuarios_online_ids).count()
    if usuarios_en_linea == 0 and request.user.is_authenticated:
        usuarios_en_linea = 1
    
    cant_bajo_stock = Producto.objects.filter(stock_actual__lte=F('stock_minimo'), activo=True).count()

    ventas_recientes = Venta.objects.order_by('-fecha_venta')[:12]
    labels_ventas = [timezone.localtime(v.fecha_venta).strftime("%H:%M") for v in reversed(ventas_recientes)]
    data_ventas = [float(v.total) for v in reversed(ventas_recientes)]

    categorias = Categoria.objects.all()
    cat_nombres = []
    cat_cantidades = []
    for cat in categorias:
        count = Producto.objects.filter(categoria=cat).count()
        if count > 0:
            cat_nombres.append(cat.nombre)
            cat_cantidades.append(count)

    context = {
        'total_ventas_hoy': total_ventas_hoy,
        'num_ventas_hoy': num_ventas_hoy,
        'num_cotiz_hoy': num_cotiz_hoy,
        'total_operaciones_hoy': total_operaciones_hoy,
        'total_usuarios': total_usuarios,
        'usuarios_en_linea': usuarios_en_linea,
        'cant_bajo_stock': cant_bajo_stock,
        'cotizaciones_mes': cotizaciones_mes,
        'labels_ventas': json.dumps(labels_ventas),
        'data_ventas': json.dumps(data_ventas),
        'cat_nombres': json.dumps(cat_nombres),
        'cat_cantidades': json.dumps(cat_cantidades),
    }
    return render(request, 'sistema/dashboard_admin.html', context)


@almacen_required
def dashboard_almacen(request):
    if request.method == 'POST':
        accion_cat = request.POST.get('accion_categoria')
        
        if accion_cat == 'crear':
            nombre_cat = request.POST.get('nombre_categoria', '').strip()
            if nombre_cat:
                cat, created = Categoria.objects.get_or_create(nombre=nombre_cat)
                if created:
                    LogAuditoria.objects.create(
                        usuario=request.user,
                        accion="Creación de Categoría",
                        detalles=f"Se creó la línea de producto '{nombre_cat}'."
                    )
                    messages.success(request, f'Línea de producto "{nombre_cat}" creada correctamente.')
                else:
                    messages.warning(request, f'La categoría "{nombre_cat}" ya existe.')
            return redirect('dashboard_almacen')
            
        elif accion_cat == 'eliminar':
            cat_id = request.POST.get('categoria_id')
            if cat_id:
                try:
                    cat_eliminar = Categoria.objects.get(id=int(cat_id))
                    num_productos = Producto.objects.filter(categoria=cat_eliminar).count()
                    
                    if num_productos > 0:
                        messages.error(
                            request, 
                            f'No se puede eliminar la línea "{cat_eliminar.nombre}" porque tiene {num_productos} refacciones asociadas. '
                            f'Por seguridad de inventario, primero reasigna o retira los productos.'
                        )
                    else:
                        nombre_del = cat_eliminar.nombre
                        cat_eliminar.delete()
                        LogAuditoria.objects.create(
                            usuario=request.user,
                            accion="Eliminación de Categoría",
                            detalles=f"Se eliminó la línea de producto vacía '{nombre_del}'."
                        )
                        messages.success(request, f'Línea de producto "{nombre_del}" eliminada correctamente.')
                except Categoria.DoesNotExist:
                    pass
            return redirect('dashboard_almacen')

    total_productos = Producto.objects.count()
    productos_bajo = Producto.objects.filter(stock_actual__lte=F('stock_minimo'), activo=True).select_related('categoria')
    total_stock_bajo = productos_bajo.count()

    categorias = Categoria.objects.annotate(num_productos=Count('productos')).order_by('nombre')
    
    cat_nombres = []
    cat_cantidades = []
    for cat in categorias:
        if cat.num_productos > 0:
            cat_nombres.append(cat.nombre)
            cat_cantidades.append(cat.num_productos)

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
    
    ventas_hoy = Venta.objects.filter(vendedor=request.user, corte__isnull=True, fecha_venta__range=(inicio_dia, fin_dia)).order_by('fecha_venta')
    total_monto_hoy = ventas_hoy.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_ventas_hoy = ventas_hoy.count()
    
    cotizaciones_vendedor_qs = Cotizacion.objects.filter(vendedor=request.user, fecha_creacion__range=(inicio_dia, fin_dia))
    cotizaciones_vendedor_hoy = cotizaciones_vendedor_qs.count()
    cotiz_vend_pendientes = cotizaciones_vendedor_qs.filter(estado='PENDIENTE').count()
    cotiz_vend_convertidas = cotizaciones_vendedor_qs.filter(Q(estado='CONVERTIDA') | Q(estado='PROCESADA')).count()
    cotiz_vend_vencidas = cotizaciones_vendedor_qs.filter(estado='VENCIDA').count()

    labels_ventas_turno = [timezone.localtime(v.fecha_venta).strftime("%H:%M") for v in ventas_hoy]
    data_ventas_turno = [float(v.total) for v in ventas_hoy]

    context = {
        'total_monto_hoy': total_monto_hoy,
        'num_ventas_hoy': num_ventas_hoy,
        'cotizaciones_vendedor_hoy': cotizaciones_vendedor_hoy,
        'cotiz_vend_pendientes': cotiz_vend_pendientes,
        'cotiz_vend_convertidas': cotiz_vend_convertidas,
        'cotiz_vend_vencidas': cotiz_vend_vencidas,
        'labels_ventas_turno': json.dumps(labels_ventas_turno),
        'data_ventas_turno': json.dumps(data_ventas_turno),
    }
    return render(request, 'sistema/dashboard_ventas.html', context)


# =======================================================
# GESTIÓN DE DESCUENTOS
# =======================================================
@admin_required
def gestion_descuentos(request):
    inicializar_descuentos_base()

    if request.method == 'POST':
        eliminar_id = request.POST.get('eliminar_id')
        if eliminar_id:
            try:
                desc_eliminar = DescuentoConfig.objects.get(id=int(eliminar_id))
                nombre_del = desc_eliminar.nombre
                desc_eliminar.delete()
                LogAuditoria.objects.create(
                    usuario=request.user,
                    accion="Eliminación de Nivel de Descuento",
                    detalles=f"Se eliminó el nivel '{nombre_del}'."
                )
                messages.success(request, f'Se eliminó el descuento "{nombre_del}" correctamente.')
            except DescuentoConfig.DoesNotExist:
                pass
            return redirect('gestion_descuentos')

        accion = request.POST.get('accion')
        if accion == 'crear_nuevo':
            nuevo_nombre = request.POST.get('nuevo_nombre', '').strip()
            nuevo_porcentaje = request.POST.get('nuevo_porcentaje', '0').strip()
            try:
                porc_val = int(nuevo_porcentaje)
                if nuevo_nombre and 1 <= porc_val <= 100:
                    DescuentoConfig.objects.create(
                        nombre=nuevo_nombre,
                        porcentaje=porc_val,
                        activo=True
                    )
                    LogAuditoria.objects.create(
                        usuario=request.user,
                        accion="Creación de Nivel de Descuento",
                        detalles=f"Nuevo descuento '{nuevo_nombre}' al {porc_val}%."
                    )
                    messages.success(request, f'¡Descuento "{nuevo_nombre}" ({porc_val}%) creado con éxito!')
                else:
                    messages.error(request, 'Datos inválidos para el nuevo descuento.')
            except ValueError:
                messages.error(request, 'El porcentaje debe ser un número entero válido.')
            return redirect('gestion_descuentos')

        if accion == 'actualizar_masivo':
            descuentos = DescuentoConfig.objects.all()
            for desc in descuentos:
                nuevo_nom = request.POST.get(f'desc_nombre_{desc.id}', '').strip()
                nuevo_porc = request.POST.get(f'desc_porcentaje_{desc.id}', '').strip()
                checkbox_val = request.POST.get(f'desc_activo_{desc.id}')

                if nuevo_nom:
                    desc.nombre = nuevo_nom
                try:
                    p_val = int(nuevo_porc)
                    if 1 <= p_val <= 100:
                        desc.porcentaje = p_val
                except ValueError:
                    pass

                desc.activo = bool(checkbox_val)
                desc.save()

            LogAuditoria.objects.create(
                usuario=request.user,
                accion="Actualización de Niveles de Descuento",
                detalles="Se modificaron nombres, porcentajes y estados de descuentos del POS."
            )
            messages.success(request, '¡Todos los cambios de descuentos fueron guardados con éxito!')
            return redirect('gestion_descuentos')

    descuentos = DescuentoConfig.objects.all().order_by('porcentaje')
    return render(request, 'sistema/gestion_descuentos.html', {'descuentos': descuentos})


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
                unidad_medida=unidad_medida,
                activo=True
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


@almacen_required
def toggle_estado_producto(request, producto_id):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            producto = get_object_or_404(Producto, id=producto_id)
            nuevo_estado = bool(data.get('activo', True))
            
            producto.activo = nuevo_estado
            producto.save(update_fields=['activo'])

            estado_str = "ACTIVADO" if nuevo_estado else "DESACTIVADO"
            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Cambio de Estado Producto #{producto.id}",
                detalles=f"El producto '{producto.nombre}' (SKU: {producto.sku or 'SIN SKU'}) fue {estado_str}."
            )

            return JsonResponse({'success': True, 'activo': producto.activo, 'message': f'Producto {estado_str.lower()} correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

    return JsonResponse({'success': False, 'message': 'Método no permitido.'})


@vendedor_required
def pos_ventas(request):
    inicializar_descuentos_base()
    productos = Producto.objects.filter(activo=True).select_related('categoria').prefetch_related('aplicaciones__marca')
    descuentos_activos = DescuentoConfig.objects.filter(activo=True).order_by('porcentaje')

    context = {
        'productos': productos,
        'descuentos_activos': descuentos_activos,
    }
    return render(request, 'sistema/pos_ventas.html', context)


@vendedor_required
def procesar_venta(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            carrito = data.get('carrito', [])
            porcentaje_descuento = float(data.get('descuento', 0))
            metodo_pago = data.get('metodo_pago', 'EFECTIVO').upper()
            if metodo_pago not in ['EFECTIVO', 'TARJETA', 'TRANSFERENCIA']:
                metodo_pago = 'EFECTIVO'

            paga_con = Decimal(str(data.get('paga_con', 0)))
            cotizacion_id = data.get('cotizacion_id', None)

            if not carrito:
                return JsonResponse({'success': False, 'message': 'La nota de venta está vacía.'})

            descuento_decimal = Decimal(str(porcentaje_descuento / 100))

            with transaction.atomic():
                subtotal_venta = Decimal('0.00')
                items_a_procesar = []

                for item in carrito:
                    if item.get('es_especial'):
                        precio_unitario = Decimal(str(item['precio']))
                        cant = Decimal(str(item['cantidad']))
                        subtotal_item = precio_unitario * cant
                        subtotal_venta += subtotal_item
                        continue

                    producto = Producto.objects.select_for_update().get(id=item['id'])
                    cant = Decimal(str(item['cantidad']))

                    if not producto.activo:
                        raise Exception(f'El producto {producto.nombre} se encuentra inactivo/pausado.')

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

                if metodo_pago in ['TARJETA', 'TRANSFERENCIA']:
                    paga_con = total_venta

                venta = Venta.objects.create(
                    vendedor=request.user,
                    descuento_aplicado=descuento_decimal,
                    subtotal=subtotal_venta,
                    total=total_venta,
                    metodo_pago=metodo_pago
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

                if cotizacion_id:
                    try:
                        cot = Cotizacion.objects.get(id=int(cotizacion_id))
                        cot.estado = 'CONVERTIDA'
                        cot.subtotal = subtotal_venta
                        cot.total = total_venta
                        cot.save(update_fields=['estado', 'subtotal', 'total'])

                        cot.detalles.all().delete()
                        for item in items_a_procesar:
                            DetalleCotizacion.objects.create(
                                cotizacion=cot,
                                producto=item['producto'],
                                cantidad=item['cantidad'],
                                precio_cotizado=item['precio_unitario'],
                                subtotal=item['subtotal']
                            )
                    except Exception:
                        pass

                LogAuditoria.objects.create(
                    usuario=request.user,
                    accion=f"Venta registrada #{venta.id}",
                    detalles=f"Total: ${total_venta:.2f} | Pago: {metodo_pago} | Descuento: {porcentaje_descuento}%"
                )

            return JsonResponse({
                'success': True, 
                'venta_id': venta.id, 
                'metodo_pago': metodo_pago,
                'paga_con': float(paga_con),
                'cambio': float(max(paga_con - total_venta, Decimal('0.00'))),
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
    ventas = Venta.objects.select_related('vendedor', 'corte').prefetch_related('detalles__producto').order_by('-fecha_venta')
    
    query = request.GET.get('q', '').strip()
    fecha_filtro = request.GET.get('fecha', '').strip()

    if query:
        ventas = ventas.filter(
            Q(id__icontains=query) | Q(vendedor__username__icontains=query) | Q(metodo_pago__icontains=query)
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


# ==========================================
# CORTE DE CAJA FORMAL & HISTORIAL
# ==========================================
@vendedor_required
def corte_caja_view(request):
    inicio_dia, fin_dia, hoy = get_rango_dia_local()

    ventas_pendientes = Venta.objects.filter(corte__isnull=True).order_by('-fecha_venta')
    total_en_caja = ventas_pendientes.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
    num_ventas_pendientes = ventas_pendientes.count()

    cotizaciones_hoy_qs = Cotizacion.objects.filter(fecha_creacion__range=(inicio_dia, fin_dia))
    cotizaciones_hoy_total = cotizaciones_hoy_qs.count()
    cotiz_hoy_pendientes = cotizaciones_hoy_qs.filter(estado='PENDIENTE').count()
    cotiz_hoy_convertidas = cotizaciones_hoy_qs.filter(Q(estado='CONVERTIDA') | Q(estado='PROCESADA')).count()
    cotiz_hoy_vencidas = cotizaciones_hoy_qs.filter(estado='VENCIDA').count()

    cortes_historial = CorteCaja.objects.select_related('usuario').order_by('-fecha_cierre')[:30]

    context = {
        'total_en_caja': total_en_caja,
        'num_ventas_pendientes': num_ventas_pendientes,
        'cotizaciones_hoy_total': cotizaciones_hoy_total,
        'cotiz_hoy_pendientes': cotiz_hoy_pendientes,
        'cotiz_hoy_convertidas': cotiz_hoy_convertidas,
        'cotiz_hoy_vencidas': cotiz_hoy_vencidas,
        'ventas_pendientes': ventas_pendientes,
        'cortes_historial': cortes_historial,
        'fecha_hoy': hoy,
    }
    return render(request, 'sistema/corte_caja.html', context)


@vendedor_required
def efectuar_cierre_caja(request):
    if request.method == 'POST':
        ventas_a_cortar = Venta.objects.filter(corte__isnull=True)
        num_ventas = ventas_a_cortar.count()

        if num_ventas == 0:
            messages.warning(request, 'No hay ventas pendientes para realizar un corte de caja.')
            return redirect('corte_caja')

        autorizado_por = ""
        if not request.user.is_superuser and (not request.user.rol or request.user.rol.nombre != 'Administrador'):
            admin_password = request.POST.get('admin_password', '').strip()
            if not admin_password:
                messages.error(request, 'Se requiere la contraseña de un Administrador para autorizar el corte.')
                return redirect('corte_caja')

            es_valido = False
            admins = Usuario.objects.filter(Q(is_superuser=True) | Q(rol__nombre='Administrador'), is_active=True)
            for adm in admins:
                if adm.check_password(admin_password):
                    es_valido = True
                    autorizado_por = adm.username
                    break

            if not es_valido:
                messages.error(request, 'Contraseña de Administrador incorrecta. El corte fue denegado.')
                return redirect('corte_caja')

        total_cobrado = ventas_a_cortar.aggregate(Sum('total'))['total__sum'] or Decimal('0.00')
        observaciones = request.POST.get('observaciones', '').strip()

        with transaction.atomic():
            corte = CorteCaja.objects.create(
                usuario=request.user,
                total_cobrado=total_cobrado,
                num_ventas=num_ventas,
                observaciones=observaciones
            )

            ventas_a_cortar.update(corte=corte)

            detalle_log = f"Corte #{corte.id} realizado por {request.user.username}. Total: ${total_cobrado:.2f} ({num_ventas} notas)."
            if autorizado_por:
                detalle_log += f" [Autorizado por Admin: {autorizado_por}]"

            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Cierre de Caja #{corte.id}",
                detalles=detalle_log
            )

        messages.success(request, f'¡Corte #{corte.id} completado con éxito! Total cerrado: ${total_cobrado:.2f}')
        return redirect('imprimir_corte_ticket', corte_id=corte.id)

    return redirect('corte_caja')


@vendedor_required
def imprimir_corte_ticket(request, corte_id):
    corte = get_object_or_404(CorteCaja.objects.select_related('usuario').prefetch_related('ventas_incluidas__vendedor'), id=corte_id)
    ventas = corte.ventas_incluidas.all()

    context = {
        'corte': corte,
        'ventas': ventas,
    }
    return render(request, 'sistema/corte_pdf.html', context)


# ==========================================
# MÓDULO COTIZACIONES INTELIGENTES
# ==========================================
@admin_required
def eliminar_cotizacion(request, cotizacion_id):
    if request.method == 'POST':
        cotizacion = get_object_or_404(Cotizacion, id=cotizacion_id)
        folio = cotizacion.id
        cliente = cotizacion.cliente_nombre
        total = cotizacion.total
        estado = cotizacion.estado
        
        cotizacion.delete()
        
        LogAuditoria.objects.create(
            usuario=request.user,
            accion=f"Eliminación de Cotización #{folio}",
            detalles=f"Se eliminó la cotización #{folio} de {cliente} (Estado: {estado}, Total: ${total:.2f})."
        )
        messages.success(request, f'Cotización #{folio} de "{cliente}" eliminada con éxito.')
        return redirect('lista_cotizaciones')
    
    return redirect('lista_cotizaciones')


@vendedor_required
def desactivar_cotizacion(request, cotizacion_id):
    """Permite ocultar/archivar una cotización vencida sin borrarla de la base de datos."""
    if request.method == 'POST':
        cotizacion = get_object_or_404(Cotizacion, id=cotizacion_id)
        
        if cotizacion.estado == 'VENCIDA':
            cotizacion.estado = 'CANCELADA'
            cotizacion.save(update_fields=['estado'])
            
            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Cotización #{cotizacion.id} Archivada",
                detalles=f"Se archivó/ocultó la cotización vencida de {cotizacion.cliente_nombre}."
            )
            messages.success(request, f'Cotización #{cotizacion.id} archivada correctamente.')
        else:
            messages.warning(request, 'Solo se pueden archivar cotizaciones vencidas.')

    return redirect('lista_cotizaciones')


@vendedor_required
def guardar_cotizacion(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            carrito = data.get('carrito', [])
            cliente_nombre = data.get('cliente_nombre', 'Cliente Mostrador').strip() or 'Cliente Mostrador'
            cliente_telefono = data.get('cliente_telefono', '').strip()
            cliente_email = data.get('cliente_email', '').strip()
            cotizacion_id_existente = data.get('cotizacion_id', None)
            actualizar_existente = data.get('actualizar_existente', False)

            if not carrito:
                return JsonResponse({'success': False, 'message': 'La cotización no puede estar vacía.'})

            with transaction.atomic():
                subtotal_cotizacion = Decimal('0.00')
                detalles_a_crear = []

                categoria_default = Categoria.objects.first()
                if not categoria_default:
                    categoria_default, _ = Categoria.objects.get_or_create(nombre='Varios')

                producto_especial_comodin, _ = Producto.objects.get_or_create(
                    sku='PEDIDO-ESPECIAL',
                    defaults={
                        'nombre': 'Refacción Especial (Proveedor Externo)',
                        'categoria': categoria_default,
                        'precio_costo': Decimal('0.00'),
                        'precio_venta': Decimal('0.00'),
                        'stock_actual': Decimal('999'),
                        'stock_minimo': Decimal('0'),
                        'es_granel': False,
                        'unidad_medida': 'Pieza',
                        'activo': True
                    }
                )

                for item in carrito:
                    cant = Decimal(str(item['cantidad']))
                    precio = Decimal(str(item['precio']))
                    subtotal_item = cant * precio
                    subtotal_cotizacion += subtotal_item

                    if item.get('es_especial'):
                        detalles_a_crear.append({
                            'producto': producto_especial_comodin,
                            'cantidad': cant,
                            'precio_cotizado': precio,
                            'subtotal': subtotal_item
                        })
                    else:
                        producto = Producto.objects.get(id=item['id'])
                        detalles_a_crear.append({
                            'producto': producto,
                            'cantidad': cant,
                            'precio_cotizado': precio,
                            'subtotal': subtotal_item
                        })

                if cotizacion_id_existente and actualizar_existente:
                    try:
                        cotizacion = Cotizacion.objects.get(id=int(cotizacion_id_existente))
                        cotizacion.cliente_nombre = cliente_nombre
                        cotizacion.cliente_telefono = cliente_telefono
                        cotizacion.cliente_email = cliente_email or None
                        cotizacion.subtotal = subtotal_cotizacion
                        cotizacion.total = subtotal_cotizacion
                        cotizacion.estado = 'PENDIENTE'
                        cotizacion.save()

                        cotizacion.detalles.all().delete()
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
                            accion=f"Cotización actualizada #{cotizacion.id}",
                            detalles=f"Se actualizaron refacciones de #{cotizacion.id} | Nuevo Total: ${subtotal_cotizacion:.2f}"
                        )
                        return JsonResponse({'success': True, 'cotizacion_id': cotizacion.id, 'message': f'Cotización #{cotizacion.id} actualizada correctamente.'})
                    except Cotizacion.DoesNotExist:
                        pass

                cotizacion = Cotizacion.objects.create(
                    vendedor=request.user,
                    cliente_nombre=cliente_nombre,
                    cliente_telefono=cliente_telefono,
                    cliente_email=cliente_email or None,
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
    if request.user.is_superuser or (request.user.rol and request.user.rol.nombre == 'Administrador'):
        cotizaciones_base = Cotizacion.objects.select_related('vendedor').prefetch_related('detalles').order_by('-fecha_creacion')
    else:
        cotizaciones_base = Cotizacion.objects.filter(vendedor=request.user).select_related('vendedor').prefetch_related('detalles').order_by('-fecha_creacion')
    
    estado_filtro = request.GET.get('estado', '').strip()
    if estado_filtro:
        cotizaciones_qs = cotizaciones_base.filter(estado=estado_filtro)
    else:
        cotizaciones_qs = cotizaciones_base.exclude(estado='CANCELADA')

    query = request.GET.get('q', '').strip()
    ver_todas = request.GET.get('ver_todas') == '1'

    if query:
        cotizaciones_qs = cotizaciones_qs.filter(
            Q(id__icontains=query) | Q(cliente_nombre__icontains=query) | Q(cliente_email__icontains=query)
        )

    ahora = timezone.now()
    for cot in cotizaciones_qs:
        if cot.estado == 'PENDIENTE' and ahora > (cot.fecha_creacion + timedelta(hours=24)):
            cot.estado = 'VENCIDA'
            cot.save(update_fields=['estado'])

    total_cotizaciones = cotizaciones_qs.count()

    if not ver_todas:
        cotizaciones = cotizaciones_qs[:100]
    else:
        cotizaciones = cotizaciones_qs

    context = {
        'cotizaciones': cotizaciones,
        'query': query,
        'estado_filtro': estado_filtro,
        'total_cotizaciones': total_cotizaciones,
        'viendo_todas': ver_todas,
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
        
        items = []
        hubo_cambio_precio = False

        for det in cotizacion.detalles.all():
            prod = det.producto
            
            if prod and prod.sku != 'PEDIDO-ESPECIAL':
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
                    'unidad_medida': prod.unidad_medida,
                    'es_especial': False
                })
            else:
                items.append({
                    'id': f'ESP-{det.id}',
                    'sku': 'ESP',
                    'nombre': f'[PEDIDO ESPECIAL] Refacción Cotizada #{det.id}',
                    'precio': float(det.precio_cotizado),
                    'precio_original_cotizado': float(det.precio_cotizado),
                    'cantidad': float(det.cantidad),
                    'stock_disponible': 999,
                    'es_granel': False,
                    'unidad_medida': 'Pieza',
                    'es_especial': True
                })

        return JsonResponse({
            'success': True,
            'cotizacion_id': cotizacion.id,
            'estado': cotizacion.estado,
            'cliente_nombre': cotizacion.cliente_nombre,
            'cliente_telefono': cotizacion.cliente_telefono,
            'cliente_email': cotizacion.cliente_email or '',
            'items': items,
            'hubo_cambio_precio': hubo_cambio_precio
        })

    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})


@vendedor_required
def imprimir_ticket_venta(request, venta_id):
    venta = get_object_or_404(Venta.objects.prefetch_related('detalles__producto').select_related('vendedor'), id=venta_id)
    
    metodo = venta.metodo_pago or 'EFECTIVO'
    
    if metodo in ['TARJETA', 'TRANSFERENCIA']:
        paga_con = venta.total
        cambio = Decimal('0.00')
    else:
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
        'metodo_pago': metodo
    }
    return render(request, 'sistema/ticket_venta.html', context)


# ==========================================
# GESTIÓN DE USUARIOS Y AUDITORÍA
# ==========================================
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
    logs_qs = LogAuditoria.objects.select_related('usuario').order_by('-fecha_hora')
    
    query = request.GET.get('q', '').strip()
    usuario_id = request.GET.get('usuario', '').strip()
    fecha_filtro = request.GET.get('fecha', '').strip()
    ver_todos = request.GET.get('ver_todos') == '1'

    if query:
        logs_qs = logs_qs.filter(
            Q(accion__icontains=query) | Q(detalles__icontains=query)
        )

    if usuario_id:
        logs_qs = logs_qs.filter(usuario_id=usuario_id)

    if fecha_filtro:
        try:
            fecha_obj = datetime.strptime(fecha_filtro, "%Y-%m-%d").date()
            inicio = timezone.make_aware(datetime.combine(fecha_obj, time.min))
            fin = timezone.make_aware(datetime.combine(fecha_obj, time.max))
            logs_qs = logs_qs.filter(fecha_hora__range=(inicio, fin))
        except ValueError:
            pass

    total_registros = logs_qs.count()

    if not ver_todos:
        logs = logs_qs[:100]
    else:
        logs = logs_qs

    usuarios = Usuario.objects.all().order_by('username')

    context = {
        'logs': logs,
        'usuarios': usuarios,
        'query': query,
        'usuario_id': usuario_id,
        'fecha_filtro': fecha_filtro,
        'total_registros': total_registros,
        'viendo_todos': ver_todos,
    }
    return render(request, 'sistema/lista_auditoria.html', context)


@almacen_required
def cargar_catalogo_proveedor(request):
    if request.method == 'POST' and request.FILES.get('archivo_excel'):
        excel_file = request.FILES['archivo_excel']
        
        if not excel_file.name.endswith(('.xlsx', '.xls')):
            messages.error(request, 'Por favor, selecciona un archivo de Excel válido (.xlsx o .xls).')
            return redirect('cargar_catalogo_proveedor')

        try:
            wb = openpyxl.load_workbook(excel_file, data_only=True)
            sheet = wb.active
            
            registros_creados = 0
            registros_actualizados = 0

            for row in sheet.iter_rows(min_row=2, values_only=True):
                if not row or not row[0]:
                    continue
                
                prov_nombre = str(row[0]).strip() if row[0] else ''
                codigo_ref = str(row[1]).strip() if len(row) > 1 and row[1] else ''
                nombre_ref = str(row[2]).strip() if len(row) > 2 and row[2] else ''
                
                try:
                    precio_ref = Decimal(str(row[3])) if len(row) > 3 and row[3] is not None else Decimal('0.00')
                except Exception:
                    precio_ref = Decimal('0.00')

                tel_contacto = str(row[4]).strip() if len(row) > 4 and row[4] else ''
                notas_txt = str(row[5]).strip() if len(row) > 5 and row[5] else ''

                if not prov_nombre or not nombre_ref:
                    continue

                obj, created = ListaPrecioProveedor.objects.update_or_create(
                    proveedor_negocio=prov_nombre,
                    codigo_refaccion=codigo_ref,
                    defaults={
                        'nombre_refaccion': nombre_ref,
                        'precio_referencia': precio_ref,
                        'telefono_contacto': tel_contacto,
                        'notas': notas_txt
                    }
                )

                if created:
                    registros_creados += 1
                else:
                    registros_actualizados += 1

            LogAuditoria.objects.create(
                usuario=request.user,
                accion="Carga Masiva Excel Proveedores",
                detalles=f"Se procesaron {registros_creados + registros_actualizados} registros ({registros_creados} creados, {registros_actualizados} actualizados)."
            )

            messages.success(
                request, 
                f'¡Proceso completado! Se registraron {registros_creados} refacciones nuevas y se actualizaron {registros_actualizados}.'
            )
            return redirect('cargar_catalogo_proveedor')

        except Exception as e:
            messages.error(request, f'Ocurrió un error al procesar el archivo Excel: {str(e)}')
            return redirect('cargar_catalogo_proveedor')

    return render(request, 'sistema/cargar_excel.html')


@vendedor_required
def buscar_proveedores_ajax(request):
    query = request.GET.get('q', '').strip()
    resultados = []

    if query:
        items = ListaPrecioProveedor.objects.filter(
            Q(codigo_refaccion__icontains=query) |
            Q(nombre_refaccion__icontains=query) |
            Q(proveedor_negocio__icontains=query)
        )[:30]

        for item in items:
            resultados.append({
                'proveedor': item.proveedor_negocio,
                'codigo': item.codigo_refaccion or 'S/C',
                'nombre': item.nombre_refaccion,
                'precio': f"{item.precio_referencia:.2f}",
                'telefono': item.telefono_contacto or '',
                'notas': item.notas or 'Sin notas'
            })

    return JsonResponse({'resultados': resultados})


@login_required
def gestion_categorias(request):
    if not request.user.is_superuser and (not request.user.rol or request.user.rol.nombre not in ['Administrador', 'Almacenista']):
        messages.error(request, 'No tienes permisos para acceder a este módulo.')
        return redirect('dashboard')

    if request.method == 'POST':
        accion = request.POST.get('accion_categoria')

        if accion == 'crear':
            nombre = request.POST.get('nombre_categoria', '').strip()
            if nombre:
                cat, created = Categoria.objects.get_or_create(nombre=nombre)
                if created:
                    LogAuditoria.objects.create(
                        usuario=request.user,
                        accion="Creación de Categoría",
                        detalles=f"Se creó la categoría '{nombre}'."
                    )
                    messages.success(request, f'Línea de producto "{nombre}" creada con éxito.')
                else:
                    messages.warning(request, f'La categoría "{nombre}" ya existe en el sistema.')
            return redirect('gestion_categorias')

        elif accion == 'eliminar':
            cat_id = request.POST.get('categoria_id')
            if cat_id:
                try:
                    cat_obj = Categoria.objects.get(id=int(cat_id))
                    num_piezas = Producto.objects.filter(categoria=cat_obj).count()

                    if num_piezas > 0:
                        messages.error(
                            request, 
                            f'No se puede eliminar "{cat_obj.nombre}" porque tiene {num_piezas} refacciones asignadas. '
                            f'Por integridad de inventario, reasigna los productos a otra categoría antes de eliminarla.'
                        )
                    else:
                        nom_del = cat_obj.nombre
                        cat_obj.delete()
                        LogAuditoria.objects.create(
                            usuario=request.user,
                            accion="Eliminación de Categoría",
                            detalles=f"Se eliminó la categoría vacía '{nom_del}'."
                        )
                        messages.success(request, f'Línea de producto "{nom_del}" eliminada correctamente.')
                except Categoria.DoesNotExist:
                    pass
            return redirect('gestion_categorias')

    categorias = Categoria.objects.annotate(num_productos=Count('productos')).order_by('nombre')
    return render(request, 'sistema/gestion_categorias.html', {'categorias': categorias})