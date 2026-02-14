# Kubernetes Portfolio Website Deployment

## Overview

This project demonstrates deployment of a full-stack portfolio website on a Kubernetes cluster. The application consists of:

* **Frontend** – Containerized UI image hosted on Docker Hub
* **Backend** – API service containerized and hosted on Docker Hub
* **Database** – MongoDB container
* **Ingress** – Exposes services externally via Kubernetes Ingress
* **Cluster** – Local Kubernetes environment using Minikube

The setup showcases containerization, orchestration, service exposure, and local cluster testing.

---

## Architecture

```
Client → Ingress → Frontend Service → Backend Service → MongoDB
```

---

## Technologies Used

* Kubernetes
* Minikube
* Docker
* Docker Hub
* MongoDB
* Ingress Controller

---

## Prerequisites

* Docker installed
* Minikube installed
* kubectl configured
* Docker Hub account

---

## Setup Instructions

### 1. Start Cluster

```bash
minikube start
```

### 2. Enable Ingress

```bash
minikube addons enable ingress
```

### 3. Deploy Resources

Apply manifests:

```bash
kubectl apply -f k8s/
```

---

## Verify Deployment

Check pods:

```bash
kubectl get pods
```

Check services:

```bash
kubectl get svc
```

Check ingress:

```bash
kubectl get ingress
```

---

## Access Application

Get Minikube IP:

```bash
minikube ip
```

Open browser:

```
http://<minikube-ip>
```

---

## Docker Images

| Component | Image                                 |
| --------- | ------------------------------------- |
| Frontend  | `<dockerhub-username>/frontend-image` |
| Backend   | `<dockerhub-username>/backend-image`  |
| MongoDB   | `mongo`                               |

---

## Features Demonstrated

* Containerized microservices
* Kubernetes service discovery
* Ingress routing
* Local cluster testing
* Scalable deployment design

---

## Future Improvements

* TLS support
* Helm chart packaging
* CI/CD pipeline integration
* Horizontal Pod Autoscaling

---
