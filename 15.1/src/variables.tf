variable "token" { type = string }
variable "cloud_id" { type = string }
variable "folder_id" { type = string }
variable "labels" {
  description = "Set of key/value label pairs to assign."
  type        = map(string)
  default     = { created_by = "terraform" }
}

variable "public_ssh_key" {
  description = "Public SSH key for instances"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "192.168.20.0/24"
}

variable "nat_instance_image_id" {
  description = "Image ID for the NAT instance"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}
