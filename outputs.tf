# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

# remap iam to reduce one level of access (iam[]. instead of iam[].iam.)
output "iam" {
  description = "The iam resource objects that define access to the GCS bucket."
  value       = { for key, iam in module.iam : key => iam.iam }
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "bucket" {
  description = "All attributes of the created `google_storage_bucket` resource."
  value       = try(google_storage_bucket.bucket[0], null)
}

output "policy_binding" {
  description = "All attributes of the created policy_bindings mineiros-io/storage-bucket-iam/google module."
  value       = module.policy_bindings
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
