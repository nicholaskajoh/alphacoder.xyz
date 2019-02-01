+++
author = "Nicholas Kajoh"
draft = false
date = 2019-02-01T16:44:09.460Z
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
- Login: `gcloud auth login`.
- Configure docker to use the `gcloud` CLI as a credential helper: `gcloud auth configure-docker`. You only need to do this once.
- Build the docker images for the microservices: `docker build -t detector-svc detector/` and `docker build -t viewer-svc viewer/`.
- Tag the images with their registry names: `docker tag detector-svc gcr.io/{PROJECT_ID}/detector-svc` and `docker tag viewer-svc gcr.io/{PROJECT_ID}/viewer-svc`. `PROJECT_ID` is your GCP console project ID.
- Push the docker images to GCR: `docker push gcr.io/{PROJECT_ID}/detector-svc` and `docker push gcr.io/{PROJECT_ID}/viewer-svc`.

# Deployments
The detector and viewer services contain deployment files, `detector-deployment.yaml` and `viewer-deployment.yaml` respectively, which tell k8s what workloads we want to run.

Detector service deployment.

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: detector-svc-deployment
    spec:
      replicas: 3
      minReadySeconds: 15
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxUnavailable: 1
          maxSurge: 1
      template:
        metadata:
          labels:
            app: detector-svc
        spec:
          containers:
            - image: gcr.io/{PROJECT_ID}/detector-svc
              imagePullPolicy: Always
              name: detector-svc
              ports:
                - containerPort: 8080
              envFrom:
                - secretRef:
                    name: detector-svc-secrets

In this deployment, we want to run 3 copies (`replicas: 3`) of the detector service (`- image: gcr.io/{PROJECT_ID}/detector-svc`) for availability and scalability. We label the pods (`app: detector-svc`) so that they can easily be referenced as a group. We alse choose rolling updates (`type: RollingUpdate`) as our redeployment strategy. Rolling update means we can update the app without experiencing any downtime. In other words, k8s gradually replaces pods in the deployment so that the application is always available to consumers or clients even when an update is taking place.

Viewer service deployment.

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: viewer-svc-deployment
    spec:
      replicas: 2
      minReadySeconds: 15
      strategy:
        type: Recreate
      template:
        metadata:
          labels:
            app: viewer-svc
        spec:
          containers:
            - image: gcr.io/{PROJECT_ID}/viewer-svc
              imagePullPolicy: Always
              name: viewer-svc
              ports:
                - containerPort: 80
              envFrom:
                - secretRef:
                    name: viewer-svc-secrets

We choose a different redeployment strategy (`type: Recreate`) in the viewer service. This strategy destroys existing pods and recreates them with the updated image. Also, we're going with 2 replicas here.

Notice `envFrom` under `containers` in both deployments? We'll be loading our environment variables from a k8s Secret which we'll create soon.

# Services
The k8s services (not to be confused with microservices) in detector and viewer, `detector-service.yaml` and `viewer-service.yaml`, share traffic among a set of replicas and provide an interface for other applications to access them. The detector service uses the ClusterIP k8s service which exposes the app on a cluster-internal IP. This means detector is only reachable from within the cluster. The viewer service uses the LoadBalancer service which exposes it externally to the outside world.

Detector k8s service.

    apiVersion: v1
    kind: Service
    metadata:
      name: detector-service
    spec:
      type: ClusterIP
      ports:
      - port: 80
        protocol: TCP
        targetPort: 8080
      selector:
        app: detector-svc

Viewer k8s service.

    apiVersion: v1
    kind: Service
    metadata:
      name: viewer-service
    spec:
      type: LoadBalancer
      ports:
      - port: 80
        protocol: TCP
        targetPort: 80
      selector:
        app: viewer-svc

__NB:__ we use the labels (`app: detector-svc` and `app: viewer-svc`) to select the group of pods created by the detector and viewer deployments, and make both services available on port 80.

# Cloudinary and Redis
As mentioned earlier, Yoloo depends on Cloudinary and Redis. Cloudinary is a cloud-based image/video hosting service and Redis is an in-memory key-value database.

Create an account [on Cloudinary](https://cloudinary.com) and [on Redis Labs](https://redislabs.com) (a free managed Redis hosting service).

![](/images/ms-k8s/cloudinary-console.jpg)
_Cloudinary console_

![](/images/ms-k8s/redislabs-config.jpg)
_Redis Labs configuration_

Create _.env_ files from the example env files in both services (_.env.example_) and populate them with your Cloudinary and Redis credentials.

Detector service .env

    FLASK_APP=detector.py
    FLASK_ENV=production
    CLOUDINARY_CLOUD_NAME=somethingawesome
    CLOUDINARY_API_KEY=0123456789876543210
    CLOUDINARY_API_SECRET=formyappseyesonly

Viewer service .env

    CLOUDINARY_CLOUD_NAME=somethingawesome
    CLOUDINARY_API_KEY=0123456789876543210
    CLOUDINARY_API_SECRET=formyappseyesonly
    DETECTOR_SVC_URL=http://detector-service
    REDIS_URL=redis://:password@127.0.0.1:6379

Notice the url in `DETECTOR_SVC_URL`? Kubernetes creates DNS records within the cluster, mapping service names to their IP addresses. So we can use `http://detector-service` and not have to worry about what IP a service actually uses.

# kubectl
kubectl is a CLI tool for running commands against Kubernetes clusters. To get Kubernetes to run our microservices, we need to apply our deployments and services on the cluster. Outlined below are the steps involved.

Install `kubectl` CLI [for your OS](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

Set your Yoloo GCP project as default on the `gcloud` CLI.

    gcloud config set project {PROJECT_ID}

Set the default compute zone or region of your cluster. You can find this in the cluster details page on your GCP dashboard.

    gcloud config set compute/zone {COMPUTE_ZONE}

or

    gcloud config set compute/region {COMPUTE_REGION}

Generate a `kubeconfig` entry to run `kubectl` commands against a your GCP cluster.

    gcloud container clusters get-credentials {CLUSTER_NAME}    

__NB:__ if you use minikube, you can use the following command to switch back to your local cluster.

    kubectl config use-context minikube

Create k8s Secrets from the .env files in both services.

    kubectl create secret generic detector-svc-secrets --from-env-file=detector/.env
    kubectl create secret generic viewer-svc-secrets --from-env-file=viewer/.env

You can use the following commands to update the secrets.

    kubectl create secret generic detector-svc-secrets --from-env-file=detector/.env --dry-run -o yaml | kubectl apply -f -
    kubectl create secret generic viewer-svc-secrets --from-env-file=viewer/.env --dry-run -o yaml | kubectl apply -f -

Visit your GKE cluster dashboard on GCP and check the _Configuration_ section. You should see the detector and viewer service secrets.

![](/images/ms-k8s/gke-config.jpg)
_GKE cluster Config showing detector and viewer service secrets_

__NB:__ If you want to view the secrets on your k8s cluster (e.g when debugging), you can install the `jq` utility (https://stedolan.github.io/jq/) and run the following where `my-secrets` is the name of your k8s secret.

    kubectl get secret my-secrets -o json | jq '.data | map_values(@base64d)'

Create the deployments.

    kubectl apply -f detector/detector-deployment.yaml
    kubectl apply -f viewer/viewer-deployment.yaml

Check the _Workloads_ section of the dashboard. You should see the detector and viewer service deployments.

![](/images/ms-k8s/gke-workloads.jpg)
_GKE cluster Workloads showing the microservice deployments_

Create the services.

    kubectl apply -f detector/detector-service.yaml
    kubectl apply -f viewer/viewer-service.yaml

The detector and viewer k8s services can be found in the _Services_ section of the dashboard.

![](/images/ms-k8s/gke-services.jpg)
_GKE cluster Services showing the k8s services for Yoloo_

To visit the application, go to the viewer service page on the dashboard and locate the _External endpoints_ IP address.

![](/images/ms-k8s/viewer-svc-external-ip.jpg)
_Viewer service external IP address_

---

![](/images/ms-k8s/yoloo-app-ui.jpg)
_UI of the Yoloo app_

![](/images/ms-k8s/yoloo-sample-output.jpg)
_Sample output image from Yoloo_