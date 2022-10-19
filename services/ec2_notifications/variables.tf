
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

variable "event_names" {
  type        = list(any)
  description = "These are the event names that are for rule creation"
}
