pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        DEPLOY_DIR = "/opt/enterprise-python-cicd-platform"
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
                    pytest
                '''
            }
        }

        stage('Sync Deployment Files') {
            steps {
                sh '''
                    mkdir -p ${DEPLOY_DIR}

                    rsync -av --delete \
                    --exclude=".git" \
                    --exclude=".venv" \
                    ./ ${DEPLOY_DIR}/
                '''
            }
        }

        stage('Docker Build') {
            steps {
                dir("${DEPLOY_DIR}") {
                    sh 'docker compose build'
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${DEPLOY_DIR}") {
                    sh '''
                        docker compose down || true
                        docker compose up -d
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    sleep 20
                    curl --fail http://localhost:8000/health
                '''
            }
        }

    }

    post {

        success {
            echo "Deployment Successful"
        }

        failure {
            echo "Deployment Failed"
        }

        always {
            cleanWs()
        }
    }
}