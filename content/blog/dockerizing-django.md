+++
author = "Nicholas Kajoh"
date = 2018-08-15T12:54:00.000Z
draft = false
image = "/content/images/2018/12/chuttersnap-255215-unsplash-sm.jpg"
slug = "dockerizing-django"
tags = ["Docker","Django"]
title = "Dockerizing Django in development and production"

+++


Setting up Docker can sometimes be confusing. There are many little pieces that need to come together for everything to work as expected. Outlined in this post is a simple Docker setup you can use for your Django projects in development and production environments.

TL;DR: Sample project
---------------------

You can [check out the code](https://github.com/nicholaskajoh/dockerized-django) on GitHub.

Dockerfile
----------

    FROM python:3.6-alpine
    
    RUN apk --update add \
        build-base \
        postgresql \
        postgresql-dev \
        libpq \
        # pillow dependencies
        jpeg-dev \
        zlib-dev
    
    RUN mkdir /www
    WORKDIR /www
    COPY requirements.txt /www/
    RUN pip install -r requirements.txt
    
    ENV PYTHONUNBUFFERED 1
    
    COPY . /www/
    

This **Dockerfile** is pretty straightforward. It starts from a Python-Alpine base image, then installs the dependencies that Django needs, notably `postgresql` and `postgresql-dev`. This Django project is setup to use PostgreSQL. If you want to use another database engine like MySQL or MongoDB, you need to install the required adapters/dependencies. Also, if you’re dealing with images (ImageField), you need to install `jpeg-dev` and `zlib-dev` as well (see [Pillow dependencies](https://pillow.readthedocs.io/en/latest/installation.html#building-from-source)).

Afterwards, it installs the packages in _requirements.txt_, then copies everything in the project root to `/www/` where the image would be executed from. `ENV PYTHONUNBUFFERED 1` causes all output to `stdout` to be flushed immediately, so that you can easily see what’s going on inside your Python app from a terminal.

docker-compose.yml
------------------

I almost always use Docker Compose with Docker. With Compose, you can run multiple containers at once, and you don’t have to memorize long Docker commands.

    version: "3"
    services:
      web:
        build: .
        restart: on-failure
        env_file:
          - ./.env
        command: python manage.py runserver 0.0.0.0:8000
        volumes:
          - .:/www
        ports:
          - "8000:8000"
        depends_on:
          - db
      db:
        image: "postgres:10.3-alpine"
        restart: unless-stopped
        env_file:
          - ./.env
        ports:
          - "5432:5432"
        volumes:
          - ./postgres/data:/var/lib/postgresql/data
    

There are two services in this Compose file — web and db. The web service builds the Django app using the _Dockerfile_ in the previous section. A volume is created to map the project directory in the host to the one in the container (`- .:/www`) so that any changes made on the host are mirrored in the container. The `command` parameter uses Django’s dev server to run the app (`python manage.py runserver 0.0.0.0:8000`).

The db service uses a PostgreSQL image and maps PostgreSQL’s data directory to `./postgres/data` in the host, so that DB data is persisted even if the container gets destroyed. This very PostgreSQL image ([the official postgreSQL image](https://hub.docker.com/_/postgres/)) uses several environment variables to configure PostgreSQL, including `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB`.

    # .env
    DEBUG=1
    ALLOWED_HOSTS=*
    SECRET_KEY=secret123
    
    POSTGRES_HOST=db
    POSTGRES_PORT=5432
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=secret123
    POSTGRES_DB=mypgsqldb

The above variables are made available to the services using the `env_file` parameter. The postgres variables are used by both the web and db service (see [the settings.py file in the sample project](https://github.com/nicholaskajoh/dockerized-django/blob/24c452851f3e01e41cbf146c88a7976f089b53fd/dockerizeddjango/settings.py#L56)).

docker-compose.prod.yml
-----------------------

My production configs usually differ a bit from their development counterpart. I use Gunicorn to serve the Django app, and NGINX as a reverse proxy and static/media file server.

This setup, while good for production, is not very convenient in development where the goal is often to _break things and move fast_. Sometimes, I decide to use a managed database service so there’s no need for a Dockerized database server. All these are reflected in my _docker-compose.prod.yml_ file.

    version: "3"
    services:
      web:
        build: .
        restart: on-failure
        env_file:
          - ./.env
        command: gunicorn --bind 0.0.0.0:8080 dockerizeddjango.wsgi
        ports:
          - "8080:8080"
        depends_on:
          - nginx
      nginx:
        image: "nginx"
        restart: always
        volumes:
          - ./nginx/conf.d:/etc/nginx/conf.d
          - ./staticfiles:/static
          - ./mediafiles:/media
        ports:
          - "80:80"
    

The web service in the production Compose file looks identical to one in the development file, except for the `command` parameter (majorly). It uses [Gunicorn](http://gunicorn.org) ([which is more suitable](https://docs.djangoproject.com/en/dev/ref/django-admin/#runserver)) to serve the application (`gunicorn — bind 0.0.0.0:8080 dockerizeddjango.wsgi`).

There’s also an NGINX service. Notice the volume definitions in this service. The first volume maps `/etc/nginx/conf.d` to the `./nginx/conf.d` folder on the host which contains [_dockerizeddjango.conf_](https://github.com/nicholaskajoh/dockerized-django/blob/master/nginx/conf.d/dockerizeddjango.conf).

    # dockerizeddjango.conf
    server {
      listen 80;
      server_name localhost;
    
      # serve static files
      location /static/ {
        alias /static/;
      }
    
      # serve media files
      location /media/ {
        alias /media/;
      }
    
      # pass requests for dynamic content to gunicorn
      location / {
        proxy_pass http://web:8080;
      }
    }
    

This is a very basic Nginx config file. It’s also pretty self-explanatory. It passes requests with `/static` (e.g _example.com/static/virus.js_) and `/media` (e.g _example.com/media/anonymous.jpg_) to the `/static` and `/media` directories on the web container respectively. These directories are mapped to the `/staticfiles` and `/mediafiles` directories on the host where [staticfiles are collected](https://github.com/nicholaskajoh/dockerized-django/blob/24c452851f3e01e41cbf146c88a7976f089b53fd/dockerizeddjango/settings.py#L98) and [media files uploaded](https://github.com/nicholaskajoh/dockerized-django/blob/24c452851f3e01e41cbf146c88a7976f089b53fd/dockerizeddjango/settings.py#L104). Other requests are proxied to Gunicorn.

Did you observe the use of service names in some files? e.g `POSTGRES_HOST=db` and `proxy_pass http://web:8080;`. **db** and **web** resolve to the IP addresses of their containers. This is handled by Docker Compose so that we don’t have to worry about what the IP address of a container is or hardcode IP addresses that might change later.

Use the following command to run the Compose file:

    $ docker-compose -f docker-compose.prod.yml up --build -d
    

The `-f` parameter specifies the production Compose file, _docker-compose.prod.yml_ (Docker Compose defaults to _docker-compose.yml_). `--build` tells Compose to rebuild the images each time the command is run, and the `-d` flag runs the containers in detached mode so that they keep running in the background even when your terminal is closed.

You can run migrations and create an admin user with the following commands:

    $ docker-compose -f docker-compose.prod.yml run web python manage.py migrate
    $ docker-compose -f docker-compose.prod.yml run web python manage.py collectstatic --noinput