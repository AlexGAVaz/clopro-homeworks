variable "token" {}
variable "cloud_id" {}
variable "folder_id" {}
variable "sa_backet_name" {}
variable "bucket_name" {}
variable "image_name" {}
variable "image_path" {}
variable "sa_instance_group" {}
variable "instance_group_name" {}
variable "instance_group_size" {
  type = number
}
variable "lamp_image_id" {}
variable "network_load_balancer_name" {}
variable "kms_key_name" {}
variable "create_kms" {
  description = "Flag to create KMS key"
  type        = bool
  default     = true
}
