+++
author = "Nicholas Kajoh"
date = 2018-06-28T17:41:00.000Z
draft = false
image = "/content/images/2018/12/pexels-photo-210182.jpeg"
slug = "multiple-apps-one-server-with-docker-and-traefik"
tags = ["Docker","Traefik"]
title = "How to run multiple apps on one server using Docker and Traefik"

+++


Running multiple apps on a single machine has never been easier! In this tutorial, I’ll show you how to run 3 apps on one server using Docker and Traefik.

Use case
--------

Say you’re low on cash and can only rent one server, you can run your website, blog and SaaS app on the same machine (what we’ll do in this tutorial). Or you can run an API (back-end) and SPA (front-end). You can even run two different websites (example1.com and example2.com) if you want.

Docker
------

Docker is the most widely used containerization software today. It allows you bundle code with it’s config and dependencies, making it easy and seamless to deploy your apps on any machine (or several machines). It also helps in development by providing a consistent environment for collaborators on a project. More info here: [https://docs.docker.com](https://docs.docker.com/).

Traefik
-------

Traefik is a HTTP reverse proxy and load balancer that integrates with Docker, Swarm, Kubernetes among other orchestration tools. You can learn more here: [https://docs.traefik.io](https://docs.traefik.io/).

Docker Compose
--------------

We’ll be using Docker via Docker Compose. Docker Compose makes it easy to run multi-container Docker applications. You can configure all your containers in one file and run them at once with a single command. Read more here: [https://docs.docker.com/compose](https://docs.docker.com/compose/).

Project setup
-------------

The 3 apps we’ll be running are a website (static site), a blog and a SaaS app (dasboard-ish). For the sake of demonstration, I just downloaded HTML templates online 👀. So I have a _landing page template_, _blog template_ and _dashboard template_. They’ll all be served with Ngnix 😉.

![](https://cdn-images-1.medium.com/max/800/1*koXKQcVKY4JzHWn44f0tdg.png)

website

![](https://cdn-images-1.medium.com/max/800/1*BgOyioSsTyUEb7cZ7FPzPQ.png)

blog

![](https://cdn-images-1.medium.com/max/800/1*MDwkYroQ_GtErST3OZHlfQ.png)

SaaS app

Here’s the project repo: [**https://github.com/nicholaskajoh/jack**](https://github.com/nicholaskajoh/jack).

Each app is put in it’s own folder, with its own _Dockerfile_. The Dockerfiles are identical since we’re basically just serving static files in all the apps.

    # Dockerfile
    FROM nginx:alpine
    COPY . /usr/share/nginx/html
    

The docker compose file brings everything together under one roof. Here’s how it looks:

    # docker-compose.yml
    version: "3"
    services:
      traefik:
        image: traefik
        command: --web --docker --docker.domain=docker.localhost --logLevel=DEBUG
        ports:
          - "80:80"
          - "8080:8080"
          - "443:443"
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
          - /dev/null:/traefik.toml
      app:
        build: ./app
        volumes:
          - ./app:/usr/share/nginx/html
        labels:
          - "traefik.backend=app-be"
          - "traefik.frontend.rule=Host:app.localhost"
      blog:
        build: ./blog
        volumes:
          - ./blog:/usr/share/nginx/html
        labels:
          - "traefik.backend=blog-be"
          - "traefik.frontend.rule=Host:blog.localhost"
      website:
        build: ./website
        volumes:
          - ./website:/usr/share/nginx/html
        labels:
          - "traefik.backend=website-be"
          - "traefik.frontend.rule=Host:localhost"
    

As can be seen, traefik itself is run in a container. The domain is set to localhost and the ports 80, 8080 and 443 are published. The web flag (`--web`) under command parameter tells traefik to run its API dashboard which will be exposed on port 8080.

Traefik can be configured using a [_traefik.toml_](https://github.com/nicholaskajoh/jack/blob/master/traefik/traefik.toml) file. It can also pick configs from service labels. As such, we specified the `traefik.backend` and `traefik.frontend.rule` configs using labels. `traefik.backend` specifies the service to handle requests from `traefik.frontend.rule`. So if we go to _app.localhost_, we will be served content from the app service. Same with _localhost_ and website, and _blog.localhost_ and blog.

**Try it out:** clone [Jack](https://github.com/nicholaskajoh/jack), run `docker-compose up` and visit _localhost_, _app.localhost_ and _blog.localhost_.

Traefik dashboard
-----------------

![](https://cdn-images-1.medium.com/max/800/1*9LsK-LbgDQ0_tFTmjNAdEw.png)

The Traefik dashboard displays useful information including the available front-ends and back-ends, and the health of the containers. You can password protect the dashboard so only authorized persons can access it.

SSL
---

Traefik can handle SSL for you automatically. This guide ([https://docs.traefik.io/user-guide/docker-and-lets-encrypt](https://docs.traefik.io/user-guide/docker-and-lets-encrypt/)) explains the configuration process using Let’s Encrypt.

**_NB:_** _I added SSL configs in_ [_docker-compose.prod.yml_](https://github.com/nicholaskajoh/jack/blob/master/docker-compose.prod.yml) _and_ [_traefik.toml_](https://github.com/nicholaskajoh/jack/blob/master/traefik/traefik.toml) _for use in production._

Scaling and load balancing
--------------------------

Traefik load balances multiple instances of a given service automatically. You can use the scale flag/parameter in docker compose to run multiple instances of your containers.