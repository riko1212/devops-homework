from django.http import JsonResponse
from django.db import connection


def health(request):
    try:
        connection.ensure_connection()
        db_status = "connected"
    except Exception:
        db_status = "unavailable"

    return JsonResponse({"status": "ok", "db": db_status})
