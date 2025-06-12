variable "ami" {
    description = "AMI for the EC2 instance for the server"
    type = string
    default = "ami-05f991c49d264708f" # Ubuntu Server 24.04 LTS (HVM) - Change this if you want to use a different OS, but I like Ubuntu
}

variable "instance_name" {
    description = "The name of the EC2 instance for the server"
    type = string
    default = "Project2-Server"
}

variable "instance_type" {
    description = "The type of AWS instance to make"
    type = string
    default = "t3.medium"
}

variable "region" {
    description = "The AWS region to use"
    type = string
    default = "us-west-2"
}