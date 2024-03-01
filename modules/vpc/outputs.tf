output "vpc_id" {
  value = aws_vpc.dynatron.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "security_groups" {
  value = aws_security_group.security_group.id
}