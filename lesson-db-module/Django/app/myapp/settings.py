import os

SECRET_KEY = os.environ.get("SECRET_KEY", "django-insecure-local-dev-key")
DEBUG = os.environ.get("DEBUG", "False") == "True"
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.contenttypes",
    "django.contrib.auth",
    "health",
]

MIDDLEWARE = [
    "django.middleware.common.CommonMiddleware",
]

ROOT_URLCONF = "myapp.urls"
WSGI_APPLICATION = "myapp.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "HOST": os.environ.get("POSTGRES_HOST", "localhost"),
        "PORT": os.environ.get("POSTGRES_PORT", "5432"),
        "NAME": os.environ.get("POSTGRES_DB", "myappdb"),
        "USER": os.environ.get("POSTGRES_USER", "myappuser"),
        "PASSWORD": os.environ.get("POSTGRES_PASSWORD", "myapppass"),
    }
}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
