variable "environment" {
  description = "environment"
  type        = string
  default     = "dev"
}

variable "component_type" {
  description = "type of the component"
  type        = string
}

variable "feature_name" {
  description = "name of the feature"
  type        = string

}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "hello-world-cluster"
}

variable "instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t2.micro"
}

variable "desired_nodes" {
  description = "Number of desired nodes in the node group"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "id of the VPC"
  type        = string
}

