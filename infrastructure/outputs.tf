output "my_ip_cidr" {
  value = local.my_ip_cidr
}
output "ssh_command" {
  value = "ssh -i ${path.module}/amali-iac-lab-key.pem ec2-user@${aws_instance.iac_lab_ec2.public_ip}"
}