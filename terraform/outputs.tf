output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "ecr_repositories" {
  description = "ECR repository URLs"
  value = {
    for service_name in var.service_names :
    service_name => aws_ecr_repository.services[service_name].repository_url
  }
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = var.create_rds ? aws_db_instance.main[0].endpoint : null
}

output "rds_port" {
  description = "RDS instance port"
  value       = var.create_rds ? aws_db_instance.main[0].port : null
}

output "rds_username" {
  description = "RDS instance port"
  value       = var.create_rds ? aws_db_instance.main[0].username : null
}

output "rds_password" {
  description = "RDS instance port"
  value       = var.create_rds ? aws_db_instance.main[0].password : null
  sensitive = true
}

# Output for kubectl configuration
output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${module.eks.cluster_name}"
}