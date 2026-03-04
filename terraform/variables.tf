variable "project_name" {
  default = "sunrise"
}

variable "environment" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "cluster_name" {
  default = "sunrise-eks"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "app_image" {
  description = "Docker image for app"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
}
