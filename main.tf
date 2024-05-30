# Create Jenkins Server Security Group
resource "aws_security_group" "jenkins_server_sg" {
  name        = "jenkins_server_sg"
  description = "Allow ssh/HTTP to Jenkins server"

  tags = {
    Name    = "Jenkins_Server_SG"
    Project = "Jenkins_Setup"
  }
}
# For security reasons, Jenkins server should only allow from specific IP address. But for the ease of testing, we have allow ssh from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_port8080" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
/*
resource "aws_iam_role" "administrator_role" {
  name = "administrator_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "administrator_attachment" {
  role       = aws_iam_role.administrator_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jenkin_admin_profile" {
  name = "administrator_profile"
  role = aws_iam_role.administrator_role.name
}
*/
# Create Jenkins Server instance
resource "aws_instance" "jenkins_server" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.jenkins_server_keypair.key_name
  security_groups             = [aws_security_group.jenkins_server_sg.name]
  #iam_instance_profile        = aws_iam_instance_profile.jenkin_admin_profile.name
  # use original subnet subnet_id                   = element(aws_subnet.public_webtier_subnet[*].id, 0) 
  user_data = filebase64("${path.module}/install_jenkins_java.sh")

  tags = {
    Name    = "Jenkins_Server"
    Project = "Jenkins_Setup"
  }
}

