Sunrise App
Sunrise App is a lightweight Node.js web application designed to display an inspirational background image paired with a motivational quote. It serves as a simple, visual way to start your day with a positive message. The project focuses on minimal setup, clean structure, and straightforward user experience, making it easy to run locally or integrate into a larger deployment pipeline.
*The actual application code was provided by AI (deepseek or chatpgpt, don’t remember which)*
Phase 1: Build the Application
Step 1.1 - Create an app directory (mkdir)
Step 1.2 - Navigate into the directory. (CD app)
Step 1.3 - Initialize a Node.js project using npm init -y.
*Since AI created my base code, I created server.js, package.json, index.html and style.css manually and pasted the code) 
*NOTE: NPM start will create package-lock.json file and create your dependencies automatically when using NPM start
Step 1.4 - Create the main application file- touch server.js.
Step 1.5- Create a Public folder to store your background image. mkdir public/images
Step 1.6 - Place your background image inside the images folders 
*We should now have the following file structure: devops-code-challenge2/
|
├── app/
│   ├── node_modules/        # Installed dependencies for the app
│   └── public/              # Static frontend assets served by the server
│       ├── images/
│       │   └── mtfuji.jpg   # Sample image used by the UI
│       ├── index.html       # Main frontend page
│       └── style.css        # Stylesheet for the UI
│
├── server.js                # Node.js server entry point
├── package.json             # Project metadata, scripts, dependencies
└── package-lock.json        # Dependency lockfile

Step 1.6 - Create a private repo for your project. Do NOT initiate with a README.md file
Step 1.7 - Initiate Git on local machine and link your repository (if you have not established a secure connection first, reference 1.7b)
•	Initiate git on your project file - git init
•	Link your git repo
git remote add origin <https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git>

#replace values with username & repo name
•	Add, commit, and push your code
git add .
git commit -m "Initial commit with basic project structure"
git branch -M main
git push -u origin main
Step 1.7b - If a secure connection to your repo has not been established via SSH, follow this guide
•	Open your terminal and run - ls ~/.ssh
•	If you see files like id_rsa and id_rsa.pub, you likely already have an SSH key. If not, continue.
•	Generate a new SSH key (if you don’t have one)
ssh-keygen -t ed25519 -C "[your_email@example.com](<mailto:your_email@example.com>)"
•	Just press Enter to accept defaults. Use your GitHub email for the -C flag. This will create: 
o	~/.ssh/id_ed25519 (private key)
o	~/.ssh/id_ed25519.pub (public key)

•	Start the SSH agent and add your key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
•	Obtain your SSH public key & Copy the output.
cat ~/.ssh/id_ed25519.pub

•	Add the key to GitHub
o	Go to GitHub → Settings → SSH and GPG Keys
o	Click New SSH key
o	Give it a title/name <desired key name> and paste the key from step 4
o	
Phase 2: Dockerize (Contain) the Application
*Before continuing, ensure docker is running on your system
Step 2.1 - On your local machine, create a dockerfile within the application’s directory
cd ~ /<app directory> && touch dockerfile
Step 2.2 – Add code for your dockerfile.
Step 2.3 - Build the Docker image
docker build -t sunrise-app .
Step 2.4 - Test the image locally & display the application on your web-browser
docker run -p 5050:5000 sunrise-app

# You may need to change the ports used if another application is already using this port
Step 2.5 - Once test is complete, stop the container either on the docker application or by Pressing CTRL+C to quit in the terminal
Step 2.6 - navigate back into the root project directory & upload application files to the repo
git add .
git commit -m "Initial Application code commit with dockerfile"
git branch -M main
git push -u origin main
Phase 3: Provision the EKS Cluster Using Terraform
Step 3.1 – Terraform Setup
•	VPC - include vpc, subnets, NACL’s & Security Groups
•	EKS Cluster with auto-scaling & ALB 
o	4 nodes total 
	1 node active at all times
	Scalable to 4 nodes
	instance type for nodes: t3.small
o	1 pod in each node 
	Use HPA to scale up to a maximum of 3 pods in each node
	HPA scales by 50% CPU utilization or 50% memory utilization
•	IAM roles
•	ECR repo for application
•	Master Node (EC2) 
o	instance type for master node: t3.small
o	20GB storage
o	AMI of your choice (for this project, ubuntu)
o	SG to allow traffic from ports: 
	8080 - [Jenkins]
	443 - [HTTPS]
	80 - [HTTP]
	22 - [SSH]
	CIDR block: From all sources [0.0.0.0/0]
Step 3.2 – Terraform Files to meet requirements from step 3.1
•	In your project directory, navigate into your terraform folder
•	create the following files within your terraform directory:
/app
  (your application files here)

/terraform
├── ec2.tf
├── ecr.tf
├── eks.tf
├── iam.tf
├── outputs.tf
├── provider.tf
├── sg.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
├── terraform.lock.hcl
├── variables.tf
├── vpc.tf
└── w6d2.pem

touch provider.tf vpc.tf ec2.tf ecr.tf eks.tf iam.tf outputs.tf variables.tf
Step 3.3 -  Add code to Terraform Files
Step 3.4 – Initialize and Apply Terraform
•	You should be in your terraform directory. If not, navigate to it.
•	Once inside, initialize terraform- terraform init
•	Check resources terraform will utilize based off project files - terraform plan
•	If the plan is successful, apply the infrastructure terraform apply
•	Once your infrastructure has been applied, log into the AWS console & ensure the services were deployed.
Step 3.6 - navigate back into the root project directory & upload the terraform files to the repo. *note, ensure only terraform files are uploaded. Create a .gitignore to exclude large files and un-needed files, such as the statefile, from being committed
git add .
git commit -m "Initial Terraform Files Upload"
git branch -M main
git push -u origin main
Step 3.7 – Configure kubectl for use with k8s on EKS
aws eks update-kubeconfig --name <your-cluster-name> --region <country-N.S.E.W-12345>

Phase 4: Deploy with Helm (k8s application manager)
Step 4.1 - Inside the project root, create a Helm chart:
helm create helm-chart

•	This automatically creates a basic template for Helm Charts.

Step 4.2 – Configure Chart Values
*For each code modification, ensure you SAVE the code
Step 4.3 – Deploy Using Helm
helm upgrade --install hello-app ./helm-chart --namespace jenkins-deploy --create-namespace

 
Step 4.4 – Verify the Jenkins Helm-Charts
kubectl get svc -n jenkins-deploy
 
________________________________________
Phase 5: Set Up Jenkins Server
Step 5.1 - Remote into the Jenkins Server
•	run this command to modify permissions on your key pair
chmod 400 ~/.ssh/<your-Key-Pair>.pem
•	run this command to remote into your Jenkins server
ssh -i ~/.ssh/<Your-Key-Pair>.pem ubuntu@<Jenkins-Server-IP-Address>

Step 5.2 - Update Jenkins Server
sudo apt update
sudo apt upgrade
5.3 - Install Docker (we need this to run Jenkins as a container)
sudo apt install docker
sudo apt install docker.io -y
5.3a - Verify docker install
docker --version
5.3b - Enable Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
Step 5.2 – Launch Jenkins on EC2 (Docker)
docker run -d \\
  --name jenkins \\
  -p 8080:8080 -p 50000:50000 \\
  -v jenkins_home:/var/jenkins_home \\
  -v /var/run/docker.sock:/var/run/docker.sock \\
  jenkins/jenkins:lts
Step 5.3 – Configure Jenkins
5.3a - Access Jenkins UI
http://<your-ec2-public-ip>:8080
5.3b - Copy the secret password to access Jenkins
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
5.3c - Install suggested plugins
5.3d - Configure Admin User (optional, but avoids having to get the secret password each time)
5.3e - install necessary plugins
Manage Jenkins – Plugins - Available Plug-Ins :
1.	Docker
2.	Amazon ECR
3.	Kubernetes CLI
Step 5.4 - Install on the Master Jenkins EC2
*These must also be installed on your root user (container)
Helm: 
curl <https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3> | bash

AWS CLI:
curl "<https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip>" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

kubectl: 
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin


Verify Installation:
aws --version
kubectl version --client
helm version
Step 5.5 - Insert the necessary credentials in order for Jenkins to work on our Behalf
•	GitHub PAT token (Personal Access Token) 
o	Go to GitHub → Settings → Developer Settings → Personal Access Tokens → Tokens (Classic)
o	Click Generate new token (classic)
o	Scopes to select: 
	repo (for private repo access)
	admin:repo_hook (for webhook creation)
o	Copy the PAT token
•	Go to: Manage Jenkins → Credentials → (global) → Add Credentials 
o	Type: Secret text
o	Secret: Paste your GitHub token
o	ID: github-PAT-token
o	Description: GitHub PAT for private repo access
•	Type: AWS Credentials 
o	Access Key: [Your access key]
o	Secret Key: [Your secret key]
o	ID: aws-credentials
o	Description: AWS credentials for ECR and kubectl
GitHub Webhook (On Github, not Jenkins)
You can also go to your GitHub repo → Settings → Webhooks → Add:
•	Payload URL: http://<jenkins-ec2-public-ip>:8080/github-webhook/
•	Content Type: application/json
•	Events: Just push events
This will allow automatic Jenkins build triggers when code is pushed to GitHub.
Phase 6: Configure the Pipeline (using a Jenkinsfile)
Step 6.1 - Create Jenkinsfile
We will use this Jenksinsfile in order to write the Pipeline Script, which will be placed within the repo.
6.1a - In your main project directory, create a Jenkinsfile with the touch command
6.3 - Upload Jenkinsfile to your repo
6.4 - Configure your pipeline with SCM
6.5 Troubleshoot Jenkins pipeline as needed.

BONUS! GitOps!
GitHub for CI, Argo CD for Node.js app deployment on the same EKS cluster!
Phase 1: Node.js Application
Step 1.1 - Create Node application directory on the root project file
mkdir node-app && cd node-app
Step 1.2 - Create the following file structure
./node-aoo
  ├── Dockerfile
  ├── index.js
  └── package.json
touch index.js package.json Dockerfile
Step 1.3 - In your index.js file, create the “Hello-World!” application with the following code:
const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => res.send('Hello World! This is the Node.js version!'));

app.listen(port, () => console.log(`App running on port ${port}`));

Step 1.4 - In your package.json file, insert the following code:
{
  "name": "node-app",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}

This code decribes the application, the depencencies required, and how the application should be containerized
Phase 2: Contain the Node.js Application
Step 2.1 In the Dockerfile, insert the following code in order to containerize the application:
FROM node:18-slim

WORKDIR /app

COPY package.json ./
RUN npm install

COPY . .

CMD ["npm", "start"]

Step 2.2 - Build the dockerimage for the application
docker build -t node-app .
 
Step 2.3 - Run the container & test the application locally *note if your computer is using port 5000, change the container’s exposed port to a different one
docker run -p 5000:5000 node-app

# Ran on port 5001 on container since Port 5000 was in use
 
Step 2.4 - Once test is complete, stop the container either on the docker application or by Pressing CTRL+C to quit in the terminal
Phase 3: Prepare GitHub repo for node application
Step 3.1 - Since our GitHub account is linked from the Jenkins CI/CD deployment, we can create the branch using CLI.
Navigate into the root directory of your project, then run the following command:
git checkout -b gitops-deploy
 
This creates a new branch on the local machine and allows us to work on it. This branch is not on the repo yet untill we commit and push the new node application
Step 3.2 - commit and push the code into the repo
git add .
git commit -m "Add Node.js app for GitOps deployment"
git push origin gitops-deploy
This deploys the new gitops branch with the new node aplication directory. The original project files were copied on to this branch, which is normal
 
Phase 4: Modify IaC to create new node-app ECR repo.
To ensure terraform can keep track of the changes to ECR repo, we need to add a node application repo to the terraform file rather than adding a repo on the AWS console
Step 4.1 - Modify the ecr.tf file to create a new node application repo and update the policy allow EKS to pull the node app from the ECR repo
4.1a - Navigate into your terraform directory
4.1b - Select the ecr.tf file and replace the existing code with this:
# ECR Repository for Python Flask App
resource "aws_ecr_repository" "app" {
  name                 = "app-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "hello-app"
  }
}

# ECR Repository Policy for Flask App
resource "aws_ecr_repository_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowPullFromEKS",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.eks_node_group.arn
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

# ECR Repository for Node.js App
resource "aws_ecr_repository" "node_app" {
  name                 = "node-app-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "node-app"
  }
}

# ECR Repository Policy for Node.js App
resource "aws_ecr_repository_policy" "node_app" {
  repository = aws_ecr_repository.node_app.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowPullFromEKS",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.eks_node_group.arn
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

Step 4.2 - Run terraform plan in order to ensure the ECR repo will be updated
terraform plan
 
Step 4.3 - Apply the changes to the infrastructure
terraform apply

# or you can us the code below in order to bypass the approval

terraform apply -auto-approve
 
Step 4.4 - Upload updated terraform file to the gitops repo
4.4a - navigate back into your project root directory
4.4b - commit and push the updated files to the GITOPS branch (not the main)
git add Terraform/ecr.tf
git commit -m "Add ECR resources for Node.js GitOps deployment"
git push origin gitops-deploy
 
 
Phase 5: Modify Helm-Charts for Node App Deployment
Step 5.1 - Navigate into the helm-charts directory and create a values yaml file for your gitops deployment
cd helm-chart
touch values-gitops.yaml
Step 5.2 - Insert the following code into the file
image:
  repository: <node-app ecr repository uri>
  pullPolicy: IfNotPresent

service:
  type: LoadBalancer
  port: 5000

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 200m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 50

namespaceOverride: gitops-deploy

Step 5.3 - Once saved, Navigate back into the root project folder, and upload your updated helm-charts into the gitops branch in your repository
git add helm-chart/values-gitops.yaml
git commit -m "Add Helm values for Node.js GitOps deployment"
git push origin gitops-deploy
 
Phase 6: GitHub Actions for CI
If we recall, a YAML file calls upon pre-built modules to perform jobs (called actions). In this case, we’re going to instruct GitHub to call upon a pre-built Docker action to containerize the application, and then interact with AWS to push the resulting image to our ECR repository.
Step 6.1 - In the root project folder, create a workflow (essentially, a hidden folder github uses to perform tasks) with a docker-ci.yml file
mkdir -p .github/workflows
touch .github/workflows/docker-ci.yml
Step 6.2 - Insert the following code into the docker-ci.yml file
name: Build and Push Node.js Image to ECR

on:
  workflow_dispatch:
  push:
    branches:
      - gitops-deploy

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1  # adjust if needed

    - name: Log in to Amazon ECR
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build and Push Docker Image
      env:
        ECR_REPO: ${{ secrets.ECR_REPO_NODE_APP }}
      run: |
        docker build -t $ECR_REPO:$GITHUB_SHA ./node-app
        docker push $ECR_REPO:$GITHUB_SHA
Step 6.3 - In GIT HUB, create the ECR secret in order to properly push your images into ECR
6.3a - Go into your project repo
6.3b - On the top right of the repo, select the Settings option
6.3c - On the left hand menu, select Secrets and Variables , then Actions
 
6.3d - Click on New Repository Secrts
•	Fill in with desired repo name (ECR_REPO_NODE_APP)
o	if you modify the secret’s name, make sure to modify the name in the docker-ci.yaml file as well
•	 - name: Build and Push Docker Image
•	      env:
•	        ECR_REPO: ${{ secrets.ECR_REPO_NODE_APP }}     # replace with desired secrets name
•	Insert your ECR URI for your node-app
<account-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>

# you can simple copy and paste the repo URI fromt the AWS console inside of your ECR service.
 
6.3e - Click on New Repository Secrts
•	Fill in name with: AWS_ACCESS_KEY_ID
•	Insert your AWS access key ID into the secrets
6.3f - Click on New Repository Secrts
•	Fill in name with: AWS_SECRET_ACCESS_KEY
•	Insert your AWS secret access key into the secrets
Step 6.4 - Back in your project directory, Commit workflow into your gitops repo
git add .github/workflows/docker-ci.yml
git commit -m "Add GitHub Actions workflow for Node.js CI"
git push origin gitops-deploy
 
Step 6.5 - GitHub actions trigger.
Since there have not been any changes in the application since the previous commits, this GutHub action will not trigger.
6.5a - In your root project directory, create a simple dummy text file
touch dummy.txt
6.5b - Commit the changes to the gitops branch to trigger the workflow
git add dummy.txt
git commit -m "Trigger workflow with dummy commit"
git push origin gitops-deploy

