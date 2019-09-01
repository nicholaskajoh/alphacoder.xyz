---
title: "Here's a quick Elasticsearch-Kibana setup via Docker for development"
slug: elasticsearch-kibana-docker-development-setup
date: 2019-09-01T06:18:43+01:00
draft: false
tags: ["Elasticsearch"]
---

Are you new to the Elastic stack or configuring a new machine and need an easy way to setup, and a single command to run Elasticsearch & Kibana? Here's a quick Elasticsearch-Kibana setup using Docker for your dev environment.

# Setup
- [Install Docker for your OS](https://docs.docker.com/install/).
- Pull the Docker image for Elasticsearch: `docker pull docker.elastic.co/elasticsearch/elasticsearch:7.3.0` (you can change __7.3.0__ to [the latest or your preferred version](https://www.docker.elastic.co/)).
- Pull the Docker image for Kibana: `docker pull docker.elastic.co/kibana/kibana:7.3.0`.

# Run
```shell
docker container stop es_dev && docker container rm es_dev
docker run \
    --name es_dev \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "discovery.type=single-node" \
    docker.elastic.co/elasticsearch/elasticsearch:7.3.0 &\

docker run \
    --link es_dev:elasticsearch \
    -p 5601:5601 \
    docker.elastic.co/kibana/kibana:7.3.0 &
```

The first command stops the container named `es_dev` (arbitrary) if one exists and removes it. The second command starts a single-node Elasticsearch cluster inside a docker container named `es_dev`, and exposes it on ports 9200 and 9300. The third and last command starts Kibana on port 5601 and links it to the container (`es_dev`) where the Elasticsearch cluster is running. The last two commands are run concurrently.

You can add these three commands to a shell file (e.g _elastic.sh_) in order to run a single command to start Elasticsearch and Kibana i.e `chmod +x elastic.sh && ./elastic.sh` the first time and `./elastic.sh` subsequently.

# Test
- Elasticsearch: `curl http://127.0.0.1:9200/_cat/health` (you should have a status of __green__ if everything went well).
- Kibana: visit __http://localhost:5601__ (the Kibana dashboard should load up).

# Configure
Elasticsearch and Kibana can be configured using YAML. You can create config files and point to them when starting the containers.

- Elasticsearch: add `-v path/to/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml` to `docker run` command.
- Kibana: add `-v path/to/kibana.yml:/usr/share/kibana/config/kibana.yml` to `docker run` command.
