variable "api_eip" {
  type        = string
  default     = null
  description = "EIP Association id for the master node"
}

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH Keys to inject into nodes"
}

variable "data_sources" {
  type        = list
  default     = ["aws"]
  description = "data sources for node"
}

variable "kernel_modules" {
  type        = list
  default     = []
  description = "kernel modules for node"
}

variable "sysctls" {
  type        = list
  default     = []
  description = "kernel modules for node"
}

variable "dns_nameservers" {
  type        = list
  default     = ["8.8.8.8", "1.1.1.1"]
  description = "kernel modules for node"
}

variable "ntp_servers" {
  type        = list
  default     = ["0.us.pool.ntp.org", "1.us.pool.ntp.org"]
  description = "ntp servers"
}

variable "agent_image_id" {
  type        = string
  default     = "ami-0321c23916e5dd770"
  description = "AMI to use for k3s agent instances"
}

variable "server_image_id" {
  type        = string
  default     = "ami-0321c23916e5dd770"
  description = "AMI to use for k3s server instances"
}

variable "server_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "agent_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "server_node_count" {
  type        = number
  default     = 1
  description = "Number of server nodes to launch"
}

variable "agent_node_count" {
  type        = number
  default     = 3
  description = "Number of agent nodes to launch"
}

#TODO: Randomly Generate this if undefined
variable "k3s_cluster_secret" {
  default     = "abcdef12345"
  type        = string
  description = "Override to set k3s cluster registration secret - This will be made random at default"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR"

}

variable "vpc_subnet" {
  default     = "10.0.1.0/24"
  type        = string
  description = "VPC Subnet"
}

variable "keypair_name" {
  default     = "k3s_key"
  type        = string
  description = "Keypair name"
}

variable "keypair_key" {
  default     = "ssh-rsa AAAAB3NADSKJFJDSAFdsafds example@example.com"
  type        = string
  description = "Keypair Key"
}

# Coming soon
#variable "install_certmanager" {
#  default     = false
#  type        = bool
#  description = "Boolean that defines whether or not to install Cert-Manager"
#}
#
#
#variable "k3s_deploy_traefik" {
#  default     = true
#  type        = bool
#  description = "Configures whether to deploy traefik ingress or not"
#}
#
#
#variable "k3s_deploy_local_storage" {
#  default     = true
#  type        = bool
#  description = "Configures whether to deploy traefik ingress or not"
#}
#
#
#variable "k3s_deploy_coredns" {
#  default     = true
#  type        = bool
#  description = "Configures whether to deploy traefik ingress or not"
#}

