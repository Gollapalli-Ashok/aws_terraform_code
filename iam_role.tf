## IAM Cluster Roles 
resource "aws_iam_role" "eks_cluster_role" {
    name = "EKS-CLUSTER-ROLE-HNK"

assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": "eks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "HNK-EKSCluster-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSCluster-CloudWatchFullAccess" {
policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
role       = aws_iam_role.eks_cluster_role.name
}

## EKS EKS Instance Role
resource "aws_iam_role" "eks_instance_role" {
    name = "hnk-Ec2toEks"
assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "HNK-EKSInstance-AmazonEC2ContainerRegistryFullAccess" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    role       = aws_iam_role.eks_instance_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSInstance-AmazonS3FullAccess" {
policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
role       = aws_iam_role.eks_instance_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSInstance-AmazonEC2ReadOnlyAccess" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    role       = aws_iam_role.eks_instance_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSInstance-AmazonEKSServicePolicy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
role       = aws_iam_role.eks_instance_role.name
}


##EKS Node role creation
resource "aws_iam_role" "eks_node_role" {
    name = "EKS-WORKER-NODE-ROLE-HNK"
assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "HNK-EKSNode-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSNode-AmazonEC2ContainerRegistryReadOnly" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSNode-CloudWatchFullAccess" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "HNK-EKSNode-AmazonEKS_CNI_Policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
role       = aws_iam_role.eks_node_role.name
}



### IAM User creation for cluster

resource "aws_iam_user" "hnk-eks-user" {
    name = "hnk-eks-cluster-user"
    tags = {
    "Name" = "hnk-eks-user"
    }
}
resource "aws_iam_access_key" "ekscluster_accesskey" {
    user        = aws_iam_user.hnk-eks-user.name
}

resource "aws_iam_user_group_membership" "hnk-iam-group-member" {
    user = "${aws_iam_user.hnk-eks-user.name}"
    groups = ["${data.aws_iam_group.hnk-eks-iam-group.group_name}"]
    depends_on = [aws_iam_user.hnk-eks-user]
}
