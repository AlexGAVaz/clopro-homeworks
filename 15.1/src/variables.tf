variable "token" { type = string }
variable "cloud_id" { type = string }
variable "folder_id" { type = string }
variable "labels" {
  description = "Set of key/value label pairs to assign."
  type        = map(string)
  default     = { created_by = "terraform" }
}
variable "public_subnet_cidr" {
  description = "CIDR блок для публичной подсети"
  type        = string
}
variable "private_subnet_cidr" {
  description = "CIDR блок для приватной подсети"
  type        = string
}
variable "nat_instance_ip" {
  description = "IP-адрес для NAT-инстанса"
  type        = string
}
variable "nat_image_id" {
  description = "ID образа для NAT-инстанса"
  type        = string
}
variable "public_zone" {
  description = "Зона для публичной подсети"
  type        = string
}
variable "private_zone" {
  description = "Зона для приватной подсети"
  type        = string
}
variable "nat_instance_cores" {
  description = "Количество ядер для NAT-инстанса"
  type        = number
}
variable "nat_instance_memory" {
  description = "Объем памяти (в ГБ) для NAT-инстанса"
  type        = number
}
variable "ssh_public_key_path" {
  description = "Путь к публичному ключу SSH"
  type        = string
}
