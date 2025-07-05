variable "allowed_ssh_bastion_cidrs" {
  type = list(string)
}
variable "vpc_id" {
  description = "Current VPC ID"
  type        = string
}