###For VPC naming convension
variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  default     = "VPC-HNK-DEV-phase3"
}

## AWS Region
variable "aws_region" {
  description = "The region where the resources are created."
  default     = "ap-south-1"
}

## For VPC CIDR Block variable
variable "eks_vpc_cidr" {
  description = "The address space that is used by the virtual network."
  default     = "10.18.0.0/16"
}


## For EKS Cluster variable
variable "cluster_name" {
  type    = string
  default = "EKS-CLUSTER-HNK"
}

### EKS Cluster Add-on's are vpc-cni, coredns & kube-proxy
variable "add-on" {
  type    = list(any)
  default = ["vpc-cni", "coredns", "kube-proxy"]

}

### EKS Cluster Add-on versions
variable "add-on_version" {
  type    = list(any)
  default = ["v1.7.5-eksbuild.2", "v1.8.0-eksbuild.1", "v1.19.6-eksbuild.2"]
}

## Public Subnet variables
variable "public_subnet_1" {
  description = "The address prefix to use for the public subnet 1."
  default     = "10.18.0.0/24"
}

variable "public_subnet_2" {
  description = "The address prefix to use for the public subnet 2."
  default     = "10.18.1.0/24"
}

# Private Subnet variables
variable "private_subnet_1" {
  description = "The address prefix to use for the private subnet 1."
  default     = "10.18.2.0/24"
}

variable "private_subnet_2" {
  description = "The address prefix to use for the private subnet 2."
  default     = "10.18.3.0/24"
}

variable "private_subnet_3" {
  description = "The address prefix to use for the private subnet 3."
  default     = "10.18.4.0/24"
}

variable "private_subnet_4" {
  description = "The address prefix to use for the private subnet 4."
  default     = "10.18.5.0/24"
}

variable "private_subnet_5" {
  description = "The address prefix to use for the private subnet 5."
  default     = "10.18.6.0/24"
}

variable "private_subnet_6" {
  description = "The address prefix to use for the private subnet 6."
  default     = "10.18.7.0/24"
}

variable "private_subnet_7" {
  description = "The address prefix to use for the private subnet 7."
  default     = "10.18.8.0/24"
}

### For Launch template version
variable "launch_template_version" {
  type    = string
  default = "1"

}

# AWS EC2 Instance Type
variable "ws_instance_type" {
  description = "EC2 Instance Type for hongkong "
  type = string
  default = "t2.micro"  
}

variable "worker-node-instancetype" {
  description = "for eks cluster worker nodes"
  default = "t2.small"
}

# AWS EC2 Instance Key Pair
variable "ws_instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  default = "HNK-TERRAFORM-KEY"
}

# For Trasit gateway
variable "test-hnk-tgw" {
  description = " Trasit gateway creation for hongkong"
  default = "TGW-HNK-DEV-PHASE3"
}

##S3 Bucket variables
variable "s3-bucket-sw" {
  description = "s3 bucket for static website & versioning for hongkong"
  default = "S3-Bucket-HNK-DEV-PHASE3"
  
}

### ACL S3 variable
variable "acl_value" {
    default = "private"
}

## RDS DB variables
variable "db_port" {
  default     = 3306
  type        = string
  description = "The port on which the RDS DB accepts connections."
}

variable "rdsdb_name" {
  default     = "MYSQL-RDSDB-HNK"
  type        = string
  description = "The name of the database to create when the DB instance is created."
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

/*
variable "dbinstance_class" {
  default = "db.t2.micro"
  description = "rds db instance class details"
}
*/

variable "dbstorage_type" {
    default = "gp2"
    description = "rds db storage type"
}

variable "maintenance_window" {
  default     = "Mon:16:30-Mon:17:00"
  type        = string
  description = "The window to perform maintenance in."
}

variable "username" {
  default = "admin"
  description = "RDS DB username "
}

variable "password" {
  default = "pass2021"
  description = "Password for RDS DB password"
}

variable "window" {
  description = "widnow redis cluster"
  default     = "Sat:18:00-Sat:19:00"
  
}

variable "redis_port" {
  default = 6379
  description = "Redis cluster Port no"
  type = string
  
}

variable "cluster_id" {
  description = "Hongkong redis cluster ID"
  default = "REDIS-CLUSTER-HNK-PHASE3"
}

variable "parameter_group_name_hnk" {
  default = "default.redis6.x"
  type = string
}

variable "node_type" {
  description = "Node type you want to use"
  default     = "cache.t2.small"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
  default     = 2
}

variable "engine_version" {
  description = "Redis engine version you want to use"
  default     = "6.x"
}

variable "automatic_failover_enabled" {
  default     = true
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false."
}