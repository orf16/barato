from rest_framework import viewsets
from app.models import Customer, List, Category, Product, ListProduct
from .serializers import ListSerializer,ProductSerializer,ListProductSerializer
from .pagination import ProductPagination

class ListViewSet(viewsets.ModelViewSet):
    queryset = List.objects.all()
    serializer_class = ListSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    pagination_class = ProductPagination

class ListProductViewSet(viewsets.ModelViewSet):
    queryset = ListProduct.objects.all()
    serializer_class = ListProductSerializer

# class CustomerViewSet(viewsets.ModelViewSet):
#     queryset = Customer.objects.all()
#     serializer_class = CustomerSerializer

# class CategoryViewSet(viewsets.ModelViewSet):
#     queryset = Category.objects.all()
#     serializer_class = CategorySerializer