from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from django.core.exceptions import ObjectDoesNotExist
from .models import Customer, Product, User
import json
import base64
from django.http import HttpResponse
from .forms import SignUpForm, NewUserPasswordForm, SingInForm
from django.views.generic.edit import View
from django.views.generic import TemplateView
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
import requests
import re
from django.core.mail import send_mail
from django.template.defaultfilters import stringfilter
from django.utils.encoding import force_text


# -- View para el registro de usuarios --
class SignUpView(TemplateView):
    form_class = SignUpForm
    template_name = 'users/sign_up.html'

    def get(self, request):
        form = self.form_class()
        return render(request, self.template_name, {'form': form, 'register': True})

    def post(self, request):
        form = self.form_class(request.POST)

        if form.is_valid():
            user = form.save()
            user.customer.city = form.cleaned_data.get('city')
            user.customer.locality = form.cleaned_data.get('locality')
            user.customer.main_address = form.cleaned_data.get('main_address')
            user.customer.phone = form.cleaned_data.get('phone')
            user.customer.save()
            password = form.cleaned_data.get('password1')

            emailUserLocal = user.email
            dataUser = {
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "password": password,
                "phone": user.customer.phone,
                "address": form.cleaned_data.get('main_address')
            }

            user = authenticate(username=user.username, password=password)

            if user is not None:
                if user.is_active:
                    saveUserService(dataUser)
                    login(request, user)

                    htmlCorreo = 'Bievenido ' + user.first_name + ' ' + user.last_name + ',  gracias por registrarte en nuestra platafora, para acceder a los servicios de Baratoapp puedes ingresar a través del sitio web - https://baratoapp.co - . Te esperamos pronto !. '
                    send_mail('Creación de usuario', htmlCorreo, 'baratoapp@beyondtech.com.co', [emailUserLocal])
                    return redirect('index')

        return render(request, self.template_name, {'form': form})


# -- View para el acceso a index --
@method_decorator(login_required, name='dispatch')
class IndexView(TemplateView):
    # template_name = "index/index.html"
    template_name = "new_baratoapp/index/index.html"

    def get(self, request):
        if request.user.has_usable_password():
            return render(request, self.template_name)
        else:
            return redirect('new_password')


# -- View para registrar datos extras del usuarios ingresados por redes sociales --
class NewPasswordView(View):
    form_class = NewUserPasswordForm
    template_name = 'users/sign_up.html'

    def get(self, request):
        form = self.form_class()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = self.form_class(request.POST)

        if form.is_valid():
            user = request.user
            password = form.cleaned_data.get('password1')
            user.set_password(password)
            user.save()
            user.customer.city = form.cleaned_data.get('city')
            user.customer.locality = form.cleaned_data.get('locality')
            user.customer.main_address = form.cleaned_data.get('main_address')
            user.customer.phone = form.cleaned_data.get('phone')
            user.customer.save()

            dataUser = {
                "email": user.customer.user,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "password": password,
                "phone": user.customer.phone,
                "address": form.cleaned_data.get('main_address')
            }

            user = authenticate(username=user.username, password=password)

            if user is not None:
                saveUserService(dataUser)
                login(request, user)

                htmlCorreo = 'Bievenido ' + str(dataUser['first_name']) + ' ' + str(dataUser[
                                                                                        'last_name']) + ',  gracias por registrarte en nuestra platafora, para acceder a los servicios de Baratoapp puedes ingresar a través del sitio web - https://baratoapp.co - . Te esperamos pronto !. '
                send_mail('Creación de usuario', htmlCorreo, 'baratoapp@beyondtech.com.co', [str(dataUser['email'])])

                return redirect('index')

        return render(request, self.template_name, {'form': form})


# -- View manejo de barra de busqueda de articulos --
def search_bar(request):
    if request.is_ajax:
        palabra = request.GET.get('term', '')

        productos = Product.objects.filter(name__icontains=palabra)

        results = []
        for item in productos:
            item_json = {}
            item_json['label'] = item.name
            item_json['value'] = item.name
            results.append(item_json)

        data_json = json.dumps(results)

    else:
        data_json = 'fail'
    mimetype = "application/json"
    return HttpResponse(data_json, mimetype)


# -- Retorna todos los usuarios
def getUsuarios(request):
    results = []
    current_user = request.user
    # users = User.objects.filter(name__notcontains=current_user.name)
    users = User.objects.all().exclude(first_name__contains=current_user.first_name)
    for item in users:
        item_json = {}
        item_json['first_name'] = item.first_name
        item_json['last_name'] = item.last_name
        item_json['email'] = item.email
        item_json['username'] = item.username
        results.append(item_json)

    data_json = json.dumps(results)

    mimetype = "application/json"
    return HttpResponse(data_json, mimetype)


# -- Autenticacion por facebook
def authenticateSocial(request, backend, *args, **kwargs):
    return do_complete(request.backend, _do_login, request.user, redirect_name=REDIRECT_FIELD_NAME, request=request,
                       *args, **kwargs)


# return True


# -- Guardamos los datos del usuario en la base de datos de Postgre
def saveUserService(userParam):
    dataUser = {
        "usuario": {
            "email": "" + str(userParam['email']) + "",
            "nombre": "" + str(userParam['first_name']) + "",
            "apellido": "" + str(userParam['last_name']) + "",
            "clave": "" + str(userParam['password']) + "",
            "idtipodocumento": 1,
            "documento": "default",
            "sexo": 1,
            "estadocivil": 1,
            "fechanacimiento": "2000-01-01",
            "telefono": "" + str(userParam['phone']) + "",
            "tipousuario": 1
        },
        "direcciones": [
            {
                "idDepartamento": 14,
                "idMunicipio": 150,
                "direccion": "" + str(userParam['address']) + "",
                "nombredireccion": "Default",
                "lat": -74.072092,
                "lng": 4.7109886
            }
        ]
    }
    r = requests.post("http://localhost:8081/barato/guardarUsuario", json.JSONEncoder().encode(dataUser),
                         headers={"Content-Type": "application/json",
                             "Token":  base64.b64encode(bytes(
                                 'baratoUser' + '@@@' +str(userParam['email']) + '@@@' + 'gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+' + '@@@' + 'Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP',
                                 'utf-8')),
                             "UserEmail": str(userParam['email'])}, auth = ("baratoUser", "gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+"))

        #   r = requests.post("https://servicio.baratoapp.co/barato/guardarUsuario", json.JSONEncoder().encode(dataUser),
    #                      headers={"Content-Type": "application/json",
    #                          "Token":  base64.b64encode(bytes(
    #                              'baratoUser' + '@@@' +str(userParam['email']) + '@@@' + 'gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+' + '@@@' + 'Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP',
    #                              'utf-8')),
    #                          "UserEmail": str(userParam['email'])}, auth = ("baratoUser", "gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+"))

    # r = requests.post("http://baratoapp.co:8080/barato/guardarUsuario", json.JSONEncoder().encode(dataUser),
    #                   headers={"Content-Type": "application/json",
    #                            "Token": base64.b64encode(bytes(
    #                                'baratoUser' + '@@@' + str(userParam[
    #                                                               'email']) + '@@@' + 'gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+' + '@@@' + 'Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP',
    #                                'utf-8')),
    #                            "UserEmail": str(userParam['email'])}, auth=("baratoUser",
    #                                                                         "gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+"))

    print(r.text)
    if r.status_code == 200:
        print(r.text)

# sign in method
# def sign_in(request):

#     if request.method != 'POST':
#         username = ''
#         password = ''
#     else:
#         username = request.POST['inputEmail']
#         password = request.POST['inputPassword']

#     user = authenticate(username=username, password=password)
#     if user is not None:
#         return render(request, 'index/index.html', {'user':user})
#     else:
#         return render(request, 'sign_in/sign_in.html', {})

# logout from user account
# def logOut(request):
#     logout(request)
#     return redirect('/')


# def sign_up(request):
#     if request.method == 'POST':
#         form = SignUpForm(request.POST)
#         if form.is_valid():
#             user = form.save()
#             password = form.cleaned_data.get('password1')
#             user = authenticate(username=user.username, password=password)
#             # user = auth(username=user.username, password=password)
#             login(request, user)

#             return redirect('index')
#     else:
#         form = SignUpForm()
#     return render(request, 'users/sign_up.html', {'form': form})

# sign up render
# def sign_up(request):
#     return render(request, 'sign_up/sign_up.html', {})

# def do_sign_up (request):

#     if request.method != 'POST':
#         username = ''
#         password = ''
#     else:
#         #saving variables from template
#         username = request.POST['inputEmail']
#         userFirstName=request.POST['inputFirstName']
#         userLastName=request.POST['inputLastName']
#         password1 = request.POST['inputPassword1']
#         password2 = request.POST['inputPassword2']
#         address = request.POST['address']
#         phone = request.POST['phone']
#         #validation of information
#         if password1==password2 and username!= ''and password1 !='':
#             try:
#                 user = User.objects.get(username=username)
#                 band = 'UserExist'
#                 httpResponse = render(request, 'sign_up/sign_up.html', {'band':band})

#             except ObjectDoesNotExist:
#                 user = User.objects.create_user(username=username, email=username,password=password1)
#                 user.last_name = userLastName
#                 user.first_name = userFirstName
#                 #create user
#                 user.save()
#                 Customer.objects.create(user=user, phone=phone, main_address=address)
#                 #automatic first login from user
#                 user = authenticate(username=username, password=password1)
#                 httpResponse = render(request, 'index/index.html', {'user':user})
#         elif password1 != password2:
#             band='noMatch'
#             httpResponse = render(request, 'sign_up/sign_up.html', {'band':band})
#         elif username == '':
#             band='nousername'
#             httpResponse = render(request, 'sign_up/sign_up.html', {'band':band})
#         elif password1=='':
#             band='nopassword'
#             httpResponse = render(request, 'sign_up/sign_up.html', {'band':band})
#     return httpResponse

# user index render
# @login_required()
# def index(request):
#     if request.user.has_usable_password():
#         return render(request, 'index/index.html', {})
#     else:
#         return render(request, 'sign_up/new_password.html', {})


# def confirmPassword(request):
#     if request.method == 'POST':
#         password1 = request.POST['inputPassword']
#         password2 = request.POST['confirmPassword']
#         address = request.POST['address']
#         phone = request.POST['phone']
#         if password1==password2 and password1 != '':
#             request.user.set_password(password1)
#             request.user.save()
#             Customer.objects.create(user=request.user, phone=phone, main_address=address)
#             httpResponse = (request, 'index/index.html', {})
#         elif password1 != password2:
#             band='noMatch'
#             httpResponse = (request, 'sign_up/new_password.html',{'band':band})
#         elif password1=='':
#             band='nopassword'
#             httpResponse = render(request, 'sign_up/new_password.html', {'band':band})
#     return httpResponse
