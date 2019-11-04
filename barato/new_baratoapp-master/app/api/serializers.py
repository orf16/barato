from rest_framework import serializers
from app.models import Customer, List, Category, Product, ListProduct


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

class ListProductSerializer(serializers.ModelSerializer):
    product= ProductSerializer()
    class Meta:
        model = ListProduct
        fields = ('list_id','product','quantity')


class ListSerializer(serializers.ModelSerializer):
    class Meta:
        model = List
        fields = '__all__'
