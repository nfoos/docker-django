Docker Django
=============

This repo serves as a skeleton for starting new Django projects running in Docker. The main image is based from an official Python 3 Alpine Linux image. The Docker Compose config also provides services for a PostgreSQL server and a container for running tests.

Quickstart Guide
----------------

### Edit docker-compose.yml
Set the database credentials accordingly, the database and user will be created when the db container initializes.
```
services:
  db:
    ...
    environment:
      - POSTGRES_DB=mysite_db
      - POSTGRES_USER=mysite_user
      - POSTGRES_PASSWORD=mysite_pass
```

### Start the db service
```
docker-compose up -d db
```

### Build the docker image
```
docker-compose build web
```

### Create a Django project
Substitute *mysite* for a better name from here on
```
docker-compose run --rm web django-admin startproject mysite .
```

### Edit mysite/settings.py
Make sure database credentials match *docker-compose.yml*
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

### Start the web service
```
docker-compose up -d web
```

### Apply database migrations
```
docker-compose exec web python manage.py migrate
```

### Create a Django app
Substitute *myapp* for a better name from here on
```
docker-compose exec web python manage.py startapp myapp
```

### Register the app in *mysite/settings.py*
```
INSTALLED_APPS = [
    ...
    'myapp.apps.MyappConfig',
]

```

### Create a superuser
```
docker-compose exec web python manage.py createsuperuser
```

### Verify things are working
Visit the site at [http://localhost:8000/](http://localhost:8000/)
Access admin app at [http://localhost:8000/admin/](http://localhost:8000/admin/)

Useful Commands
---------------

### Check project for potential problems
```
docker-compose exec web python manage.py check
```

### Run an interactive shell
```
docker-compose exec web python manage.py shell
```

### Create database migrations
```
docker-compose exec web python manage.py makemigrations
```

### Run Django tests
```
docker-compose exec web python manage.py test
```

Using pytest
------------
Note that the [pytest discovery](https://docs.pytest.org/en/latest/goodpractices.html#conventions-for-python-test-discovery) differs from [Django/unittest discovery](https://docs.python.org/3/library/unittest.html#test-discovery).

### Edit pytest.ini
Set DJANGO_SETTINGS_MODULE and cov modules accordingly
```
[pytest]
DJANGO_SETTINGS_MODULE=mysite.settings
addopts = -vv  --color=auto --cov=myapp --cov=mysite --cov-report=term-missing:skip-covered
```

### Run tests
```
docker-compose run --rm test pytest
```
