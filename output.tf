output "jenkins_server_public_ip" {
  description = "Public IP address for Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}