+++
author = "Nicholas Kajoh"
date = 2018-01-11T14:39:00.000Z
draft = false
image = "/content/images/2018/12/rawpixel-296613-unsplash-sm.jpg"
slug = "dead-simple-react-django-setup"
tag = ["React","Django"]
title = "Here’s a dead simple React-Django setup for your next project"

+++


There are several reasons why you might not want to have separate code bases for the front and back end of your app. For one, the project becomes more portable since it can live in one repository/folder. Then again, everything can be deployed on just one server.

**TL;DR: [https://github.com/nicholaskajoh/React-Django](https://github.com/nicholaskajoh/React-Django).**

Here’s a simple setup for creating a React-Django project. With just a few tweaks, you can swap out React for Angular or Vue.js and everything would work fine.

Django
------

Follow the steps below to setup Django:

*   Have Python and pip installed on your computer.
*   Install [virtualenv and virtualenvwrapper](http://virtualenvwrapper.readthedocs.io/en/latest/install.html) by running `pip install virtualenvwrapper`.
*   Create a virtual environment for the project using `mkvirtualenv name-of-virtual-env`.
*   Run `workon name-of-virtual-env` to activate the virtual environment.
*   Install Django with `pip install django`.
*   Start a django project by running `django-admin startproject nameOfProject`.
*   Change directory to the project root and create a new app with `django-admin startapp mynewapp`.
*   Add _mynewapp_ to installed apps in _settings.py_.
*   Run app with `python manage.py runserver`.

See the [official Django installation guide](https://docs.djangoproject.com/en/dev/topics/install/) for more info.

React
-----

We’ll be using [Create React App](https://github.com/facebookincubator/create-react-app) in this setup. Feel free to use your preferred method of/tool for setting up a React project.

*   Have Node.js and NPM installed.
*   Run `npm install -g create-react-app`.
*   Create a new app with `create-react-app name-of-project`.
*   Copy/cut all the contents of the React app (in _name-of-project_ folder) and paste in the root of the Django project.\*\*
*   Run app with `npm start` from the project root.

Configure
---------

If you followed all the instructions above, you should have both React and Django apps in one folder. See the starred step (\*\*) under the _React_ heading. Good!

The React app is the SPA (Single Page App) while the Django app is the API. Let’s do some config, shall we?

The goal is to expose two sets of urls/routes. One for the SPA (e.g _example.com_, _example.com/home_, etc) and the other for the API (e.g _example.com/api/posts_, _example.com/api/post/1_, etc).

The React-Django app would be deployed on a Python web server, so we can easily achieve this using Django.

#### Step 1: build

Run `npm run build`. This creates a folder named _build_ in the project root containing a production-ready version of the React app.

#### Step 2: settings.py

Add the _build_ folder to template directories in _settings.py_ so that Django can load _/build/index.html_ as a template.

    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    TEMPLATES = [
        {
            # ...
            'DIRS': [
                os.path.join(BASE_DIR, 'build')
            ],
            # ...
        }
    ]
    

Also add _/build/static_ to static files directory so that `collectstatic` can copy the css and js files.

    STATICFILES_DIRS = [
        os.path.join(BASE_DIR, 'build/static'),
    ]
    

#### Step 3: urls.py

Add pattern to return _/build/index.html_ in _urls.py_ as follows:

    from django.contrib import admin
    from django.urls import path, re_path
    from django.views.generic import TemplateView
    
    urlpatterns = [
        path('admin/', admin.site.urls),
        # path('api/', include('mynewapp.urls')),
        re_path('.*', TemplateView.as_view(template_name='index.html')),
    ]
    

Run Django’s dev server (`python manage.py runserver`) to test the app.

Angular, Vue.js, etc
--------------------

As you’ve seen with React, all you need to do is make a build available to Django, then configure Django to handle API requests and React to handle normal web page routes. You can use the same steps to setup Angular, Vue.js etc with Django.

Repo
----

Check out the code for this tutorial here: [https://github.com/nicholaskajoh/React-Django](https://github.com/nicholaskajoh/React-Django).

Deploy
------

Deploying the React-Django app is a story for another day. The process largely depends on your hosting environment and workflow. I made [a post on deploying it to Heroku](https://alphacoder.xyz/deploy-react-django-app-on-heroku/).