##########################
# IAM: Policies and Roles
##########################


# These are only IAM policies and roles needed use the ebs-csi plugin
# LB creation and s3 registry storage will eventually be added

resource "aws_iam_role" "k3os_iam" {
  name = "k3os_iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Role policy
resource "aws_iam_role_policy" "k3os_iam_policy" {
  name = "k3os_iam_policy"
  role = "${aws_iam_role.k3os_iam.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action" : [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyVolume",
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DescribeVpcs"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}


# IAM Instance Profile for Controller
resource  "aws_iam_instance_profile" "k3os_iamp" {
 name = "k3os_iam"
 role = "${aws_iam_role.k3os_iam.name}"
}


#Networking

resource "aws_vpc" "k3os_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
}


resource "aws_subnet" "k3os_subnet" {
  vpc_id = "${aws_vpc.k3os_vpc.id}"
  cidr_block = "${var.vpc_subnet}"
}


resource "aws_internet_gateway" "k3os_gw" {
  vpc_id = "${aws_vpc.k3os_vpc.id}"
}

# Routing

resource "aws_route_table" "k3os_rt" {
    vpc_id = "${aws_vpc.k3os_vpc.id}"

    # Default route through Internet Gateway
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.k3os_gw.id}"
    }
}

resource "aws_route_table_association" "k3os_rta" {
  subnet_id = "${aws_subnet.k3os_subnet.id}"
  route_table_id = "${aws_route_table.k3os_rt.id}"
}


#Security Group

resource "aws_security_group" "k3os_api" {
  vpc_id = "${aws_vpc.k3os_vpc.id}"
  name = "k3os-api"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "k3os_sg" {
  vpc_id = "${aws_vpc.k3os_vpc.id}"
  name = "k3os_sg"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all internal
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${aws_vpc.k3os_vpc.cidr_block}"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${aws_security_group.k3os_api.id}"]
  }

  # Allow all traffic from control host IP
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2

resource "aws_instance" "k3os_master" {
    ami = "${var.server_image_id}"
    instance_type = "${var.server_instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.k3os_iamp.id}"
    subnet_id = "${aws_subnet.k3os_subnet.id}"
    associate_public_ip_address = true # Instances have public, dynamic IP
    vpc_security_group_ids = ["${aws_security_group.k3os_sg.id}", "${aws_security_group.k3os_api.id}"]
    key_name = "${var.keypair_name}"
    user_data = "${templatefile("${path.module}/files/config_server.sh", { ssh_keys=var.ssh_keys, data_sources=var.data_sources, kernel_modules=var.kernel_modules, sysctls=var.sysctls, dns_nameservers=var.dns_nameservers, ntp_servers=var.ntp_servers, k3s_cluster_secret=var.k3s_cluster_secret})}"
    tags = {
      Name = "k3os_master",
      "kubernetes.io/cluster/default" = "owned"
    }
}

resource "aws_instance" "k3os_worker" {
    count = "${var.agent_node_count}"
    ami = "${var.agent_image_id}"
    instance_type = "${var.agent_instance_type}"
    subnet_id = "${aws_subnet.k3os_subnet.id}"
    associate_public_ip_address = true # Instances have public, dynamic IP
    vpc_security_group_ids = ["${aws_security_group.k3os_sg.id}"]
    key_name = "${var.keypair_name}"
    user_data = "${templatefile("${path.module}/files/config_agent.sh", { ssh_keys=var.ssh_keys, data_sources=var.data_sources, kernel_modules=var.kernel_modules, sysctls=var.sysctls, dns_nameservers=var.dns_nameservers, ntp_servers=var.ntp_servers, k3s_cluster_secret=var.k3s_cluster_secret, k3s_server_ip=aws_instance.k3os_master.private_dns})}"
    tags = {
      Name = "k3os_worker_${count.index + 1}",
      "kubernetes.io/cluster/default" = "owned"
    }
}

#EIP
#If an EIP is defined, attach it to the master, if not, do nothing
#I haven't figured out how to do this yet
#if var.eip.id {

resource "aws_eip_association" "k3s_master_eip_assoc" {
  count = "${var.api_eip != null ? 1 : 0}"
  instance_id   = "${aws_instance.k3os_master.id}"
  allocation_id = "${var.api_eip}"
}


#Key Pair

resource "aws_key_pair" "default_keypair" {
  key_name = "${var.keypair_name}"
  public_key = "${var.keypair_key}"
}
