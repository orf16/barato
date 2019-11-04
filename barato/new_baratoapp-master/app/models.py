from django.db import models
from django.contrib.auth.models import User
from django.dispatch import receiver
from django.db.models.signals import post_save

         
    

class Customer(models.Model):
  
    user  = models.OneToOneField(User, on_delete=models.CASCADE, related_name='customer')
    phone = models.CharField(max_length=64)
    main_address = models.TextField(max_length=128)
    locality = models.CharField(max_length=64,default='')
    city = models.CharField(max_length=64, default='')

    # -- Metodo que instancia un obeto tipo customer en respuesta de crear un nuevo usuario
    @receiver(post_save, sender=User)
    def update_user_customer(sender, instance, created, **kwargs):
        if created:
            Customer.objects.create(user=instance)
        instance.customer.save()

    def __str__(self):
        return self.user.username

class List(models.Model):
    name = models.CharField(max_length=64)
    created_at  = models.DateField(auto_now_add=True)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    updated_at  = models.DateField(auto_now=True)

    def __str__(self):
        return self.name

class Category(models.Model):
    name = models.CharField(max_length=128)
    order = models.PositiveSmallIntegerField()

    def __str__(self):
        return self.name

class Product(models.Model):
    name  = models.CharField(max_length=255)
    unit_value = models.CharField(max_length=32, blank=True)
    unit  = models.CharField(max_length=32, blank=True)
    app_product = models.CharField(max_length=255, blank=True)   # Id del producto en Java
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='categories')

    def __str__(self):
        return self.name

class ListProduct(models.Model):
    list_id = models.ForeignKey(List, on_delete=models.CASCADE, related_name='lists')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='products')
    quantity = models.PositiveSmallIntegerField(blank=True, default=1)
    created_at = models.DateField(auto_now_add=True)

    def __str__(self):
        return str(self.created_at)