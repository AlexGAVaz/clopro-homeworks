terraform {
  required_version = ">= 1.0.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.101.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 3.3"
    }
  }
  backend "s3" {
    bucket                      = "my-state"
    key                         = "vpc/terraform.tfstate"
    region                      = "ru-central1"
    endpoint                    = "storage.yandexcloud.net"
    shared_credentials_file     = "./storage.key"
    skip_region_validation      = true
    skip_credentials_validation = true
    dynamodb_endpoint           = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gcla1jpo0ir7kgd3d8/etnvi320ni20h22juaqf"
    dynamodb_table              = "demo-block-state"
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}
