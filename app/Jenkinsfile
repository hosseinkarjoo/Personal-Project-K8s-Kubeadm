pipeline {
    environment {
        dockerhubReg = "hosseinkarjoo/devops-training-app"
        dockercontainername = "devops-training-app-Flask"
        dockercontainertest = "devops-training-app-test"
    }
    agent {
        node {
            label 'prod-stage'
        }
    }
    stages {
        stage('First - Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/DevOps-Training-Full-Deployment.git', branch: 'Front-Prod', credentialsId: 'github_creds'
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
                    } 
                    catch (err) {
                        echo: 'ERROORR'
                    }
                    sh 'docker run -d --name ${dockercontainername} -p 80:5000 --network=main-net ${dockerhubReg}'
                }    
            }
        }
        stage ("Fifth - HealthCheck") {
            steps {
                sh 'docker container exec -i ${dockercontainername}  python test.py'
            }
        }

    }
}
