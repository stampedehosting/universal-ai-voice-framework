variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for Ubuntu 22.04"
  default     = "ami-0c55b159cbfafe1f0"  # Ubuntu 22.04 in us-west-2
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key pair name"
  default     = ""
}
