import os
import sys

path='/var/www/barato'

if path not in sys.path:
  sys.path.append(path)

os.environ['DJANGO_SETTINGS_MODULE'] = 'barato.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
