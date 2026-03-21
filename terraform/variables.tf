variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI for ap-south-1"
  type        = string
  default = "ami-00de3875b03809ec5"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "cloud-monitoring"
}