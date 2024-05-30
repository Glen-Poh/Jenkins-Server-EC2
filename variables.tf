variable "ami_id" {
  type        = string
  description = "Instance AMI"
  default     = "ami-0bb84b8ffd87024d8"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
