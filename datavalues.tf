### VPN VPC data values (10.13.0.0/16)
data "aws_vpc" "vpc-bail-sec" {
    tags = {
    Name = "VPC-BIAL-SEC"
    }
}

data "aws_subnet" "sec-dmz-1a" {
    tags = {
    Name = "SEC-DMZ-1a"
    }
}

### data values for eks workstation
data "aws_ami" "eks-workstation" {
most_recent      = true
owners           = ["amazon"]
filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
}
filter {
    name   = "root-device-type"
    values = ["ebs"]
}
filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }
filter {
    name = "architecture"
    values = [ "x86_64" ]
    }
}

### For availability zones ap-south-1
data "aws_availability_zones" "az" {
    state = "available"
}


data "aws_iam_group" "hnk-eks-iam-group" {
    group_name = "EksClusterGroup"
    
}

/*
### data values for eks cluster
data "aws_iam_role" "cluster_role" {
    name = "EKS-CLUSTER-ROLE-DEV"
}

data "aws_iam_role" "instance_role" {
    name = "Ec2toEks"
}

data "aws_iam_role" "node_role" {
    name = "EKS-WORKER-NODE-ROLE-DEV"
}
*/