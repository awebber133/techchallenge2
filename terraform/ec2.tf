# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.small"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.jenkins.id]
  subnet_id              = aws_subnet.public[0].id

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "Jenkins-Server"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Elastic IP for Jenkins Server
resource "aws_eip" "jenkins_server" {
  instance = aws_instance.jenkins_server.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-jenkins-eip"
    Environment = var.environment
  }
}