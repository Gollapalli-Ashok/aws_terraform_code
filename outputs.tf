/*
### Terraform Output Values for EC2 Work station###
output "instance_publicip" {
    description = "EKS Workstation Instance Private IP"
    value = aws_instance.Workstation.private_ip
}

### Output of VPC id
output "vpc_id" {
    value       = aws_vpc.eks_vpc.id
    description = "VPC id details."
}


output "endpoint" {
    value = aws_eks_cluster.eks_cluster.endpoint
    sensitive = true
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
output "secret" {
    value = aws_iam_access_key.ekscluster_accesskey.id
    #sensitive = true
}

output "iam_secret" {
    value = aws_iam_access_key.ekscluster_accesskey.encrypted_secret
}

*/