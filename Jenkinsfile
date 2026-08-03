pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        PROJECT_DIR = "/home/ec2-user/enterprise-python-cicd-platform"
        VENV = ".venv"
    }

    stages {

        stage('Checkout Source') {
            steps {
                dir("${PROJECT_DIR}") {
                    checkout scm
                }
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

        stage('Create Virtual Environment') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        python3 -m venv ${VENV}
                    '''
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        . ${VENV}/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        . ${VENV}/bin/activate
                        pytest
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh 'docker compose build'
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        docker compose down
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
            echo 'Application deployed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }

        always {
            cleanWs()
        }
    }
}