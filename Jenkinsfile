pipeline {
  agent any

  environment {
    ECR_REPO   = '238845559349.dkr.ecr.us-east-1.amazonaws.com/app-repository'
    IMAGE_TAG  = "${env.BUILD_ID}"
    AWS_REGION = 'us-east-1'
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/awebber133/techchallenge2.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          echo "Building Docker image..."
          docker build -t $ECR_REPO:$IMAGE_TAG ./app
        '''
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            echo "Logging into ECR..."
            aws ecr get-login