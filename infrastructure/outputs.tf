output "my_ip_cidr" {
  value = local.my_ip_cidr
}
output "ssh_command" {
  # Point at whichever private key matches the key pair that was uploaded
  value = "ssh -i ${local.use_existing_key ? trimsuffix(var.existing_public_key_path, ".pub") : "${path.module}/amali-iac-lab-key.pem"} ec2-user@${aws_instance.iac_lab_ec2.public_ip}"
}
output "ami_id" {
  value = aws_instance.iac_lab_ec2.ami
}
