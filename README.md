# 🏨 Hotel Management App — End-to-End DevOps Project

A complete DevOps pipeline demonstrating **CI/CD, Docker, Kubernetes, AWS, Terraform, Ansible, Prometheus–Grafana monitoring**, and automated deployments on **Amazon EKS**.

This project is built for **hands-on DevOps practice and interview preparation**.  
It covers the full SDLC workflow: **Code → Build → Test → Package → Deploy → Monitor**.

---

## 📌 Project Overview

This repository contains:

- A **Flask-based hotel management application**
- Infrastructure provisioning with **Terraform**
- Server configuration with **Ansible**
- Containerization using **Docker**
- CI/CD automation using **Jenkins Pipeline**
- Orchestration on **Amazon EKS**
- Monitoring using **Prometheus + Grafana**
- Logging with **AWS CloudWatch (optional)**

The goal of the project is to simulate a **real-world production-ready DevOps setup** using only **free-tier compatible AWS services**.

---

## 🎯 Core DevOps Skills Demonstrated

✔ SDLC & Git Workflow  
✔ Linux Administration  
✔ Shell Scripting  
✔ Python App Development  
✔ AWS Cloud (EC2, VPC, IAM, ECR, EKS, CloudWatch)  
✔ Terraform for Infrastructure as Code  
✔ Ansible for Server Automation  
✔ Docker & Docker Compose  
✔ Kubernetes Workloads (Deployments, Services, Namespaces)  
✔ Helm Chart Usage  
✔ Jenkins CI/CD Pipeline  
✔ Prometheus–Grafana Observability  
✔ End-to-end environment setup (local → cloud)  

---

## 🏗️ High-Level Architecture

**Developer → GitHub → Jenkins → Ansible → Docker → AWS ECR → AWS EKS → Prometheus/Grafana**

### Explanation:
1. Developer pushes code to GitHub  
2. Jenkins Pipeline triggers automatically, performing:  
   - Code pull  
   - Docker image build  
   - Image push to AWS ECR  
   - Ansible execution on EC2  
   - Deployment to EKS  
3. EKS hosts the Flask application behind a LoadBalancer  
4. Prometheus scrapes metrics from the app  
5. Grafana visualizes dashboards & alerts  
6. Optional: CloudWatch collects logs  

---

## 📁 Repository Structure

hotel-management-app/
│
├── app/                     # Flask application
│   ├── __init__.py
│   └── routes.py
│   └── database.py
│   └── models.py
│
├── k8s/                     # Kubernetes manifests
│   ├── Deployment.yaml
│   ├── Service.yaml
│   └── prometheus-alerts.yaml
│
├── terraform/               # Terraform IaC for EC2, EKS, VPC, IAM, ECR
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
│   ├── jenkins-ec2.tf
│   ├── iam-eks.tf
│   └── eks-cluster.tf
│
├── ansible/                 # Server automation
│   ├── inventory
│   └── deploy_app.yml
│   └── install_docker.yml
│   └── ansible.cfg
│
│
├── Dockerfile               # Build application container
├── requirements.txt         # Python dependencies
├── Jenkinsfile              # Complete CI/CD pipeline
├── .dockerignore
├── .gitignore
├── app.py
└── README.md


---

## 🚀 End-to-End Workflow

### 1️⃣ Terraform — Provision AWS Infrastructure
Terraform provisions:
- VPC  
- Subnets  
- Internet Gateway  
- EC2 (Jenkins & App server)  
- ECR repository  
- EKS cluster + Node Groups  
- IAM roles for Jenkins + EKS nodes  

**Commands:**
_bash_
terraform init
terraform validate
terraform plan
terraform apply -auto-approve


**Outputs include:**
- EC2 Public IPs  
- ECR repo URL  
- EKS Cluster endpoint  

---

### 2️⃣ Configure Jenkins Server (EC2)
Install:
- Docker  
- Jenkins LTS  
- AWS CLI  
- kubectl, eksctl, helm  
- Ansible  

SSH into Jenkins EC2 and install dependencies.

---

### 3️⃣ Jenkins Pipeline Setup
The pipeline performs:
- Pull code from GitHub  
- Build Docker image  
- Push to AWS ECR  
- Run Ansible on EC2  
- Deploy to Kubernetes  
- Verify deployment  

---

### 4️⃣ Docker Image Build & Push
Local build:
_bash_
docker build -t hotel-management-app:latest .

Authenticate to ECR:
_bash_
aws ecr get-login-password --region ap-south-2 \
| docker login --username AWS --password-stdin <ECR_URL>

Push image:
_bash_
docker push <ECR_URL>:latest

---

### 5️⃣ Kubernetes Deployment on EKS
_bash_
kubectl apply -f k8s/Deployment.yaml
kubectl apply -f k8s/Service.yaml

Check service:
_bash_
kubectl get svc hotel-service

Access via LoadBalancer external IP.

---

### 6️⃣ Monitoring With Prometheus & Grafana
Install kube-prometheus-stack:
_bash_
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace

Port-forward Grafana:
_bash_
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80

**Credentials:**
- username: `admin`  
- password: `kubectl get secret ...`  

App provides a custom metric:
hotel_app_requests_total

This metric is scraped automatically.

---

## 📊 Prometheus Metrics & Grafana Dashboard

The project exposes custom Python metrics using **prometheus_client**.

Dashboard includes:
- Total HTTP Requests  
- Error Count  
- Pod CPU / Memory  
- Deployment replicas  
- EKS Node Health  
- Latency Graphs  

---

## 🔐 IAM & Security

The project uses separate IAM roles for:
- EKS Node Group role  
- Jenkins EC2 role  
- ECR Pull/Push permissions  
- Terraform provisioning role  

**Least privilege is enforced.**

---

## ☁️ AWS Services Used

| AWS Service | Purpose |
|-------------|---------|
| EC2         | Jenkins & App Server |
| ECR         | Docker image registry |
| EKS         | Kubernetes cluster |
| IAM         | Access management |
| VPC         | Networking |
| CloudWatch  | Logs & Metrics |
| ALB / NLB   | Load balancing |

---

## 💡 Future Enhancements

- Add Ingress Controller (nginx)  
- Add service mesh (Istio)  
- Use GitOps (ArgoCD)  
- Add canary deployments  
- Use S3 + RDS for persistent DB storage  

---

## 👤 Author

**Piyush Agrawal**  
*DevOps Engineer*  

Skills: CI/CD, AWS, Terraform, Docker, Kubernetes, Monitoring, Python

