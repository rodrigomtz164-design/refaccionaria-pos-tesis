from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required

@login_required
def dashboard(request):
    """
    Redirige al panel correspondiente según el rol del usuario logueado.
    """
    usuario = request.user
    
    # Validamos el nombre del rol asignado al usuario
    if usuario.rol and usuario.rol.nombre == 'Administrador':
        return render(request, 'sistema/dashboard_admin.html')
    elif usuario.rol and usuario.rol.nombre == 'Almacenista':
        return render(request, 'sistema/dashboard_almacen.html')
    elif usuario.rol and usuario.rol.nombre == 'Vendedor':
        return render(request, 'sistema/dashboard_ventas.html')
    else:
        # En caso de ser un superusuario sin rol asignado explícitamente
        return render(request, 'sistema/dashboard_admin.html')
    from django.db.models import Q
from .models import Producto, Categoria, MarcaAuto, ModeloAuto

@login_required
def lista_productos(request):
    """
    Muestra la tabla general de productos con filtros dinámicos por SKU/nombre,
    categoría, marca y modelo de auto.
    """
    productos = Producto.objects.select_related('categoria', 'proveedor').prefetch_related('aplicaciones__marca').all()

    # Obtener parámetros de búsqueda del GET
    query = request.GET.get('q', '').strip()
    categoria_id = request.GET.get('categoria', '')
    marca_id = request.GET.get('marca', '')

    # Filtro de búsqueda rápida por SKU o Nombre
    if query:
        productos = productos.filter(
            Q(sku__icontains=query) | Q(nombre__icontains=query)
        )

    # Filtro por Categoría
    if categoria_id:
        productos = productos.filter(categoria_id=categoria_id)

    # Filtro por Marca de Auto (compatibilidad)
    if marca_id:
        productos = productos.filter(aplicaciones__marca_id=marca_id).distinct()

    # Cargar catálogos para llenar los selectores de filtro
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