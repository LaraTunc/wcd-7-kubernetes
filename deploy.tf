terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.37.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0, < 3.0"
    }
  }
}

variable "AWS_REGION" {}
variable "AWS_PROFILE" {}
variable "KEY_PAIR_NAME" {}
provider "aws" {
    region = var.AWS_REGION 
    profile =  var.AWS_PROFILE 
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token = data.aws_eks_cluster.cluster.identity[0].oidc.0.issuer
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

# Create an AWS VPC. 
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true

   tags = {
    Name = "eval-7-vpc",
  }
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "eval-7-igw"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet"
  }
}

# Create private subnets across AZs
variable "azs" {
  default = ["us-east-1b", "us-east-1c"]
}
variable "cidr_blocks" {
  default = [ "10.0.0.64/26", "10.0.0.128/26"]
}

# Create private subnets across AZs
resource "aws_subnet" "private_subnets" {
  count            = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_blocks[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "eks-private-subnet"
  }
}

# security groups, etc.

# Create EKS cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = "my-eks-cluster"
  cluster_version = "1.21"
  cluster_endpoint_public_access  = true 

  vpc_id = aws_vpc.vpc.id
  subnet_ids = concat([aws_subnet.public_subnet.id], aws_subnet.private_subnets[*].id)

  eks_managed_node_group_defaults = {
    instance_type = "t2.small"
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_type = "t2.small"
    }
  }

}

# Create Kubernetes resources (e.g., deployments, services, ingress)
# Deploy app container using Kubernetes deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "my-app"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          image = "laratunc/simple_flask_app"
          name  = "my-app-container"
        }
      }
    }
  }
}

# Create Kubernetes Service to expose the app
resource "kubernetes_service" "app_service" {
  metadata {
    name = "my-app-service"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  # Expose the service to the internet
  }
}

# Output public endpoint for accessing the app
output "app_endpoint" {
  value = module.eks.cluster_endpoint
}
