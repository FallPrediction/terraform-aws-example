output "app_server_public_ip" {
  description = "Public IP address of App server"
  value       = aws_eip.app_server_ip.public_ip
}

output "nat_public_ip" {
  description = "Public IP address of NAT"
  value       = aws_eip.nat_ip.public_ip
}

output "test_server_private_ip" {
  description = "Private IP address of Test server"
  value       = aws_instance.test_server.private_ip
}
