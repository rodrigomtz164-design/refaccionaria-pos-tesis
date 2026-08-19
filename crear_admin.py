import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'refaccionaria_core.settings')
django.setup()

from sistema.models import Rol, Usuario

# 1. Crear los roles base
rol_admin, _ = Rol.objects.get_or_create(nombre='Administrador')
Rol.objects.get_or_create(nombre='Vendedor')
Rol.objects.get_or_create(nombre='Almacen')

# 2. Crear tu usuario Administrador
if not Usuario.objects.filter(username='admin').exists():
    admin_user = Usuario.objects.create_superuser(
        username='admin',
        first_name='Rodrigo',
        last_name='Admin',
        rol=rol_admin,
        password='Admin123!'
    )
    print("¡USUARIO ADMIN CREADO CON EXITO!")
else:
    admin_user = Usuario.objects.get(username='admin')
    admin_user.set_password('Admin123!')
    admin_user.rol = rol_admin
    admin_user.is_staff = True
    admin_user.is_superuser = True
    admin_user.save()
    print("¡USUARIO ADMIN ACTUALIZADO CON EXITO!")