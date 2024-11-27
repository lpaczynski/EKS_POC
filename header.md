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