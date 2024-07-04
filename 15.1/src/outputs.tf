output "vpc_network_id" {
  description = "ID созданной VPC сети"
  value       = yandex_vpc_network.main.id
}

output "public_subnet_id" {
  description = "ID созданной публичной подсети"
  value       = yandex_vpc_subnet.public.id
}

output "nat_instance_ip" {
  description = "IP-адрес NAT-инстанса"
  value       = yandex_compute_instance.nat_instance.network_interface[0].ip_address
}

output "private_subnet_id" {
  description = "ID созданной приватной подсети"
  value       = yandex_vpc_subnet.private.id
}

output "private_route_table_id" {
  description = "ID таблицы маршрутов для приватной подсети"
  value       = yandex_vpc_route_table.private_route_table.id
}
