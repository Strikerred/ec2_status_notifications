
variable "aws_region" {
  description = "AWS Region in which this service will be deployed"
  type        = string
}

variable "environment" {
  description = "Environment for which this service will be deployed"
  type        = string
}

variable "department" {
  description = "Department responsible for this service"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "instance_id" {
  description = "Ec2 Instance ID"
  type        = list(string)
}

variable "security_group_id" {
  description = "security group ID"
  type        = list(string)
}

variable "eni_attachment_id" {
  description = "ID that is generated once the eni is attached to a resource"
  type        = list(string)
}

variable "network_interface_id" {
  description = "Network interface ID"
  type        = list(string)
}

variable "eip_association_id" {
  description = "Elastic IP association ID"
  type        = list(string)
}
