aws_region  = "ap-south-1"
environment = "dev"
project     = "shopyyy"
domain_name = "shopyyy.com"


vpc_cidr = "10.0.0.0/16"

public_subnets = {
  "public-subnet-1" = {
    name              = "shopyyy-dev-public-subnet-1"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    is_public         = true
    vpc_name          = "shopyyy-dev-vpc"
  }
  "public-subnet-2" = {
    name              = "shopyyy-dev-public-subnet-2"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    is_public         = true
    vpc_name          = "shopyyy-dev-vpc"
  }
}

private_subnets = {
  "private-subnet-1" = {
    name              = "shopyyy-dev-private-subnet-1"
    cidr_block        = "10.0.10.0/24"
    availability_zone = "ap-south-1a"
    is_public         = false
    vpc_name          = "shopyyy-dev-vpc"
  }
  "private-subnet-2" = {
    name              = "shopyyy-dev-private-subnet-2"
    cidr_block        = "10.0.20.0/24"
    availability_zone = "ap-south-1b"
    is_public         = false
    vpc_name          = "shopyyy-dev-vpc"
  }
}


s3_frontend_bucket_name = "shopyyy-frontend-static-dev-assets"


container_image   = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
container_port    = 3000
ecs_desired_count = 2
ecs_cpu           = 256
ecs_memory        = 512


db_name              = "shopyyydb"
db_username          = "shopyyyadmin"
db_instance_class    = "db.t3.medium"
db_allocated_storage = 20

redis_node_type = "cache.t3.micro"


msk_kafka_version        = "3.8.0"
msk_broker_instance_type = "kafka.t3.small"


common_tags = {
  Project     = "shopyyy"
  Environment = "dev"
  ManagedBy   = "Terraform"
}
