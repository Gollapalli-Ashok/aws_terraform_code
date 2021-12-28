
### EKS Workstation creation for HNK
resource "aws_instance" "Workstation" {
  ami                    = data.aws_ami.eks-workstation.id
  instance_type          = var.ws_instance_type
  key_name               = var.ws_instance_keypair
  vpc_security_group_ids = [aws_security_group.vpc_sg.id]
  subnet_id              = aws_subnet.private_subnet_07.id
  user_data = file("./configurations.sh")

  tags = {
    "Name" = "HNK-EKS-WORKSTATTION"
    "Environment" = "Devolepment"
  }

}



