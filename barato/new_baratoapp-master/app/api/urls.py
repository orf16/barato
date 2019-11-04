from django.urls import path,include
from django.contrib import admin
from .routers import router

urlpatterns = [


path('', include(router.urls)),  
]