pipeline {
    environment {
        dockerhubReg = "hosseinkarjoo/devops-training-database"
        dockercontainername = "devops-training-database"
    }
    agent {
        node {
            label 'prod-stage'
        }
    }
    stages {
        stage('First - Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/DevOps-Training-Full-Deployment.git', branch: 'Backend-Stage', credentialsId: 'github_creds'
                }
            }
        stage ('Secound - Build Docker Image') {
            steps {
                script {
                    image = docker.build dockerhubReg
                }
            }
        }
        stage ('Third - Push Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'hub_credentialsId') {
                        image.push("${BUILD_NUMBER}")
                        image.push("latest")
                    }
                }
            }
        }
        stage ("Forth - Deploy to Stage") {
            steps {
                script {
                    try {
                        sh 'docker container stop ${dockercontainername}'
                        sh 'docker container rm ${dockercontainername}'
                        sh 'docker image rm ${dockerhubReg}'
                        sh 'docker volume create mysql-db'
                    } 
                    catch (err) {
                        echo: 'ERROORR'
                    }
                    sh 'docker run -d --name ${dockercontainername} --mount source=mysqldb,target=/var/lib/mysql --network=main-net ${dockerhubReg}'
                }    
            }
        }
    }
}
