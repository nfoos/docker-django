Docker Django
=============

Build the docker image(s)
```
docker-compose build
```

Edit docker-compose.yml, set the database credentials accordingly
```
services:
  db:
    ...
    environment:
      - POSTGRES_DB=mysite_db
      - POSTGRES_USER=mysite_user
      - POSTGRES_PASSWORD=mysite_pass
```

Start the database container
```
docker-compose up -d db
```

Create a Django project, substitute *mysite* for a better name from here on
```
docker-compose run --rm web django-admin startproject mysite .
```

Edit mysite/settings.py, make sure database credentials match *docker-compose.yml*
```
ALLOWED_HOSTS = ['*']
...
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'HOST': 'db',
        'NAME': 'mysite_db',
        'USER': 'mysite_user',
        'PASSWORD': 'mysite_pass',
    }
}
...
TIME_ZONE = 'America/Indianapolis'
```

Start the Django app
```
docker-compose up -d web
```

Apply database migrations
```
docker-compose exec web python manage.py migrate
```

Verify things are working by visiting the site at [http://localhost:8000/](http://localhost:8000/)

Create a superuser
```
docker-compose exec web python manage.py createsuperuser
```

Access admin app at [http://localhost:8000/admin/](http://localhost:8000/admin/), login as the superuser


Create a Django app, substitute *myapp* for a better name from here on
```
docker-compose exec web python manage.py startapp myapp
```

Register the app in *mysite/settings.py*
```
INSTALLED_APPS = [
    ...
    'myapp.apps.MyappConfig',
]

```

Check project for potential problems
```
docker-compose exec web python manage.py check
```

Run an interactive shell
```
docker-compose exec web python manage.py shell
```

Create database migrations
```
docker-compose exec web python manage.py makemigrations
```

Run Django tests
```
docker-compose exec web python manage.py test
```

Run tests using pytest
```
docker-compose run --rm test pytest
```

Edit pytest.ini, set DJANGO_SETTINGS_MODULE and cov modules accordingly
```
[pytest]
DJANGO_SETTINGS_MODULE=mysite.settings
addopts = -vv  --color=auto --cov=myapp --cov=mysite --cov-report=term-missing:skip-covered
```
