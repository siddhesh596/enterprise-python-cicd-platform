#!/bin/bash
set -euo pipefail
apt-get update
apt-get install -y docker.io docker-compose-plugin nginx awscli curl unzip jq
systemctl enable docker
systemctl start docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
mkdir -p /opt/app
cd /opt/app
cat > docker-compose.yml <<'EOF'
version: '3.8'
services:
  app:
    image: public.ecr.aws/docker/library/python:3.12-slim
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: ${DATABASE_URL:-postgresql://postgres:postgres@localhost:5432/enterprise_db}
    command: sh -c "pip install fastapi uvicorn sqlalchemy pydantic psycopg2-binary && python -m uvicorn app.fastapi_app.main:app --host 0.0.0.0 --port 8000"
EOF
cat > /etc/nginx/conf.d/app.conf <<'EOF'
server {
  listen 80;
  server_name _;
  location / {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
EOF
systemctl enable nginx
systemctl start nginx
