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

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker compose build
                '''
            }
        }

       stage('Deploy Application') {
    steps {
        sh '''
        cd /home/ec2-user/enterprise-python-cicd-platform

        git pull origin main

        docker compose down || true

        docker compose up -d --build
        '''
    }
}


        stage('Show Running Containers') {
            steps {
                sh '''
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
                docker ps -a || true

                docker compose logs || true
            '''
        }

        always {
            cleanWs()
        }
    }
}