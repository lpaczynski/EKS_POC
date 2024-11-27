### with module terraform-aws-modules/eks/aws

module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.account_env_prefix}-al2"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = local.vpc_id
  subnet_ids = local.public_subnet_ids

  eks_managed_node_groups = {
    control_node = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = [var.instance_type]

      min_size     = local.desired_nodes
      max_size     = local.desired_nodes
      desired_size = local.desired_nodes
      labels = {
        role = "control"
      }
    #   taints = [
    #     {
    #         key = "dedicated"
    #         effect = "NO_SCHEDULE"
    #         value  = "control"
    #     }
    #   ]
    }
    worker_node = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = [local.instance_type]

      min_size     = local.desired_nodes
      max_size     = local.desired_nodes
      desired_size = local.desired_nodes
      labels = {
        role = "worker"
      }
    }
  }

  tags = local.tags
}


