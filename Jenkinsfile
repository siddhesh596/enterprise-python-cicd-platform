pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        DEPLOY_DIR = "/opt/enterprise-python-cicd-platform"
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
                    python3.12 --version
                    python3 -m pip --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3.12 -m venv .venv
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

            echo "========== CURRENT DIRECTORY =========="
            pwd

            echo "========== WORKSPACE =========="
            echo $WORKSPACE

            echo "========== PYTHON =========="
            python --version

            echo "========== SYS.PATH =========="
            python -c "import sys; print('\\n'.join(sys.path))"

            echo "========== ROOT FILES =========="
            ls -la

            echo "========== APP FOLDER =========="
            ls -R app

            echo "========== IMPORT TEST =========="
            export PYTHONPATH=$WORKSPACE
            python -c "import app; print('app import successful')"

            echo "========== PYTEST =========="
            pytest -v
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