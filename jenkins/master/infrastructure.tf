variable "key_name" {
  type = string
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

data "aws_ami" "jenkins_master" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-master-*"]
  }
}

resource "aws_iam_role" "jenkins_master_role" {
  name               = "jenkins_master_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jenkins_master_role_policy_attachment" {
  role       = aws_iam_role.jenkins_master_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "jenkins_master_instance_profile" {
  name  = "jenkins_master_instance_profile"
  role  = aws_iam_role.jenkins_master_role.name
}

resource "aws_security_group" "jenkins_master_sg" {
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_master" {
  ami                  = data.aws_ami.jenkins_master.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.jenkins_master_sg.name]
  iam_instance_profile = aws_iam_instance_profile.jenkins_master_instance_profile.name
  user_data            = "yum update -y"
  key_name             = var.key_name
  tags = {
    Name = "jenkins-master"
  }
}

output "jenkins_master_url" {
  value = aws_instance.jenkins_master.public_dns
}
