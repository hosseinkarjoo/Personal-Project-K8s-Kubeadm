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
                        sh'sudo /usr/local/bin/helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver'
                        sh'/usr/local/bin/helm repo update'
                        sh'/usr/local/bin/helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver'
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
                sh'sudo kubectl apply -f deployment-docker-reg.yml'
            }
        }
        stage('wait for registry to be ready'){
            steps{
                script{
                    sh''' #!/bin/bash
                            until curl http://master:31320
                            do
                              sleep 5
                            done
                    '''
                }
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
        stage ('Change The BUILD NUMBERRR') {
            steps {
                script {
                    sh 'sed -ie "s/BUILDNUMBER/${BUILD_NUMBER}/g" deployment-app.yml'
                    sh 'sed -ie "s/BUILDNUMBER/${BUILD_NUMBER}/g" deployment-api.yml'
                    sh 'sed -ie "s/BUILDNUMBER/${BUILD_NUMBER}/g" deployment-db.yml'
                }
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
