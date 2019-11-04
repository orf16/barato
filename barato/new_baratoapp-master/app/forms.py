from django import forms
from django.contrib.auth.forms import UserCreationForm,AuthenticationForm
from django.contrib.auth.models import User
from django.db import models

LOCALITIES = (
    ('Antonio Narino', 'Antonio Narino'),
    ('Barrios Unidos', 'Barrios Unidos'),
    ('Bosa', 'Bosa'),
    ('Chapinero', 'Chapinero'),
    ('Engativa', 'Engativa'),
    ('Fontibon', 'Fontibon'),
    ('Kennedy', 'Kennedy'),   
    ('La Candelaria', 'La Candelaria'),
    ('Los Martires', 'Los Martires'),
    ('Puente Aranda', 'Puente Aranda'),
    ('Rafael Uribe', 'Rafael Uribe'),
    ('San Cristobal', 'San Cristobal'),
    ('Santa Fé', 'Santa Fé'), 
    ('Simon Bolivar', 'Simon Bolivar'),
    ('Suba', 'Suba'),
    ('Sumapaz', 'Sumapaz'),
    ('Teusaquillo', 'Teusaquillo'),
    ('Tunjuelito', 'Tunjuelito'), 
    ('Usme', 'Usme'),
)

CITIES=(
    ('Bogotá', 'Bogotá'),
)

# -- Formulario para el registro de nuevos usuarios --
class SignUpForm(UserCreationForm):
   
    city = forms.ChoiceField(initial=CITIES[0][0], choices=CITIES,label='Ciudad')
    locality = forms.ChoiceField(initial=LOCALITIES[0][0], choices=LOCALITIES,label='Localidad')
    main_address = forms.CharField(label='Dirección')
    phone = forms.CharField(label='Teléfono')  
    
    #username=forms.CharField(label='Usuario')
    class Meta:
        model = User
        fields = ('username','first_name','last_name', 'email','city','locality','main_address','phone','password1', 'password2', )
    
    def clean_email(self):
        email = self.cleaned_data.get("email")
        qs = User.objects.filter(email__iexact=email)
        if qs.exists():
            raise forms.ValidationError("La dirección de correo electrónico ya se encuentra registrada.")
        return email    

    def __init__(self, *args, **kwargs):
        super(SignUpForm, self).__init__(*args, **kwargs)
        if 'username' in self.fields:
            self.fields['username'].help_text = None

    def save(self, commit=True):
        user = super(SignUpForm, self).save(commit=False)       
        if commit:
            #se crea usuario y customer automaticamente por el @receiver del modelo
            user.save() 
        return user


# -- Formulario para registrar datos extras del usuarios ingresados por redes sociales --
class NewUserPasswordForm(SignUpForm):
    class Meta:
        model = User
        fields = ('city','locality','main_address','phone','password1', 'password2' )


class SingInForm(AuthenticationForm):
     def __init__(self, *args, **kwargs):
        super(SingInForm, self).__init__(*args, **kwargs)
        if 'username' in self.fields:
            self.fields['username'].label = 'Usuario o correo electrónico'