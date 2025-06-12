terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = var.region
}

resource "tls_private_key" "key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "server_key" {
    key_name = "server-key"
    public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.key.private_key_pem
    filename = "${path.module}/../private_key.pem"
    file_permission = "0400"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }

}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "server_security_group" {
    name = "server_security_group"
    vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_mc_port" {
    security_group_id = aws_security_group.server_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 25565
    to_port = 25565
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.server_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
    security_group_id = aws_security_group.server_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_instance" "minecraft_server" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnet.id
    vpc_security_group_ids = [aws_security_group.server_security_group.id]
    key_name = aws_key_pair.server_key.key_name
    associate_public_ip_address = true
    tags = {
        Name = var.instance_name
    }
}