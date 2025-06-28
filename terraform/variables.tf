variable "tf_env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "rs-school-devops"
}

variable "owner" {
  description = "Project owner"
  type        = string
  default     = "panin"
}
# VPC CIDR block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "allowed_ssh_bastion_cidrs" {
  description = "List of CIDR blocks allowed SSH into the Bastion Host"
  type        = list(string)
  default     = []
}
variable "blocked_cidrs" {
  description = "List of CIDR blocks blocked by NACL HTTP/HTTPS block"
  type        = list(string)
  default     = []
}
# Public SSH key for SSH access to the Bastion Host
variable "public_ssh_key" {
  description = "Key pair name for SSH access to the Bastion Host"
  default     = ""
}