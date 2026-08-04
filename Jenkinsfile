pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        PYTHON = "python3"
        VENV = ".venv"
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
                    python3 --version
                    python3 -m pip --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv .venv

                    . .venv/bin/activate

                    pip install --upgrade pip

                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . .venv/bin/activate

                    export PYTHONPATH=$WORKSPACE

                    pytest -v
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker compose build
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker compose down || true

                    docker compose up -d
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    sleep 15

                    curl -f http://localhost:8000/health
                '''
            }
        }
    }

    post {

        success {
            echo "Deployment Successful!"
        }

        failure {
            echo "Deployment Failed!"
        }

        always {
            cleanWs()
        }
    }
}