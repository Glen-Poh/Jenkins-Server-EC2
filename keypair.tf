#Resource to create a SSH private key
resource "tls_private_key" "jenkins_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Resource to Create Key Pair
resource "aws_key_pair" "jenkins_server_keypair" {
  key_name   = "Jenkins_server_keypair"
  public_key = tls_private_key.jenkins_keypair.public_key_openssh
}

resource "local_file" "jenkins_server_keypair_private" {
  filename        = "Jenkins_server_keypair_private"
  file_permission = "0400"
  content         = tls_private_key.jenkins_keypair.private_key_pem
}

