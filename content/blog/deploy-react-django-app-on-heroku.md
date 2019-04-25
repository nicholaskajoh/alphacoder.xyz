+++
author = "Nicholas Kajoh"
date = 2018-01-30T11:52:00.000Z
draft = false
slug = "deploy-react-django-app-on-heroku"
tags = ["React","Django","Heroku"]
title = "Deploy your React-Django app on Heroku"
+++


This is a follow up to my post on _[setting up a React-Django web app](/dead-simple-react-django-setup/)_. You can take a quick glance if you’ve not seen it yet.

**TL;DR: The setup is deployed at** [**http://react-django.herokuapp.com**](http://react-django.herokuapp.com/) **(nothing much there actually) and the code at** [**https://github.com/nicholaskajoh/React-Django**](https://github.com/nicholaskajoh/React-Django)**.**

* * *

We’re going to be deploying the app we setup in the previous post on Heroku. Heroku is a popular cloud hosting platform (PaaS) and offers a generous free tier which we’ll be using.

Heroku dashboard
----------------

First things first. You need a Heroku account. Head over to [Heroku.com](https://heroku.com) and sign up/login, then go to your dashboard at [https://dashboard.heroku.com](https://dashboard.heroku.com) and create a new app.

![](/images/dply-dj/heroku-dashboard.png)

Heroku CLI
----------

There are a couple deploy methods to choose from on Heroku (visit the _deploy_ tab on the app page on the dashboard). Here, we’ll use the _Heroku Git_ method via the _Heroku CLI_. You can use [this guide to learn how to set up Heroku CLI on your OS](https://devcenter.heroku.com/articles/heroku-cli).

Now, let’s link our project to the Heroku app we created using the Heroku CLI and Git.

*   Initialize a Git repository in the root folder of the project with `git init` (you need to have Git installed on your computer).
*   Login with your Heroku account on the CLI using `heroku login`.
*   Add the Heroku remote via `heroku git:remote -a your-heroku-app`.

![](/images/dply-dj/link-app-to-heroku.png)

I already initialized Git in the project prior to this.

Heroku buildpacks
-----------------

The React app build process depends on NPM, so we need Node.js. We also need Python to run Django.

Heroku uses [buildpacks](https://devcenter.heroku.com/articles/buildpacks) to transform deployed code into slugs which can be executed by Dynos (server instances on Heroku). We’ll be needing two buildpacks. One for Node and another for Python.

Our app would run on a Python server, even though we’ll use Node/NPM to build/bundle the React frontend. So the Python buildpack will be the main one in our config. The main buildpack determines the process type of the Heroku app. You can [read about multiple buildpacks](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app) to understand how they work.

You can add buildpacks via the Heroku CLI. Head back to your terminal and run the following to set/add the buildpacks we need.

```shell
heroku buildpacks:set heroku/python
```

Now add the buildpack for Node.js.

```shell
heroku buildpacks:add --index 1 heroku/nodejs
```

We can see the buildpacks we’ve added by running `heroku buildpacks`. The last buildpack on the list determines the process type of the app.

![](/images/dply-dj/buildpacks.png)

package.json
------------

We need to tell the Node.js buildpack to build the React app after it has installed Node and NPM. We can do this by adding the build command `npm run build` in the _postinstall_ hook.

![](/images/dply-dj/package-json.png)

See postinstall under scripts

Notice that I specified Node and NPM versions in _engines_. The buildpack will install these exact versions. It’s highly recommended you use the versions running on your PC to avoid errors from a version that might be incompatible with your code.

Procfile
--------

Create a file called _[Procfile](https://devcenter.heroku.com/articles/procfile)_ (no file extension) in the project root and add the following code:

```
release: python manage.py migrate
web: gunicorn reactdjango.wsgi --log-file -
```

Replace `reactdjango.wsgi` with `YOUR-DJANGO-APP-NAME.wsgi`.

requirements.txt
----------------

The Python buildpack, after installing Python looks for _requirements.txt_ to install the dependencies in it. Add the following to the requirements file, including all the other dependencies your Django app needs.

```
django>=2.1.2
gunicorn==19.7.1
whitenoise==3.3.1
```

**PS: Whitenoise helps to serve static files and Gunicorn is the HTTP server we’ll be using.**

By the way, you can specify the Python version you want by adding it to a file named _runtime.txt_ in the project root.

```
python-3.5.2
```
Configure whitenoise to serve static files by doing the following:

Add _static root_ and _static files storage_ in _settings.py_

```python
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_STORAGE = 'whitenoise.django.GzipManifestStaticFilesStorage'
```

Add whitenoise to your _wsgi.py_ file.

```python
import os
from django.core.wsgi
import get_wsgi_application
from whitenoise.django import DjangoWhiteNoise

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "reactdjango.settings")

application = get_wsgi_application()
application = DjangoWhiteNoise(application)
```

Allowed hosts
-------------

In your _settings.py_, you need to add your Heroku domain to allowed hosts.

```python
ALLOWED_HOSTS = ['react-django.herokuapp.com', '127.0.0.1:8000']
```

**NB: I personally prefer to add allowed hosts using environment variables e.g with** [**python-dotenv**](https://github.com/theskumar/python-dotenv)**.**

Commit, push
------------

It’s time to commit and push the changes. Phew!

```shell
git add .
git commit -m "blah blah blah"
git push heroku master
```

After the build is done and your app has been released, visit _YOUR-APP-NAME.herokuapp.com_. Neat!

_Two libraries you might find really helpful when building your Django API are_ [_Django Rest Framework_](http://www.django-rest-framework.org/) _and_ [_Django CORS Headers_](https://github.com/ottoyiu/django-cors-headers/)_. You should check them out!_

If you had any issues deploying please share in the comments. A lot of times, things don’t work the first time.