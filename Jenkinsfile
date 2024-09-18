pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'kety016/sortinglab:latest'
        REGISTRY_CREDENTIALS_ID = 'kety' // Docker Hub credentials ID
        DOCKER_HOST = 'tcp://172.31.26.63:8081' // Docker server IP and port
        GIT_REPO_URL = 'https://github.com/Magnifique67/docker.git'
        GIT_BRANCH = 'main' // Change 'main' to your branch if different
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout code from Git
                    checkout([$class: 'GitSCM',
                        branches: [[name: "*/${GIT_BRANCH}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: "${GIT_REPO_URL}"]]
                    ])
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build the Java application using Maven
                    try {
                        echo "Building application..."
                        sh 'mvn clean package'
                    } catch (Exception e) {
                        error "Build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests
                    try {
                        echo "Running tests..."
                        sh 'mvn test'
                    } catch (Exception e) {
                        error "Tests failed: ${e.message}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    try {
                        echo "Building Docker image ${DOCKER_IMAGE}..."
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    } catch (Exception e) {
                        error "Docker image build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    try {
                        echo "Starting Docker deployment..."
                        // Deploy Docker image using Docker remote API
                        withEnv(["DOCKER_HOST=${DOCKER_HOST}"]) {
                            withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                sh '''
                                # Print Docker version for debugging
                                docker --version

                                # Login to Docker Hub
                                echo "Logging into Docker Hub..."
                                echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin

                                # Push the Docker image
                                echo "Pushing Docker image ${DOCKER_IMAGE}..."
                                docker push ${DOCKER_IMAGE}

                                # Stop and remove any existing container
                                echo "Stopping and removing existing container (if exists)..."
                                docker stop my_container || true
                                docker rm my_container || true

                                # Run the new Docker container
                                echo "Running new Docker container..."
                                docker run -d --name my_container ${DOCKER_IMAGE}

                                echo "Deployment complete."
                                '''
                            }
                        }
                    } catch (Exception e) {
                        error "Deployment failed: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after the pipeline
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
