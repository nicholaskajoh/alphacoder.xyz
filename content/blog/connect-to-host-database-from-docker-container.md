---
title: "How to connect to a host's database from inside a Docker container"
slug: "connect-to-host-database-from-docker-container"
date: 2019-09-01T06:29:54+01:00
draft: false
tags: ["Docker"]
---

There are several ways to interact with a DB when developing using Docker:

1. Connect to an online DB instance.
2. Connect to a local DB running in another container.
3. Connect to a local DB running on a host machine (e.g your laptop).

The first option can be easy and fast to setup i.e if you're using a managed DB service. But these conveniences come at a monetary cost. Plus, you won't be able to develop without an internet connection.

While the second and third options are similar in the sense that the DB runs locally, using a DB running on the host might be a more convenient option if you have that already setup, or if you don't want to have to mount a volume on the host in order to persist your data or run an additional container.

Connecting to a host DB from a container via localhost doesn't work because both container and host have their own localhosts. When you try to connect to localhost, it fails because no DB instance is running in the container's localhost as you might imagine. You need to go outside the container by using your computer's internal IP address.

You can point to your host's DB by setting the following environment variable in your container for instance.

Docker for Mac/Windows:
```
DB_HOST=host.docker.internal
```

Linux:
```
DB_HOST=$(ip route show default | awk '/default/ {print $3}')
```