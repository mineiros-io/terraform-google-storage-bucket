locals {
  iam_map = { for iam in var.iam : iam.role => iam }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket-iam.git?ref=v0.0.2"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  bucket        = try(google_storage_bucket.bucket[0].name, null)
  role          = each.value.role
  members       = each.value.members
  authoritative = try(each.value.authoritative, true)
}

moved {
  from = module.iam["iam_policy"]
  to   = module.policy_bindings[0]
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket-iam.git?ref=v0.0.2"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  bucket          = try(google_storage_bucket.bucket[0].name, null)
  policy_bindings = var.policy_bindings
}
