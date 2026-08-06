pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        PYTHON = "python3.12"
        VENV = ".venv"
        PYTHONPATH = "${WORKSPACE}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Python') {
            steps {
                sh '''
                    echo "===== Python Version ====="
                    ${PYTHON} --version

                    echo "===== Pip Version ====="
                    ${PYTHON} -m pip --version
                '''
            }
        }

        stage('Create Virtual Environment') {
            steps {
                sh '''
                    rm -rf ${VENV}

                    ${PYTHON} -m venv ${VENV}

                    . ${VENV}/bin/activate

                    python --version

                    python -m pip install --upgrade pip
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    . ${VENV}/bin/activate

                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . ${VENV}/bin/activate

                    export PYTHONPATH=${WORKSPACE}

                    pytest -v
                '''
            }
        }

       stage('Build & Push Docker Image') {
    steps {
        sh '''
            docker build -t enterprise-python-api:latest .

            docker tag enterprise-python-api:latest \
            571850512217.dkr.ecr.ap-south-1.amazonaws.com/enterprise-python-api:latest

            aws ecr get-login-password --region ap-south-1 | \
            docker login --username AWS --password-stdin \
            571850512217.dkr.ecr.ap-south-1.amazonaws.com

            docker push \
            571850512217.dkr.ecr.ap-south-1.amazonaws.com/enterprise-python-api:latest
        '''
    }
}

       stage('Deploy Application') {
    steps {
        sh '''
            DEPLOY_DIR=/opt/enterprise-python-cicd-platform

            mkdir -p $DEPLOY_DIR

            rsync -av --delete ./ $DEPLOY_DIR/

            cd $DEPLOY_DIR

            docker compose down || true

            docker compose up -d --build
        '''
    }
}


        stage('Show Running Containers') {
            steps {
                sh '''
                    cd /opt/enterprise-python-cicd-platform  || true
                    docker ps
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    echo "Waiting for application..."

                    sleep 15

                    curl --fail http://localhost:8000/health
                '''
            }
        }
    }

    post {

        success {
            echo '==================================='
            echo 'Deployment Successful!'
            echo '==================================='
        }

        failure {
            echo '==================================='
            echo 'Deployment Failed!'
            echo '==================================='

            sh '''
                cd /opt/enterprise-python-cicd-platform  || true

                docker compose logs || true
            '''
        }

        always {
            cleanWs()
        }
    }
}