/*
### Create MySQL RDS Database 
resource "aws_db_instance" "hnk-dev-rdsdb" {
    #count = 2
    allocated_storage               = 20
    identifier                      = "hnk-mysqldb"
    storage_type                    =  var.dbstorage_type               
    engine                          = "mysql"
    engine_version                  = "8.0.23"
    instance_class                  = "db.t2.small"
    name                            = var.rdsdb_name
    username                        = var.username
    password                        = var.password
    parameter_group_name            = aws_db_parameter_group.db-hnk-parameter.name
    #availability_zone              = data.aws_availability_zones.az[count.index]
    availability_zone               = "ap-south-1a"
    vpc_security_group_ids          = [aws_security_group.vpc_sg.id]
    port                            = var.db_port
    db_subnet_group_name            = "${aws_db_subnet_group.dev-hnk-rds.name}"
    publicly_accessible             = false
    performance_insights_enabled    = false
    maintenance_window              = var.maintenance_window
    depends_on                      = [aws_db_subnet_group.dev-hnk-rds]
    deletion_protection             = false
    skip_final_snapshot             = true
    storage_encrypted               = true
    kms_key_id = var.kms_key_id
    tags = {
        "Name"                      = "HNK-RDSDB-PHASE3"
    }
}

resource "aws_db_parameter_group" "db-hnk-parameter" {
    name        = "hnk-rds-db-par-group-phase3"
    family      = "mysql8.0"
}

resource "aws_db_subnet_group" "dev-hnk-rds" {
    name            = "hnk-dev-db-subnet-group-phase3"
    subnet_ids      = [aws_subnet.private_subnet_03.id, aws_subnet.private_subnet_04.id]

    tags        = {
    Name        = "HNK-RDSDB-SNG-DEV-PHASE3"
    }
}

resource "aws_security_group" "hnk-rds-sg" {
    name   = "RDSDB-SG-HNK-PHASE3"
    vpc_id = aws_vpc.eks_vpc.id

    ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
    Name = "RDS-SG-HNK-DEV-PHASE3"
    }
}

*/