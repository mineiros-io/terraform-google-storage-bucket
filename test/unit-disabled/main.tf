module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  name = "unit-disabled"
}

module "testA" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  name = "unit-disabled"

  # add all optional arguments that create additional resources
  iam = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${local.project_id}"]
    }
  ]
}

module "testB" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  name = "unit-disabled"

  # add all optional arguments that create additional resources
  policy_bindings = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${local.project_id}"]
    }
  ]
}

module "testC" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  name = "unit-disabled"

  # add all optional arguments that create additional resources
  policy_bindings = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${local.project_id}"]
    }
  ]

  iam = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${local.project_id}"]
    },
    {
      role    = "roles/storage.objectAdmin"
      members = ["projectOwner:${local.project_id}"]
    }
  ]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
