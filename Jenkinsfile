pipeline {
    agent {
        node {
            label 'prod'
        }
    }
    environment{
        efsID = readFile '/tmp/efsid'
    }
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/Personal-Project-K8s-Kubeadm.git', branch: 'master', credentialsId: 'github_creds'
            }
        }
        stage('install Drivers and registry'){
            steps{
                script {
                    try {
                        sh'sed -ie "s/efsID/${efsID}/g" deployment-docker-reg.yml'
                        sh'sudo kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.0"'
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
                sh'sudo kubectl apply -f deployment-docker-reg.yml'
            }
        }
        stage('build'){
            steps{
                sh'docker build -t master:31320/app:${BUILD_NUMBER} -t master:31320/app:latest ./app/'
                sh'docker build -t master:31320/api:${BUILD_NUMBER} -t master:31320/api:latest ./api/'
                sh'docker build -t master:31320/db:${BUILD_NUMBER} -t master:31320/db:latest ./db/'
            }
        }
        stage('PUSH'){
           steps{
                sh'sudo docker push master:31320/app:${BUILD_NUMBER}'
                sh'sudo docker push master:31320/app:latest'
                sh'sudo docker push master:31320/api:${BUILD_NUMBER}'
                sh'sudo docker push master:31320/api:latest'
                sh'sudo docker push master:31320/db:${BUILD_NUMBER}'
                sh'sudo docker push master:31320/db:latest'
            }
        }
        stage('run deployment'){
            steps{
                sh'sudo kubectl apply -f deployment-app.yml '
                sh'sudo kubectl apply -f deployment-api.yml '
                sh'sudo kubectl apply -f deployment-db.yml '
            }
        }
    }
}
