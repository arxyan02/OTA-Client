aws_region         = "us-west-2"
environment        = "dev"
project_name       = "valtech-ota"
cluster_name       = "valtech-ota-cluster"
kubernetes_version = "1.27"

# VPC Configuration
vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# EKS Node Configuration
node_instance_types = ["t3.medium"]
min_nodes           = 1
max_nodes           = 10
desired_nodes       = 3

# Your four Spring Boot services
service_names = [
  "campaign-management",
  "firmware-management",
  "update-management",
  "vehicle-management"
]

# Database Configuration
create_rds               = true
db_allocated_storage     = 20
db_max_allocated_storage = 100
db_instance_class        = "db.t3.micro"
db_name                  = "valtech_ota"
db_username              = "postgres"