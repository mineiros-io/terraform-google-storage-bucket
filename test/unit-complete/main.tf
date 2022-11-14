module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.0.12"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test_nope" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name = "unit-complete"

  # add all optional arguments that create additional resources
  force_destroy               = true
  location                    = "EU"
  project                     = local.project_id
  storage_class               = "NEARLINE"
  uniform_bucket_level_access = true
  requester_pays              = true
  object_creators             = ["user:member@example.com"]
  object_viewers              = ["user:member@example.com"]
  object_admins               = ["user:member@example.com"]
  legacy_readers              = ["user:member@example.com"]
  legacy_writers              = ["user:member@example.com"]

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                        = 60
      created_before             = "2021-08-20"
      with_state                 = "LIVE"
      matches_storage_class      = ["STANDARD"]
      num_newer_versions         = 10
      custom_time_before         = "1970-01-01"
      days_since_custom_time     = 1
      days_since_noncurrent_time = 1
      noncurrent_time_before     = "1970-01-01"
    }
  }]
  versioning_enabled = true

  website = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors = [{
    origin          = ["https://mineiros.io"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]

  encryption_default_kms_key_name = "unit-complete"

  logging = {
    log_bucket        = "example-log-bucket"
    log_object_prefix = "gcs-log"
  }

  retention_policy = {
    is_locked        = false
    retention_period = 200000
  }

  labels = {
    label0 = "foo"
    label1 = "bar"
  }

  iam = [
    {
      role    = "roles/browser"
      members = ["domain:example-domain"]
      condition = {
        title       = "expires_after_2021_12_31"
        description = "Expiring at midnight of 2021-12-31"
        expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      }
    },
    {
      role          = "roles/viewer"
      members       = ["domain:example-domain"]
      authoritative = false
    },
    {
      roles   = ["roles/editor", "roles/browser"]
      members = ["computed:computed_sa"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  module_depends_on = ["nothing"]
}

module "test1" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name = "unit-complete"

  # add all optional arguments that create additional resources
  force_destroy               = true
  location                    = "EU"
  project                     = local.project_id
  storage_class               = "NEARLINE"
  uniform_bucket_level_access = true
  requester_pays              = true
  object_creators             = ["user:member@example.com"]
  object_viewers              = ["user:member@example.com"]
  object_admins               = ["user:member@example.com"]
  legacy_readers              = ["user:member@example.com"]
  legacy_writers              = ["user:member@example.com"]

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                        = 60
      created_before             = "2021-08-20"
      with_state                 = "LIVE"
      matches_storage_class      = ["STANDARD"]
      num_newer_versions         = 10
      custom_time_before         = "1970-01-01"
      days_since_custom_time     = 1
      days_since_noncurrent_time = 1
      noncurrent_time_before     = "1970-01-01"
    }
  }]
  versioning_enabled = true

  website = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors = [{
    origin          = ["https://mineiros.io"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]

  encryption_default_kms_key_name = "unit-complete"

  logging = {
    log_bucket        = "example-log-bucket"
    log_object_prefix = "gcs-log"
  }

  retention_policy = {
    is_locked        = false
    retention_period = 200000
  }

  labels = {
    label0 = "foo"
    label1 = "bar"
  }

  policy_bindings = [{
    role    = "roles/storage.admin"
    members = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  module_depends_on = ["nothing"]
}

module "testIAM" {
  source = "../.."

  name = "unit-complete-iam"

  force_destroy = true

  iam = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:example-project"]
    }
  ]
}

module "testPolicy" {
  source = "../.."

  name = "unit-complete-policy"

  force_destroy = true

  policy_bindings = [
    {
      role    = "roles/storage.objectViewer"
      members = ["projectOwner:example-project"]
    }
  ]
}
