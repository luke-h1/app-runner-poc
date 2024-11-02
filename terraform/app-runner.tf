resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "application_subnet_a" {
  availability_zone = "eu-west-2a"
}

resource "aws_default_subnet" "application_subnet_b" {
  availability_zone = "eu-west-2b"
}

resource "aws_default_subnet" "application_subnet_c" {
  availability_zone = "eu-west-2c"
}


resource "aws_security_group" "sg" {
  name   = "${var.project_name}-${var.env}-app-runner-security-group"
  vpc_id = aws_default_vpc.default_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "app_runner_role" {
  name = "${var.project_name}-${var.env}-app-runner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

module "app_runner_image_base" {
  source          = "terraform-aws-modules/app-runner/aws"
  service_name    = var.project_name
  count           = 1
  private_ecr_arn = aws_ecr_repository.application_ecr_repo.arn
  # From shared configs
  # IAM instance profile permissions to access secrets
  # instance_policy_statements = {
  #   GetSecretValue = {
  #     actions   = ["secretsmanager:GetSecretValue"]
  #     resources = [aws_secretsmanager_secret.this.arn]
  #   }
  # }

  source_configuration = {
    auto_deployments_enabled = false
    authentication_configuration = {
      # connection_arn  = aws_ecr_repository.application_ecr_repo.arn
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
    image_repository = {
      image_configuration = {
        port = 8000
        runtime_environment_variables = {
          MY_VARIABLE = "hello!"
        }
        # runtime_environment_secrets = {
        #   MY_SECRET = aws_secretsmanager_secret.this.arn
        # }
      }
      image_identifier      = "${aws_ecr_repository.application_ecr_repo.repository_url}:${var.docker_image_tag}"
      image_repository_type = "ECR"
    }
  }

  create_vpc_connector = true
  vpc_connector_subnets = [
    "${aws_default_subnet.application_subnet_a.id}",
    "${aws_default_subnet.application_subnet_b.id}",
    "${aws_default_subnet.application_subnet_c.id}"
  ]
  vpc_connector_security_groups = [aws_security_group.sg.id]
  network_configuration = {
    egress_configuration = {
      egress_type = "VPC"
    }
  }

  enable_observability_configuration = true

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}