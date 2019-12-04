output "public_api_ip" {
  value = "Kubernetes API: https://${aws_instance.k3os_master.public_dns}:6443"
}

#todo
#rancher_token
