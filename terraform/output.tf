output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "jenkins_url" {
  value = "http://${aws_eip.jenkins_server.public_ip}:8080"
}

