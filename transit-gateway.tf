### Trasit gateway creation
resource "aws_ec2_transit_gateway" "hnk-tgw-dev" {
    description     = "Hongkong Transit Gateway"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    tags            = {
    Name            = "${var.test-hnk-tgw}"
    }
}

# VPC attachment   ### need add all remainig all private & pub subnets
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-hnk-vpc" {
    transit_gateway_id = "${aws_ec2_transit_gateway.hnk-tgw-dev.id}"
    vpc_id            = "${aws_vpc.eks_vpc.id}"
    transit_gateway_default_route_table_association = false
    transit_gateway_default_route_table_propagation = false
    #subnet_ids = ["${aws_subnet.private_subnet_01.id}", "${aws_subnet.private_subnet_02.id}", "${aws_subnet.private_subnet_03.id}", "${aws_subnet.private_subnet_04.id}", "${aws_subnet.private_subnet_05.id}", "${aws_subnet.private_subnet_06.id}", "${aws_subnet.private_subnet_07.id}", "${aws_subnet.public_subnet_01.id}", "${aws_subnet.public_subnet_02.id}"]
    subnet_ids          = ["${aws_subnet.public_subnet_01.id}", "${aws_subnet.public_subnet_02.id}"]
    tags                = {
    Name                = "TGW-VPC-ATT-HNK-DEV"
    }
    depends_on = [aws_ec2_transit_gateway.hnk-tgw-dev]
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpn-vpc" {
    transit_gateway_id = "${aws_ec2_transit_gateway.hnk-tgw-dev.id}"
    vpc_id            = "${data.aws_vpc.vpc-bail-sec.id}"
    transit_gateway_default_route_table_association = false
    transit_gateway_default_route_table_propagation = false
    subnet_ids          = ["${data.aws_subnet.sec-dmz-1a.id}"]
    tags                = {
    Name                = "TGW-ATT-VPN-VPC"
    }
    depends_on = [aws_ec2_transit_gateway.hnk-tgw-dev]
}

# Route Tables
resource "aws_ec2_transit_gateway_route_table" "hnk-tgw-dev-rt" {
  transit_gateway_id = "${aws_ec2_transit_gateway.hnk-tgw-dev.id}"
  tags               = {
    Name             = "TGW-HNK-RT-DEV-PHASE3"
  }
  depends_on = [aws_ec2_transit_gateway.hnk-tgw-dev]
}

# Route Tables Associations
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-hnkvpc-assoc" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-hnk-vpc.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.hnk-tgw-dev-rt.id}"
}

# Route Tables Propagations
## This section defines which VPCs will be routed from each Route Table created in the Transit Gateway
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-hnk-propg" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-hnk-vpc.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.hnk-tgw-dev-rt.id}"
}

# Route Tables Associations for VPN VPC
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-hnk-vpn-vpc-assoc" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpn-vpc.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.hnk-tgw-dev-rt.id}"
}

# Route Tables Propagations doe VPN VPC
## This section defines which VPCs will be routed from each Route Table created in the Transit Gateway
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-vpn-vpc-hnk-propg" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpn-vpc.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.hnk-tgw-dev-rt.id}"
}