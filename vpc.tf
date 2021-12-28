### Terraform provider details
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "=>3.42.0"
    }
  }
}

## VPC Creation for EKS Cluster HONGKONG DEV Environment
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name"                                      = "${var.prefix}"
    "environment"                               = "Development"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

### DMZ Public subnets for AZ - ap-south (1a, 1b) | NAT GATEWAY
resource "aws_subnet" "public_subnet_01" {
  availability_zone       = data.aws_availability_zones.az.names[0]
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_1
  map_public_ip_on_launch = true
  tags = {
    "Name"        = "HNK-PUBLIC-SUBNET-DMZ-1A"
    "environment" = "Development"
    #"kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public_subnet_02" {
  availability_zone       = data.aws_availability_zones.az.names[1]
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_2
  map_public_ip_on_launch = true
  tags = {
    "Name"                = "HNK-PUBLIC-SUBNET-DMZ-1B"
    "environment"         = "Development"
  }
}

### Two Private subnets for EKS Cluster AZ 1a & 1b
resource "aws_subnet" "private_subnet_01" {
  availability_zone = data.aws_availability_zones.az.names[0]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_1
  tags = {
    "Name"                                      = "HNK-PRIVATE-SUBENT-EKS-1A"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private_subnet_02" {
  availability_zone = data.aws_availability_zones.az.names[1]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_2
  tags = {
    "Name"                                      = "HNK-PRIVATE-SUBENT-EKS-1B"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#### Private subnets for RDS DB
resource "aws_subnet" "private_subnet_03" {
  availability_zone = data.aws_availability_zones.az.names[0]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_3
  tags = {
    "Name"          = "HNK-PRIVATE-SUBENT-RDS-1A"
  }
}

resource "aws_subnet" "private_subnet_04" {
  availability_zone = data.aws_availability_zones.az.names[1]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_4
  tags = {
    "Name" = "HNK-PRIVATE-SUBENT-RDS-1B"
  }
}

### Private subnets for REDIS 
resource "aws_subnet" "private_subnet_05" {
  availability_zone = data.aws_availability_zones.az.names[0]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_5
  tags = {
    "Name" = "HNK-PRIVATE-SUBENT-REDIS-1A"
  }
}

resource "aws_subnet" "private_subnet_06" {
  availability_zone = data.aws_availability_zones.az.names[1]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_6
  tags = {
    "Name" = "HNK-PRIVATE-SUBENT-RDS-1B"
  }
}

### Private subnets for Work station
resource "aws_subnet" "private_subnet_07" {
  availability_zone = data.aws_availability_zones.az.names[0]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_7
  tags = {
    "Name" = "HNK-PRIVATE-SUBENT-WORKSTATION"
  }
}

## Internet gateway associated with VPC
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    "Name" = "${var.prefix}-IGW"
  }
}

/*
### NGW Associated with Public Subnets and its depends on Internet Gateway for EIP
resource "aws_nat_gateway" "nat_gateway_01" {
  subnet_id     = aws_subnet.public_subnet_01.id
  allocation_id = aws_eip.nat_eip_01.id

  tags = {
    "Name" = "hnk-public-ngw-1a"
  }
  depends_on = [aws_internet_gateway.eks_igw]
}
*/

resource "aws_nat_gateway" "nat_gateway_02" {
  subnet_id         = aws_subnet.public_subnet_02.id
  allocation_id     = aws_eip.nat_eip_02.id
  tags = {
    "Name"          = "HNK-PUBLIC-NGW-1B"
  }
  depends_on        = [aws_internet_gateway.eks_igw]
}

/*
### EIP Allowcated to Natgateway 1 & 2
resource "aws_eip" "nat_eip_01" {
  vpc = true
  depends_on = [aws_internet_gateway.eks_igw]
}
*/

resource "aws_eip" "nat_eip_02" {
  vpc = true
  depends_on = [aws_internet_gateway.eks_igw]
  tags = {
    "Name" = "HNK-EIP-NGW-1B"
  }
}


### Public Route Table associated with DMZ subnet 1a & 1b
###CIDR Block: 10.18.0.0/24 10.18.1.0/24
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  route { 
    cidr_block = "10.13.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.hnk-tgw-dev.id
  }
  tags = {
    "Name" = "HNK-PUBLIC-RT-DEV-DMZ"
  }
}

### Below two Private Route Tables associate with the respective subnets of 1aworkstation-1a, eks-1a, rds-1a & redis-1a 
##CIDR Blocks (10.18.8.0/24, 10.18.2.0/24, 10.18.4.0/24, 10.18.8.6/24)
resource "aws_route_table" "private_routetable_01" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_02.id
  }
  route { 
    cidr_block = "10.13.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.hnk-tgw-dev.id
  }
  tags = {
    "Name" = "HNK-PRIVATE-RT-DEV-1A"
  }
  depends_on = [aws_nat_gateway.nat_gateway_02]
}


### Private Route Table 1a & 1b and associated the respective subnets of rds-1b, redis-1b & eks-1b
###CIDR Block (10.18.5.0/24, 10.18.3.0/24, 10.18.7.0/24)
resource "aws_route_table" "private_routetable_02" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_02.id
  }
  route { 
    cidr_block = "10.13.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.hnk-tgw-dev.id
  }
  tags = {
    "Name" = "HNK-PRIVATE-RT-DEV-1B"
  }
  depends_on = [aws_nat_gateway.nat_gateway_02]
}

### Route tabale associated with public subnets DMZ 1a & 1b CIDR Block: 10.18.0.0/24 10.18.1.0/24
resource "aws_route_table_association" "rta_asso_public1" {
  subnet_id      = aws_subnet.public_subnet_01.id        
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "rta_asso_public2" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.public_routetable.id
}

### Route tabale associated with private subnets workstation-1a, eks-1a, rds-1a & redis-1a 
##CIDR Blocks (10.18.8.0/24, 10.18.2.0/24, 10.18.4.0/24, 10.18.8.6/24)
resource "aws_route_table_association" "rta_asso_private1" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_routetable_01.id
}

resource "aws_route_table_association" "rta_asso_private2" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.private_routetable_02.id
}

resource "aws_route_table_association" "rta_asso_private3" {
  subnet_id      = aws_subnet.private_subnet_03.id
  route_table_id = aws_route_table.private_routetable_01.id
}

resource "aws_route_table_association" "rta_asso_private4" {
  subnet_id      = aws_subnet.private_subnet_04.id
  route_table_id = aws_route_table.private_routetable_02.id
}

resource "aws_route_table_association" "rta_asso_private5" {
  subnet_id      = aws_subnet.private_subnet_05.id
  route_table_id = aws_route_table.private_routetable_01.id
}

resource "aws_route_table_association" "rta_asso_private6" {
  subnet_id      = aws_subnet.private_subnet_06.id
  route_table_id = aws_route_table.private_routetable_02.id
}

resource "aws_route_table_association" "rta_asso_private7" {
  subnet_id      = aws_subnet.private_subnet_07.id
  route_table_id = aws_route_table.private_routetable_01.id
}

### Allow ports via Security Group
resource "aws_security_group" "vpc_sg" {
  name        = "hnk_vpc_sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description      = "All from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["65.0.84.23/32"]

  }
  ingress {
    description      = "All from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.13.0.0/16"]
  }
  ingress {
    description      = "All from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.18.0.0/16"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    "Name"           = "HNK-SG-DEV-PHASE3"
  }
}
