# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sunrise-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sunrise-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = count.index == 0 ? "10.0.0.0/24" : "10.0.1.0/24"
  availability_zone       = element(["us-east-2a", "us-east-2b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                        = count.index == 0 ? "sunrise-public-0" : "sunrise-public-1"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/sunrise-eks" = "shared"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = count.index == 0 ? "10.0.2.0/24" : "10.0.3.0/24"
  availability_zone = element(["us-east-2a", "us-east-2b"], count.index)

  tags = {
    Name                             = count.index == 0 ? "sunrise-private-0" : "sunrise-private-1"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/sunrise-eks" = "shared"
  }
}