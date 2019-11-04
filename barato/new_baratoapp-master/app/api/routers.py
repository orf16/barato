from rest_framework import routers
from .viewsets import  ListViewSet, ProductViewSet,ListProductViewSet

router = routers.DefaultRouter()

router.register(r'list', ListViewSet)
router.register(r'product', ProductViewSet)
router.register(r'listproduct', ListProductViewSet)
