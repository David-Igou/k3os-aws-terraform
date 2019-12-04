# k3os-aws-terraform

This is a WIP, in its first MVP.

The purpose of this repo is to deploy k3os on AWS, and defining configuration via terraform variables. The current design is meant to be light weight with limited features, but very easy to bring up.

Currently this only supports a single master deployment.

Future pushes will add AWS plugins, db options, loadbalancer options, more k3s flags, and hopefully I'll find an easy way to automatically deploy manifests post install.

The arguments for cloudprovider plugin/EBS CSI plugin are currently hard coded, but the plugins themselves are untested. This will be made more dynamic

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| agent\_image\_id | AMI to use for k3s agent instances | string | `"ami-0321c23916e5dd770"` | no |
| agent\_instance\_type |  | string | `"t2.micro"` | no |
| agent\_node\_count | Number of agent nodes to launch | number | `"3"` | no |
| api\_eip | EIP Association id for the master node | string | `"null"` | no |
| data\_sources | data sources for node | list | `[ "aws" ]` | no |
| dns\_nameservers | kernel modules for node | list | `[ "8.8.8.8", "1.1.1.1" ]` | no |
| k3s\_cluster\_secret | Override to set k3s cluster registration secret - This will be made random at default | string | `"abcdef12345"` | no |
| kernel\_modules | kernel modules for node | list | `[]` | no |
| keypair\_key | Keypair Key | string | `"ssh-rsa AAAAB3NADSKJFJDSAFdsafds example@example.com"` | no |
| keypair\_name | Keypair name | string | `"k3s_key"` | no |
| ntp\_servers | ntp servers | list | `[ "0.us.pool.ntp.org", "1.us.pool.ntp.org" ]` | no |
| server\_image\_id | AMI to use for k3s server instances | string | `"ami-0321c23916e5dd770"` | no |
| server\_instance\_type |  | string | `"t2.micro"` | no |
| server\_node\_count | Number of server nodes to launch | number | `"1"` | no |
| ssh\_keys | SSH Keys to inject into nodes | list | `[]` | no |
| sysctls | kernel modules for node | list | `[]` | no |
| vpc\_cidr | VPC CIDR | string | `"10.0.0.0/16"` | no |
| vpc\_subnet | VPC Subnet | string | `"10.0.1.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_api\_ip |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



