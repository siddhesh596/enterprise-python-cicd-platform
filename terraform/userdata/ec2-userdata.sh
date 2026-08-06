#!/bin/bash
set -eux

dnf update -y
dnf install -y docker awscli

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin \
571850512217.dkr.ecr.ap-south-1.amazonaws.com

docker pull 571850512217.dkr.ecr.ap-south-1.amazonaws.com/enterprise-python-api:latest

docker run -d \
--restart always \
-p 80:8000 \
--name enterprise-python-api \
571850512217.dkr.ecr.ap-south-1.amazonaws.com/enterprise-python-api:latest