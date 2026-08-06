resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {

  identifier = "${var.project_name}-${var.environment}-postgres"

  allocated_storage = 20
  max_allocated_storage = 100

  engine = "postgres"
  engine_version = "15.5"

  instance_class = "db.t3.micro"

  db_name = "enterprise_db"

  username = var.db_username
  password = var.db_password

  port = 5432

  publicly_accessible = false

  multi_az = false

  storage_encrypted = true

  deletion_protection = false

  backup_retention_period = 0

  auto_minor_version_upgrade = true

  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
