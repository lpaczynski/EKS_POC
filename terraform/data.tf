# Network
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "existing_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"] # Filtre les subnets dont le tag Name contient 'public'
  }
}

#EKS
data "aws_eks_cluster_auth" "eks" {
  name = module.eks_al2.cluster_name
}