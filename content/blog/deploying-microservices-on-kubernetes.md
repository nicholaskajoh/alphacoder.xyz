+++
author = "Nicholas Kajoh"
draft = true
date = 2019-01-22T20:08:59+01:00
slug = "deploy-microservices-on-kubernetes"
title = "Deploy microservices on Kubernetes"
tag = ["Kubernetes", "Microservices", "Docker", "GKE", "GCP"]
+++


Kubernetes (AKA k8s) has gained [widespread adoption](https://kubernetes.io/case-studies/) in recent years as a platform for microservices due to its ability to seamlessly automate app deployment at scale. [Pinterest](http://pinterest.com) uses [a suite of over 1000 microservices](https://www.cncf.io/case-study-pinterest/) to power their "discovery engine". Imagine having to configure and manage servers to run these services manually. It's an Engineer's nightmare to say the least.

Kubernetes bills itself as "a portable, extensible open-source platform for managing containerized workloads and services". In simple terms, Kubernetes helps to automate the deployment and management of containerized applications. This means we can package an app (code, dependencies and config) [in a container](https://www.docker.com/resources/what-container) and hand it over to Kubernetes to deploy and scale without worrying about our infrastructure. Under the hood, Kubernetes decides where to run what, monitors the systems and fixes things if something goes wrong.

# Microservice architecture
I particularly like [James Lewis' and Martin Fowler's definition of microservices](https://martinfowler.com/microservices/) as it points out why Kubernetes is such a good solution for the architecture. "The microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API. These services are built around business capabilities and independently deployable by __fully automated deployment machinery__. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies". Kubernetes is in fact a "fully automated deployment machine" that provides a powerful abstraction layer atop server infrastructure.

# Common Kubernetes terms
Below are some common terms associated with Kubernetes.

- __Node:__ A node is a single machine in a Kubernetes cluster. It can be a virtual or physical machine.
- __Cluster:__ A cluster consists of at least one master machine and multiple worker machines called nodes.
- __Pod:__ A pod is the basic unit of computing in Kubernetes. Containers are not run directly. Instead, they are wrapped in a pod.
- __Deployment:__ A deployment is used to manage a pod or set of pods. Pods are typically not created or managed directly. Deployments can automatically spin up any number of pods. If a pod dies, a deployment can automatically recreate it as well.
- __Service:__ Pods are mortal. Consumers should however not be burdened with figuring out what pods are available and how to access them. Services keep track of all available pods of a certain type and provide a way to access them.

# Yoloo
In this tutorial, we'll be deploying a simple microservices app called Yoloo on [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/), a managed Kubernetes service on Google Cloud Platform. Yoloo uses a pre-trained YOLO ([You Only Look Once](https://www.youtube.com/watch?v=Cgxsv1riJhI)) model to detect common objects such as bottles and humans in an image. It comprises two microservices, _detector_ and _viewer_. The detector service is a Python/Flask app which takes an image and passes it through the YOLO model to identify the objects in it. The viewer service is a PHP app that acts as a front-end by providing a User Interface for uploading and viewing the images. The app is built to use two external, managed services: Cloudinary for image hosting and Redis for data storage. The source code is available [on my GitHub](https://github.com/nicholaskajoh/microservices).

[Download](https://github.com/nicholaskajoh/microservices/archive/master.zip) or clone the project with Git: `git clone https://github.com/nicholaskajoh/microservices.git`.

Detector service Dockerfile.

    FROM python:3.6-stretch
    EXPOSE 8080

    RUN mkdir /www
    WORKDIR /www
    COPY requirements.txt /www/
    RUN pip install -r requirements.txt

    ENV PYTHONUNBUFFERED 1

    COPY . /www/
    CMD gunicorn --bind 0.0.0.0:8080 wsgi

Viewer service Dockerfile.

    FROM php:7.2-apache
    EXPOSE 80

    COPY . /var/www/html/

Download the YOLO weights in the detector directory.
    
    cd detector/ && wget https://pjreddie.com/media/files/yolov3.weights

Change directory to `viewer/` and install the PHP dependencies. You need to have [PHP](https://www.apachefriends.org/index.html) and [Composer](https://getcomposer.org) installed.

    composer install

# Google Cloud Platform (GCP)
Visit https://console.cloud.google.com/home/dashboard and create a new project. You need to have a Google account.

__NB:__ Google offers [a tier with $300 free credit](https://cloud.google.com/free/) (for 1 year) to use any GCP product you want.

![](/images/ms-k8s/new-project-gcp.jpg)
_Create a new project on Google Cloud Platform_

__NB:__ Make sure you [enable billing](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_new_project) for your project.

Go to the [Kubernetes section](https://console.cloud.google.com/kubernetes) of GCP and create a new _standard_ cluster. GKE uses VM instances on Google Compute Engine as nodes in the cluster.

![](/images/ms-k8s/new-cluster-gke.jpg)
_Create a new k8s cluster_

# Google Container Registry (GCR)
Kubernetes uses container images to launch pods. Images need to be stored in a registry where they can be pulled from. GCP provides a registry, the [Google Container Registry](https://cloud.google.com/container-registry/), which can be used to store Docker images. Let's build the images for the detector and viewer services and push them to GCR.

- Install [Google Cloud SDK](https://cloud.google.com/sdk/install) for your OS.
- Configure docker to use the `gcloud` CLI as a credential helper: `gcloud auth configure-docker`. You only need to do this once.
- Build the docker images for the microservices: `docker build -t detector-svc detector/` and `docker build -t viewer-svc viewer/`.
- Tag the images with their registry names: `docker tag detector-svc gcr.io/{PROJECT_ID}/detector-svc` and `docker tag viewer-svc gcr.io/{PROJECT_ID}/viewer-svc`. `PROJECT_ID` is your GCP console project ID.
- Push the docker images to GCR: `docker push gcr.io/{PROJECT_ID}/detector-svc` and `docker push gcr.io/{PROJECT_ID}/viewer-svc`.

# Deployments
The detector and viewer services contain deployment files, `detector-deployment.yaml` and `viewer-deployment.yaml` respectively, which tell k8s what workloads we want to run. They are written in [YAML](https://en.wikipedia.org/wiki/YAML).

Detector service deployment.


Viewer service deployment.


# Services
The k8s services (not to be confused with microservices) in detector and viewer, `detector-service.yaml` and `viewer-service.yaml`, share traffic among a set of replicas and provide an interface for other applications to access them. The detector service's k8s service is a 

# kubectl
kubectl is a CLI tool for . To get Kubernetes to run our microservices, we need to apply our deployments and services. 