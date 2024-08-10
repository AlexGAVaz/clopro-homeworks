resource "random_string" "unique_id" {
  length  = 8
  special = false
}

locals {
  kms_name        = var.kms_key_name
  kms_key_with_id = "${local.kms_name}-${random_string.unique_id.result}"
}

resource "yandex_kms_symmetric_key" "kms_key" {
  count             = var.create_kms ? 1 : 0
  folder_id         = var.folder_id
  name              = local.kms_key_with_id
  description       = "KMS key for bucket encryption"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"  # 1 год
}

resource "yandex_kms_symmetric_key_iam_binding" "encrypter_decrypter" {
  count            = var.create_kms ? 1 : 0
  symmetric_key_id = yandex_kms_symmetric_key.kms_key[count.index].id
  role             = "kms.keys.encrypterDecrypter"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
  ]
}
