output "bucket_name" {
  value = yandex_storage_bucket.bucket.bucket
}

output "instance_group_id" {
  value = yandex_compute_instance_group.lamp-group.id
}

output "load_balancer_ip" {
  value = yandex_lb_network_load_balancer.network-load-balancer.listener[*].external_address_spec[*].address
}



