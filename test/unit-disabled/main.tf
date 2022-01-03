# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EMPTY FEATURES (DISABLED) UNIT TEST
# This module tests an empty set of features.
# The purpose is to verify no resources are created when the module is disabled.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "gcp_region" {
  type        = string
  description = "(Required) The gcp region in which all resources will be created."
}

variable "gcp_project" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs."
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

# DO NOT RENAME MODULE NAME
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
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:noneExistingServiceAccount"]
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
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:noneExistingServiceAccount"]
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
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:noneExistingServiceAccount"]
    }
  ]

  iam = [
    {
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:noneExistingServiceAccount"]
    }
  ]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
