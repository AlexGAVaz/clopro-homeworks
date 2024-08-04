data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "my-state"
    region                      = "ru-central1"
    key                         = "vpc/terraform.tfstate"
    shared_credentials_file     = "./storage.key"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

resource "yandex_iam_service_account" "sa-bucket" {
  name = var.sa_backet_name
}

resource "yandex_resourcemanager_cloud_iam_member" "bucket-editor" {
  cloud_id   = var.cloud_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
  depends_on = [yandex_iam_service_account.sa-bucket]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
  description        = "static access key for bucket"
}

resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket_name
  acl        = "public-read"
}


resource "yandex_storage_object" "image" {
  bucket     = yandex_storage_bucket.bucket.bucket
  key        = var.image_name
  source     = var.image_path
  acl        = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  depends_on = [yandex_storage_bucket.bucket]
}

resource "yandex_iam_service_account" "sa-instance-group" {
  name = var.sa_instance_group
}

resource "yandex_resourcemanager_folder_iam_member" "ig-aditor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-instance-group.id}"
}

resource "yandex_compute_instance_group" "lamp-group" {
  name               = var.instance_group_name
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.sa-instance-group.id

  instance_template {
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = var.lamp_image_id
      }
    }
    network_interface {
      network_id = data.terraform_remote_state.vpc.outputs.vpc_network_id
      subnet_ids = [data.terraform_remote_state.vpc.outputs.public_subnet_id]
      nat        = true
    }
    scheduling_policy {
      preemptible = true
    }
    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><img src="http://${yandex_storage_bucket.bucket.bucket_domain_name}/image.jpg"/></html>' > index.html
service httpd start
EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = var.instance_group_size
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable  = 1
    max_creating     = 3
    max_expansion    = 1
    max_deleting     = 1
    startup_duration = 3
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  depends_on = [yandex_storage_bucket.bucket]

  load_balancer {
    target_group_name = "target-group"
  }

}

resource "yandex_lb_network_load_balancer" "network-load-balancer" {
  name = var.network_load_balancer_name

  listener {
    name = "lb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp-group.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

  depends_on = [yandex_compute_instance_group.lamp-group]
}
