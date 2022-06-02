pipeline {
    environment {
        dockerhubReg = "hosseinkarjoo/devops-training-api"
        dockercontainername = "devops-training-API"
        dockercontainerRedis = "devops-training-Redis"
    }
    agent {
        node {
            label 'prod-stage'
       }
    }
    stages {
        stage('First - Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/DevOps-Training-Full-Deployment.git', branch: 'Back-API', credentialsId: 'github_creds'
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
                        sh 'docker image rm ${dockerhubReg}:${BUID_NUMBER}'
                    } 
                    catch (err) {
                        echo: 'ERROORR'
                    }
                    sh 'docker run -d --name ${dockercontainername} -p 8080:5001 --network=main-net ${dockerhubReg}'
                }    
            }
        }
//        stage ("Fifth - test app") {
//            steps {
//                script {
//                    try {
//                        sh 'python3.6 ./test.py'
//                    }
//                    catch (err) {
//                        echo: 'ERROORR'
//                    }
//               }
//            }
//        }
        stage ("Sixth - Deploy Redis-Cache") {
            steps {
                script {
                    try {
                        sh 'docker container stop ${dockercontainerRedis}'
                        sh 'docker container rm ${dockercontainerRedis}'
                    }
                    catch (err) {
                        echo: 'ERROORR'
                    }
                    sh 'docker run -d --name ${dockercontainerRedis} --network=main-net redis'
                }
            }
	}
    }
}
