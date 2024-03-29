# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "(Required) Name of the bucket."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "force_destroy" {
  description = "(Optional) When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  type        = bool
  default     = false
}

variable "location" {
  description = "(Optional) The GCS location."
  type        = string
  default     = "US"
}

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "storage_class" {
  description = "(Optional) The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "The value must only be one of these valid values: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "lifecycle_rules" {
  description = "(Optional) The bucket's Lifecycle Rules configuration."
  type        = any
  default     = []
}

variable "versioning_enabled" {
  description = "(Optional) Whether versioning should be enabled."
  type        = bool
  default     = false
}

variable "rpo" {
  description = "(Optional) The recovery point objective for cross-region replication of the bucket. Applicable only for dual and multi-region buckets."
  type        = string
  default     = null
}

variable "default_event_based_hold" {
  description = "(Optional) Whether or not to automatically apply an eventBasedHold to new objects added to the bucket."
  type        = bool
  default     = false
}

variable "enable_object_retention" {
  description = "(Optional) Enables object retention on a storage bucket."
  type        = bool
  default     = false
}

variable "public_access_prevention" {
  description = "Prevents public access to a bucket."
  type        = string
  default     = "inherited"
}

variable "website" {
  description = "(Optional) Configuration if the bucket acts as a website."
  type        = any
  default     = null
}

variable "autoclass" {
  description = "(Optional) Autoclass configuration"
  type        = any
  default     = null
}

variable "custom_placement_config" {
  description = "(Optional) The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated a single or multi-region, the parameters are empty."
  type        = any
  default     = null
}

variable "cors" {
  description = "(Optional) The bucket's Cross-Origin Resource Sharing (CORS) configuration."
  type        = any
  default     = []
}

variable "encryption_default_kms_key_name" {
  description = "(Optional) The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified. You must pay attention to whether the crypto key is available in the location that this bucket is created in."
  type        = string
  default     = null
}

variable "logging" {
  description = "(Optional) The bucket's Access & Storage Logs configuration."
  type        = any
  default     = null
}

variable "retention_policy" {
  description = "(Optional) Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type        = any
  default     = null
}

variable "labels" {
  description = "(Optional) A map of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "requester_pays" {
  description = "(Optional) Enables Requester Pays on a storage bucket."
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "(Optional) Enables Uniform bucket-level access access to a bucket."
  type        = bool
  default     = true
}

variable "object_creators" {
  type        = set(string)
  description = "(Optional) A set of identities that will be able to create objects inside the bucket."
  default     = []
}

variable "object_viewers" {
  type        = set(string)
  description = "(Optional) A set of identities that will be able to view objects inside the bucket."
  default     = []
}

variable "legacy_readers" {
  type        = set(string)
  description = "(Optional) A set of identities that get the legacy bucket and object reader role assigned."
  default     = []
}

variable "legacy_writers" {
  type        = set(string)
  description = "(Optional) A set of identities that get the legacy bucket and object writer role assigned."
  default     = []
}

variable "object_admins" {
  type        = set(string)
  description = "(Optional) A set of identities that will be able to administrate objects inside the bucket."
  default     = []
}

## IAM

variable "iam" {
  description = "(Optional) A list of IAM access."
  type        = any
  default     = []

  # validate required keys in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setintersection(keys(x), ["role", "roles", "members"])) == 2])
    error_message = "Each object in var.iam must specify a role(s) and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setsubtract(keys(x), ["role", "roles", "members", "authoritative", "condition"])) == 0])
    error_message = "Each object in var.iam does only support role, roles, members, authoritative and condition attributes."
  }
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings."
  type        = any
  default     = null

  # validate required keys in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setintersection(keys(x), ["role", "members"])) == 2])
    error_message = "Each object in var.policy_bindings must specify a role and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setsubtract(keys(x), ["role", "members", "condition"])) == 0])
    error_message = "Each object in var.policy_bindings does only support role, members and condition attributes."
  }
}

variable "computed_members_map" {
  type        = map(string)
  description = "(Optional) A map of members to replace in 'members' to handle terraform computed values. Will be ignored when policy bindings are used."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.computed_members_map : can(regex("^(allUsers|allAuthenticatedUsers|(user|serviceAccount|group|domain|projectOwner|projectEditor|projectViewer):)", v))])
    error_message = "The value must be a non-empty list of strings where each entry is a valid principal type identified with `user:`, `serviceAccount:`, `group:`, `domain:`, `projectOwner:`, `projectEditor:` or `projectViewer:`."
  }
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
