<!-- BEGIN_TF_DOCS -->
# EKS Cluster with Terraform

This project provisions an **Amazon Elastic Kubernetes Service (EKS)** cluster using Terraform. It includes managed node groups, necessary add-ons, and configurations to deploy workloads efficiently.

## Features

- Creates an EKS cluster with managed node groups:
  - `control_node`: For system-level or specific control tasks.
  - `worker_node`: For general workload deployments.
- Configures EKS add-ons such as:
  - CoreDNS
  - VPC CNI
  - Kube-proxy
  - EKS Pod Identity Agent
- Enables public access to the cluster API endpoint.
- Manages networking with configurable VPC and subnets.
- Provides the ability to use `kubectl` to manage the cluster.

---

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS account with permissions to manage EKS and IAM resources.

---

## Installation

Follow these steps to install and provision the EKS cluster:

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure AWS CLI

Ensure the AWS CLI is configured with credentials that have permissions to manage EKS:
```bash
aws configure
```
Provide:

AWS Access Key ID
AWS Secret Access Key
Default region (e.g., eu-west-1)
Default output format (e.g., json)

### 3. Initialize Terraform, plan, check and deploy !

Run the following command to initialize, plan, check and deploy the Terraform working directory:
```bash
terraform init
terraform plan
terraform apply
```

### 4. Authentication with kubectl
Use the AWS CLI to generate a kubeconfig file for the EKS cluster:
```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

You could now be able to run kubectl commands!

### 5. Managing permissions

EKS uses the `aws-auth` ConfigMap to manage Kubernetes Role-Based Access Control (RBAC). If you need administrative access, ensure your IAM role or user is mapped to the system:masters group.

#### Check the aws-auth ConfigMap
```bash
kubectl -n kube-system describe configmap aws-auth
```

#### Add Your IAM Role/User to aws-auth
```bash
kubectl -n kube-system edit configmap aws-auth
```

#### Add an entry for your role or user:
```bash
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<account-id>:role/<your-role-name>
      username: eks-admin
      groups:
        - system:masters
  mapUsers: |
    - userarn: arn:aws:iam::<account-id>:user/<your-username>
      username: eks-admin
      groups:
        - system:masters
```
Save the changes and verify

## Kubernetes
### Deployment: `nginx-hello-world`
This deployment provisions an Nginx container as an example application. It includes the following features:

**Replicas**: 3 for high availability.
**Environment Variable**: Passes a MESSAGE environment variable with the value hello world.
**Command**: Custom entrypoint to echo the MESSAGE and serve it on port 80 using Netcat.
**Resource Limits**: Ensures fair allocation of CPU and memory using Kubernetes requests and limits.
**Readiness and Liveness Probes**: Adds health checks for the pod to ensure it is serving traffic and can restart if unresponsive.
**Node Affinity and Tolerations**: Schedules pods on nodes labeled with role=worker.

### Service: `nginx-hello-world-service`
This service exposes the Nginx Deployment to external traffic via an AWS Network Load Balancer (NLB). Key features include:

Type: LoadBalancer for public accessibility.
Target Port: Redirects traffic to port 80 on the pods.
Annotations: Configures AWS-specific annotations for load balancer behavior.

## Terraform

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.76.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_al2"></a> [eks\_al2](#module\_eks\_al2) | terraform-aws-modules/eks/aws | ~> 20.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/security_group) | resource |
| [kubernetes_deployment.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.33.0/docs/resources/deployment) | resource |
| [kubernetes_service.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.33.0/docs/resources/service) | resource |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_subnets.existing_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/subnets) | data source |
| [aws_vpc.existing_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | `"hello-world-cluster"` | no |
| <a name="input_component_type"></a> [component\_type](#input\_component\_type) | type of the component | `string` | n/a | yes |
| <a name="input_desired_nodes"></a> [desired\_nodes](#input\_desired\_nodes) | Number of desired nodes in the node group | `number` | `2` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment | `string` | `"dev"` | no |
| <a name="input_feature_name"></a> [feature\_name](#input\_feature\_name) | name of the feature | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type for EKS nodes | `string` | `"t2.micro"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the VPC | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->