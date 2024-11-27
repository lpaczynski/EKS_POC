locals {

  # constants

  #variable mapping
  environment   = var.environment
  vpc_id        = var.vpc_id
  desired_nodes = var.desired_nodes
  instance_type = var.instance_type

  # data mapping
  public_subnet_ids = data.aws_subnets.existing_public_subnets.ids

  # constructed
  account_env_prefix = "daveo-${local.environment}"
  tags = {
    "created-by"  = "terraform"
    "Environment" = local.environment
    "component-type"   = var.component_type
    "application-name" = "${local.account_env_prefix}-ecs-cluster"
    "feature-name"     = var.feature_name
  }
}
