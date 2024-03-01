resource "google_storage_bucket" "bucket" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  name                        = var.name
  force_destroy               = var.force_destroy
  location                    = var.location
  project                     = var.project
  storage_class               = var.storage_class
  labels                      = var.labels
  requester_pays              = var.requester_pays
  uniform_bucket_level_access = var.uniform_bucket_level_access
  default_event_based_hold    = var.default_event_based_hold
  enable_object_retention     = var.enable_object_retention
  public_access_prevention    = try(var.public_access_prevention, "inherited")
  rpo                         = var.rpo

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.type == "SetStorageClass" ? lifecycle_rule.value.action.storage_class : null
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        no_age                     = try(lifecycle_rule.value.condition.no_age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, null)
        matches_prefix             = try(lifecycle_rule.value.condition.matches_prefix, null)
        matches_suffix             = try(lifecycle_rule.value.condition.matches_suffix, null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)
        days_since_custom_time     = try(lifecycle_rule.value.condition.days_since_custom_time, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)
      }
    }
  }

  dynamic "versioning" {
    for_each = var.versioning_enabled != null ? ["versioning"] : []

    content {
      enabled = var.versioning_enabled
    }
  }

  dynamic "autoclass" {
    for_each = var.autoclass != null ? ["autoclass"] : []

    content {
      enabled                = var.autoclass.enabled
      terminal_storage_class = var.autoclass.terminal_storage_class
    }
  }

  dynamic "website" {
    for_each = var.website != null ? ["website"] : []

    content {
      main_page_suffix = try(var.website.main_page_suffix, null)
      not_found_page   = try(var.website.not_found_page, null)
    }
  }

  dynamic "cors" {
    for_each = var.cors

    content {
      origin          = try(cors.value.origin, null)
      method          = try(cors.value.method, null)
      response_header = try(cors.value.response_header, null)
      max_age_seconds = try(cors.value.max_age_seconds, null)
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? ["retention_policy"] : []

    content {
      retention_period = var.retention_policy.retention_period
      is_locked        = try(var.retention_policy.is_locked, null)
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? ["logging"] : []

    content {
      log_bucket        = var.logging.log_bucket
      log_object_prefix = var.logging.log_object_prefix
    }
  }

  dynamic "encryption" {
    for_each = var.encryption_default_kms_key_name != null ? ["encryption"] : []

    content {
      default_kms_key_name = var.encryption_default_kms_key_name
    }
  }

  dynamic "custom_placement_config" {
    for_each = var.custom_placement_config != null ? ["custom_placement_config"] : []

    content {
      data_locations = var.custom_placement_config.data_locations
    }
  }
}

resource "google_storage_bucket_iam_member" "viewer" {
  for_each = var.module_enabled ? toset(var.object_viewers) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.objectViewer"
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "admin" {
  for_each = var.module_enabled ? toset(var.object_admins) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.objectAdmin"
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "creator" {
  for_each = var.module_enabled ? toset(var.object_creators) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.objectCreator"
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "legacy-bucket-reader" {
  for_each = var.module_enabled ? toset(var.legacy_readers) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.legacyBucketReader"
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "legacy-object-reader" {
  for_each = var.module_enabled ? toset(var.legacy_readers) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.legacyObjectReader"
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "legacy-bucket-writer" {
  for_each = var.module_enabled ? toset(var.legacy_writers) : toset([])

  bucket = google_storage_bucket.bucket[0].id
  role   = "roles/storage.legacyBucketWriter"
  member = each.value

  depends_on = [var.module_depends_on]
}
