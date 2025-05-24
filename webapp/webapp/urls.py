from django.contrib import admin
from django.urls import path
from django.http import JsonResponse

def demo_view(request):
    return JsonResponse({"message": "Hello, this is demo"})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/demo/', demo_view),
]
