terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

variable "resource_prefix" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "cluster_version" { type = string }
variable "node_instance_type" { type = string }
variable "node_min_size" { type = number }
variable "node_max_size" { type = number }

# 1. Ambil data LabRole bawaan Vocareum
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# 2. EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "${var.resource_prefix}-eks-cluster"
  role_arn = data.aws_iam_role.lab_role.arn # Tambahkan "data."
  version  = "1.28"

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.security_group_id]
  }

  tags = {
    Name = "${var.resource_prefix}-eks-cluster"
  }
}

# 3. EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.resource_prefix}-node-group"
  node_role_arn   = data.aws_iam_role.lab_role.arn # Tambahkan "data."
  subnet_ids      = var.private_subnet_ids

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = var.node_min_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  tags = {
    Name = "${var.resource_prefix}-node-group"
  }
}

# Outputs
output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}
