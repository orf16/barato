from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views
import django.contrib.auth
from .forms import SingInForm
from django.conf import settings

urlpatterns = [

    #index 
    path('',views.IndexView.as_view(), name='index'),

    #api
    path('api/', include('app.api.urls')),

    #login
    path('sign_in/', auth_views.LoginView.as_view(
        template_name='users/sign_in.html',
        form_class=SingInForm),
        name ='sign_in'),
    #redirect_authenticated_user=True (redirecciona al login success url si el usiario esta autenticado)
    
    #logout
    path('logout/', auth_views.LogoutView.as_view(
        template_name='users/logout.html',
        next_page= 'sign_in'), 
        name='logout'),



    path('adminbarato/', views.IndexView.as_view(template_name='users/admin.html'), name='adminbarato'),

    #view for sign up
    path('sign_up/', views.SignUpView.as_view(), name='sign_up'),

    #Confirm Password
    path('new_password/', views.NewPasswordView.as_view(), name= 'new_password'),
  
    #social login
    path('', include('social_django.urls', namespace='social')),

    #autocompletar search bar
    path('search_bar/',views.search_bar),

   #password recovery urls
    path('users/password/change/', 
        auth_views.PasswordChangeView.as_view(
        template_name='users/password_change_form.html'), 
        name='password_change'),

    path('users/password/change/done/',
        auth_views.PasswordChangeDoneView.as_view(
        template_name='users/password_change_done.html'), 
        name='password_change_done'),
        
    path('users/password/reset/password_reset', 
        auth_views.PasswordResetView.as_view(
        template_name='users/password_reset_form.html',
        html_email_template_name='users/password_reset_email.html'), 
        name='password_reset'),

    path('users/password/reset/password_reset_done', 
        auth_views.PasswordResetDoneView.as_view(
        template_name='users/password_reset_done.html'), 
        name='password_reset_done'),

    path('users/password/reset/<uidb64>/<token>/', 
        auth_views.PasswordResetConfirmView.as_view(
        template_name='users/password_reset_confirm.html'), 
        name='password_reset_confirm'),

    path('users/password/reset/complete/', 
        auth_views.PasswordResetCompleteView.as_view(
        template_name='users/password_reset_complete.html'), 
        name='password_reset_complete'),

    path('users', views.getUsuarios ),

    path(r'^complete/(?P<backend>[^/]+){0}$', views.authenticateSocial )

      #user index
    # path('', views.index, name='index'),     

    #view for login
    # path('', views.sign_in, name='sign_in'),

  # path('new_password/', views.confirmPassword, name= 'new_password'),

    # #do sign up
    # path('do_sign_up/', views.do_sign_up, name='do_sign_up'),
              
#URLs for logout
    # path('logout/', views.logOut, name='logout'),


  #Confirm Password
    # path('passwd/', views.confirmPassword, name= 'passwd'),

 
       #password recovery urls
    # path('', include('django.contrib.auth.urls')),
    # path('reset/password_reset',auth_views.password_reset,{'template_name': 'Registration/password_reset_form.html', 
    # 'email_template_name':'Registration/password_reset_email.html'},name='password_reset'),
    # path('reset/password_reset_done', auth_views.password_reset_done,{'template_name': 'Registration/password_reset_done.html'},
    # name='password_reset_done' ),
    # path('reset/(?P<uidb64>[0-94-Za-z_\-]+)/(?P<token>.+)/$',auth_views.password_reset_confirm,{'template_name':'Registration/password_reset_confirm.html'},
    # name="password_reset_confirm"),
    # path('reset/done',auth_views.password_reset_complete,{'template_name':'Registration/password_reset_complete.html'},
    # name="password_reset_complete"),

]
