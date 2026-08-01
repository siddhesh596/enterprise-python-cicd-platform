# Deployment Guide

## Prerequisites

- Python 3.12+
- Docker
- Terraform 1.5+
- Ansible
- AWS CLI configured
- GitHub repository

## Local Development

```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.fastapi_app.main:app --reload --host 0.0.0.0 --port 8000
```

## Deploy with Docker

```bash
docker compose -f docker/docker-compose.yml up -d --build
```

## Deploy Infrastructure with Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
