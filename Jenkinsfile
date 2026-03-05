pipeline {

  agent any

  environment {
    ECR_REPO   = '238845559349.dkr.ecr.us-east-2.amazonaws.com/sunrise-app'
    IMAGE_TAG  = "${env.BUILD_ID}"
    AWS_REGION = 'us-east-2'
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/awebber133/devops-challenge2.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $ECR_REPO:$IMAGE_TAG ./app'
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
            docker push $ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            export AWS_REGION=us-east-2
            export AWS_DEFAULT_REGION=us-east-2

            kubectl get nodes

            helm upgrade --install app ./helm-chart
          '''
        }
      }
    }
  }
}