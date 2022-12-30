locals {
  # filter all objects that define a single role
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  # filter all objects that define multiple roles and expand them to single roles
  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  iam = concat(local.iam_role, local.iam_roles)

  iam_map = { for idx, iam in local.iam :
    try(iam._key, "${iam.role}/${iam.condition._key}", iam.condition != null ? "${iam.role}/${md5(jsonencode(iam.condition))}" : iam.role, iam.role) => idx
  }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket-iam.git?ref=v0.1.1"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  bucket = try(google_storage_bucket.bucket[0].name, null)

  role = local.iam[each.value].role

  members              = try(local.iam[each.value].members, [])
  computed_members_map = var.computed_members_map

  condition     = try(local.iam[each.value].condition, null)
  authoritative = try(local.iam[each.value].authoritative, true)
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket-iam.git?ref=v0.1.1"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  bucket               = try(google_storage_bucket.bucket[0].name, null)
  policy_bindings      = var.policy_bindings
  computed_members_map = var.computed_members_map
}
