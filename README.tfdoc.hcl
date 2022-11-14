header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-storage-bucket"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-storage-bucket/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-storage-bucket/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-storage-bucket.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-storage-bucket/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-storage-bucket"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Cloud Storage](https://cloud.google.com/storage) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following terraform resources

      - `google_storage_bucket`

      and supports additional features of the following modules:

      - [terraform-google-storage-bucket-iam](https://github.com/mineiros-io/terraform-google-storage-bucket-iam)
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-storage-bucket" {
        source = "github.com/mineiros-io/terraform-google-storage-bucket?ref=v0.0.6"

        name = "my-bucket"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          Name of the bucket.
        END
      }

      variable "force_destroy" {
        type        = bool
        default     = false
        description = <<-END
          When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run.
        END
      }

      variable "location" {
        type        = string
        default     = "US"
        description = <<-END
          The GCS location.
        END
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
        END
      }

      variable "storage_class" {
        type        = string
        default     = "STANDARD"
        description = <<-END
          The Storage Class of the new bucket. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.
        END
      }

      variable "lifecycle_rules" {
        type           = list(lifecycle_rule)
        description    = <<-END
          A set of identities that will be able to create objects inside the bucket.
        END
        readme_example = <<-END
          lifecycle_rules = [{
            action = {
              type          = "SetStorageClass"
              storage_class = "NEARLINE"
            }
            condition = {
              age                        = 60
              created_before             = "2018-08-20"
              with_state                 = "LIVE"
              matches_storage_class      = ["REGIONAL"]
              num_newer_versions         = 10
              custom_time_before         = "1970-01-01"
              days_since_custom_time     = 1
              days_since_noncurrent_time = 1
              noncurrent_time_before     = "1970-01-01"
            }
          }]
        END

        attribute "action" {
          required    = true
          type        = list(action)
          description = <<-END
            The Lifecycle Rule's action configuration.
          END

          attribute "type" {
            type        = string
            description = <<-END
              The type of the action of this Lifecycle Rule. Supported values include: `Delete` and `SetStorageClass`.
            END
          }

          attribute "storage_class" {
            type        = string
            description = <<-END
              The target Storage Class of objects affected by this Lifecycle Rule. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.
            END
          }
        }

        attribute "condition" {
          required    = true
          type        = list(condition)
          description = <<-END
            The Lifecycle Rule's action configuration.
          END

          attribute "age" {
            type        = number
            description = <<-END
              Minimum age of an object in days to satisfy this condition.
            END
          }

          attribute "created_before" {
            type        = string
            description = <<-END
              A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.
            END
          }

          attribute "with_state" {
            type        = string
            description = <<-END
              Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: `LIVE`, `ARCHIVED`, `ANY`.
            END
          }

          attribute "matches_storage_class" {
            type        = string
            description = <<-END
              Storage Class of objects to satisfy this condition. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`, `DURABLE_REDUCED_AVAILABILITY`.
            END
          }

          attribute "num_newer_versions" {
            type        = number
            description = <<-END
              Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
            END
          }

          attribute "custom_time_before" {
            type        = string
            description = <<-END
              A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
            END
          }

          attribute "days_since_custom_time" {
            type        = number
            description = <<-END
              Days since the date set in the `customTime` metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the `customTime`.
            END
          }

          attribute "days_since_noncurrent_time" {
            type        = number
            description = <<-END
              Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.
            END
          }

          attribute "noncurrent_time_before" {
            type        = string
            description = <<-END
              Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.
            END
          }
        }
      }

      variable "versioning_enabled" {
        type        = bool
        default     = false
        description = <<-END
          Whether versioning should be enabled.
        END
      }

      variable "website" {
        type           = object(website)
        description    = <<-END
          Configuration if the bucket acts as a website.
        END
        readme_example = <<-END
          website = {
            main_page_suffix = "index.html"
            not_found_page   = "404.html"
          }
        END

        attribute "main_page_suffix" {
          type        = string
          description = <<-END
            Behaves as the bucket's directory index where missing objects are treated as potential directories.
          END
        }

        attribute "not_found_page" {
          type        = string
          description = <<-END
            The custom object to return when a requested resource is not found.
          END
        }
      }

      variable "cors" {
        type           = list(cors)
        description    = <<-END
          The bucket's Cross-Origin Resource Sharing (CORS) configuration.
        END
        readme_example = <<-END
          cors = [{
            origin          = ["http://image-store.com"]
            method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
            response_header = ["*"]
            max_age_seconds = 3600
          }]
        END

        attribute "origin" {
          type        = set(string)
          description = <<-END
            The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
          END
        }

        attribute "method" {
          type        = set(string)
          description = <<-END
            The list of HTTP methods on which to include CORS response headers, (`GET`, `OPTIONS`, `POST`, etc) Note: `"*"` is permitted in the list of methods, and means `any method`.
          END
        }

        attribute "response_header" {
          type        = set(string)
          description = <<-END
            The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
          END
        }

        attribute "max_age_seconds" {
          type        = set(string)
          description = <<-END
            The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
          END
        }
      }

      variable "encryption_default_kms_key_name" {
        type        = string
        description = <<-END
          The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified. You must pay attention to whether the crypto key is available in the location that this bucket is created in.
        END
      }

      variable "logging" {
        type           = object(logging)
        description    = <<-END
          The bucket's Access & Storage Logs configuration.
        END
        readme_example = <<-END
          logging = {
            log_bucket        = "example-log-bucket"
            log_object_prefix = "gcs-log"
          }
        END

        attribute "log_bucket" {
          required    = true
          type        = string
          description = <<-END
            The bucket that will receive log objects.
          END
        }

        attribute "log_object_prefix" {
          type        = string
          description = <<-END
            The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name.
          END
        }
      }

      variable "retention_policy" {
        type           = object(retention_policy)
        description    = <<-END
          Configuration of the bucket's data retention policy for how long objects in the bucket should be retained.
        END
        readme_example = <<-END
          retention_policy = {
            is_locked        = false
            retention_period = 200000
          }
        END

        attribute "is_locked" {
          type        = bool
          default     = false
          description = <<-END
            If set to `true`, the bucket will be locked and permanently restrict edits to the bucket's retention policy. Caution: Locking a bucket is an irreversible action
          END
        }

        attribute "retention_period" {
          required    = true
          type        = number
          description = <<-END
            The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than `2,147,483,647` second.
          END
        }
      }

      variable "labels" {
        type        = map(string)
        description = <<-END
          A map of key/value label pairs to assign to the bucket.
        END
      }

      variable "requester_pays" {
        type        = bool
        default     = false
        description = <<-END
          Enables Requester Pays on a storage bucket.
        END
      }

      variable "uniform_bucket_level_access" {
        type        = bool
        default     = true
        description = <<-END
          Enables Uniform bucket-level access access to a bucket.
        END
      }

      variable "object_creators" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of identities that will be able to create objects inside the bucket.
        END
      }

      variable "object_viewers" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of identities that will be able to view objects inside the bucket.
        END
      }

      variable "legacy_readers" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of identities that get the legacy bucket and object reader role assigned.
        END
      }

      variable "legacy_writers" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of identities that get the legacy bucket and object writer role assigned.
        END
      }

      variable "object_admins" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of identities that will be able to administrate objects inside the bucket.
        END
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "iam" {
        type           = list(iam)
        description    = <<-END
          A list of IAM access.
        END
        readme_example = <<-END
          iam = [{
            role          = "roles/storage.admin"
            members       = ["user:member@example.com"]
            authoritative = false
          }]
        END

        attribute "members" {
          type        = set(string)
          default     = []
          description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`
            - `computed:{identifier}`: An existing key from `var.computed_members_map`.
          END
        }

        attribute "role" {
          type        = string
          description = <<-END
            The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        attribute "roles" {
          type        = list(string)
          description = <<-END
            The set of roles that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        attribute "authoritative" {
          type        = bool
          default     = true
          description = <<-END
            Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
          END
        }
      }

      variable "computed_members_map" {
        type        = map(string)
        description = <<-END
          A map of members to replace in `members` of various IAM settings to handle terraform computed values.
        END
        default     = {}
      }

      variable "policy_bindings" {
        type           = list(policy_binding)
        description    = <<-END
          A list of IAM policy bindings.
        END
        readme_example = <<-END
          policy_bindings = [{
            role      = "roles/storage.admin"
            members   = ["user:member@example.com"]
            condition = {
              title       = "expires_after_2021_12_31"
              description = "Expiring at midnight of 2021-12-31"
              expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
            }
          }]
        END

        attribute "role" {
          required    = true
          type        = string
          description = <<-END
            The role that should be applied.
          END
        }

        attribute "members" {
          type        = set(string)
          default     = var.members
          description = <<-END
            Identities that will be granted the privilege in `role`.
          END
        }

        attribute "condition" {
          type           = object(condition)
          description    = <<-END
            An IAM Condition for a given binding.
          END
          readme_example = <<-END
            condition = {
              expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
              title      = "expires_after_2021_12_31"
            }
          END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
              Textual representation of an expression in Common Expression Language syntax.
            END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
              A title for the expression, i.e. a short string describing its purpose.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
              An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
            END
          }
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        readme_example = <<-END
          module_depends_on = [
            google_network.network
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "bucket" {
      type        = object(bucket)
      description = <<-END
        All attributes of the created `google_storage_bucket` resource.
      END
    }

    output "iam" {
      type        = list(iam)
      description = <<-END
        The `iam` resource objects that define the access to the GCS bucket.
      END
    }

    output "policy_binding" {
      type        = object(policy_binding)
      description = <<-END
        All attributes of the created policy_bindings mineiros-io/storage-bucket-iam/google module.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - https://cloud.google.com/storage
      END
    }

    section {
      title   = "Terraform Google Provider Documentation:"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-storage-bucket"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-storage-bucket.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/CONTRIBUTING.md"
  }
}
