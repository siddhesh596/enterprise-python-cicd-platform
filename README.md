# enterprise-python-cicd-platform

Enterprise-grade DevOps platform for a Python FastAPI application on AWS.

## Overview

This repository contains:
- A production-ready FastAPI application
- Dockerized deployment with multi-stage build
- Terraform modules for AWS networking, compute, database, ALB, autoscaling, IAM, and monitoring
- Ansible automation for host configuration
- Jenkins pipeline with blue-green deployment and rollback support
- Prometheus, Grafana, and CloudWatch monitoring
- Linux deployment and rollback scripts
- GitHub Actions workflow for CI/CD quality gates

## Architecture

See [docs/architecture.md](docs/architecture.md) for the architecture overview and Mermaid diagram.

## Quick Start

1. Create a Python virtual environment
2. Install dependencies from [requirements.txt](requirements.txt)
3. Run the app with `uvicorn fastapi_app.main:app --reload`
4. Open `http://localhost:8000/docs`

## Local Development

```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn fastapi_app.main:app --reload --host 0.0.0.0 --port 8000
```

## Deployment

- Terraform: [terraform/](terraform/)
- Ansible: [ansible/](ansible/)
- Jenkins: [jenkins/Jenkinsfile](jenkins/Jenkinsfile)
- Docker: [docker/](docker/)
- Monitoring: [monitoring/](monitoring/)

## Security Notes

- Secrets should be injected via environment variables.
- IAM roles should follow least privilege.
- HTTPS should be enabled through ALB and Route53.
