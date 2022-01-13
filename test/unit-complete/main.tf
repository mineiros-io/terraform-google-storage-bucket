# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
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

data "google_project" "project" {}

resource "random_id" "suffix" {
  byte_length = 16
}


# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name = "unit-complete-${random_id.suffix.hex}"

  # add all optional arguments that create additional resources
  force_destroy               = true
  location                    = "EU"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                   = 60
      created_before        = "2021-08-20"
      with_state            = "LIVE"
      matches_storage_class = ["STANDARD"]
      num_newer_versions    = 10
    }
  }]
  versioning_enabled = true

  cors = [{
    origin          = ["https://mineiros.io"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]

  # add most/all other optional arguments

  # module_timeouts = {
  #   google_monitoring_notification_channel = {
  #     create = "10m"
  #     update = "10m"
  #     delete = "10m"
  #   }
  # }

  module_depends_on = ["nothing"]
}

module "testIAM" {
  source = "../.."

  name = "unit-complete-iam-${random_id.suffix.hex}"

  force_destroy = true

  iam = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${data.google_project.project.project_id}"]
    }
  ]
}

module "testPolicy" {
  source = "../.."

  name = "unit-complete-policy-${random_id.suffix.hex}"

  force_destroy = true

  policy_bindings = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:${data.google_project.project.project_id}"]
    }
  ]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
