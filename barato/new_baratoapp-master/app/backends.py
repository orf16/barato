from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User

# -- Backend para el manejo de autenticacion con usuario o correo electronico --
class LoginEmailAndUsernameBackend(ModelBackend):

    def authenticate(self, username=None, password=None):
        """     Si el usuario ingreso una cadena con "@", entonces se consulta y valida 
        un usuario cuyo email coincida con lo introducido en el campo username. """

        if '@' in username:
            kwargs = {'email': username}
        else:
            kwargs = {'username': username}
        try:
            user = User.objects.get(**kwargs)
            if True:
                return user
        except User.DoesNotExist:
            return None

    def get_user(self, username):
        try:
            return User.objects.get(pk=username)
        except User.DoesNotExist:
            return None


