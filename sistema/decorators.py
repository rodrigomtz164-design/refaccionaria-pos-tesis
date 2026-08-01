from django.shortcuts import redirect
from django.contrib import messages
from functools import wraps

def rol_requerido(roles_permitidos=[]):
    """
    Decorador personalizado que verifica si el usuario autenticado
    tiene uno de los roles autorizados. Si no, lo redirige a su dashboard.
    """
    def decorator(view_func):
        @wraps(view_func)
        def _wrapped_view(request, *args, **kwargs):
            if not request.user.is_authenticated:
                return redirect('login')

            # Si es Superusuario de Django, le permitimos acceso total siempre
            if request.user.is_superuser:
                return view_func(request, *args, **kwargs)

            rol_usuario = request.user.rol.nombre if request.user.rol else None

            if rol_usuario in roles_permitidos:
                return view_func(request, *args, **kwargs)

            messages.warning(request, 'No tienes permisos suficientes para acceder a esa sección.')
            return redirect('dashboard')

        return _wrapped_view
    return decorator


# Alias directos y limpios para usar en las vistas
def admin_required(view_func):
    return rol_requerido(['Administrador'])(view_func)

def almacen_required(view_func):
    return rol_requerido(['Administrador', 'Almacenista'])(view_func)

def vendedor_required(view_func):
    return rol_requerido(['Administrador', 'Vendedor'])(view_func)