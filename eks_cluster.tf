/*
### EKS Cluster configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  #role_arn = data.aws_iam_role.cluster_role.arn
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = "1.19"
  #enabled_cluster_log_types = ["api", "audit", "Authenticator"]

  vpc_config {
    subnet_ids              = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.vpc_sg.id]
  }
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.ekskey.arn
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.HNK-EKSCluster-AmazonEKSClusterPolicy, 
    aws_iam_role_policy_attachment.HNK-EKSCluster-CloudWatchFullAccess
  ]
}

resource "aws_kms_key" "ekskey" {
    description = "EKS-CLUSTER-ENCRYPTION-KEY"
}

resource "aws_eks_addon" "eks_addon" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  count         = 3
  addon_name    = var.add-on[count.index]
  addon_version = var.add-on_version[count.index]
  tags = {
    "Name" = "${var.add-on[count.index]}"
  }
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

### EKS Cluster Node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "HNK-EKS-NODE-GROUP"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
  instance_types  = [var.worker-node-instancetype]
  
  tags = {
    "cluster-name"                = aws_eks_cluster.eks_cluster.name
    "version"                     = "0.29.2"
    "nodegroup-name"              = "HNK-EKS-NODE-GROUP"
    "nodegroup-type"              = "managed"
  }
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1  
  }
  remote_access {
    ec2_ssh_key = var.ws_instance_keypair
  }
  disk_size = 20
  version = "1.19"
  force_update_version = false
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
depends_on = [
  aws_iam_role_policy_attachment.HNK-EKSNode-AmazonEKSWorkerNodePolicy,
  aws_iam_role_policy_attachment.HNK-EKSNode-AmazonEC2ContainerRegistryReadOnly,
  aws_iam_role_policy_attachment.HNK-EKSNode-CloudWatchFullAccess,
  aws_iam_role_policy_attachment.HNK-EKSNode-AmazonEKS_CNI_Policy
]
}

*/