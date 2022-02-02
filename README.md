[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-storage-bucket)

[![Build Status](https://github.com/mineiros-io/terraform-google-storage-bucket/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-storage-bucket/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-storage-bucket.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-storage-bucket/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-storage-bucket

A [Terraform](https://www.terraform.io) module to create a [Google Cloud Storage](https://cloud.google.com/storage) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation:](#terraform-google-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following terraform resources

- `google_artifact_registry_repository`

and supports additional features of the following modules:

- [terraform-google-storage-bucket-iam](https://github.com/mineiros-io/terraform-google-storage-bucket-iam)

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-storage-bucket" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket?ref=v0.1.0"

  repository_id = "my-repository"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  Name of the bucket.

- [**`force_destroy`**](#var-force_destroy): *(Optional `bool`)*<a name="var-force_destroy"></a>

  When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run.

  Default is `false`.

- [**`location`**](#var-location): *(Optional `string`)*<a name="var-location"></a>

  The GCS location.

  Default is `"US"`.

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- [**`storage_class`**](#var-storage_class): *(Optional `string`)*<a name="var-storage_class"></a>

  The Storage Class of the new bucket. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.

  Default is `"STANDARD"`.

- [**`lifecycle_rules`**](#var-lifecycle_rules): *(Optional `list(lifecycle_rule)`)*<a name="var-lifecycle_rules"></a>

  A set of identities that will be able to create objects inside the bucket.

  Example:

  ```hcl
  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                   = 60
      created_before        = "2018-08-20"
      with_state            = "LIVE"
      matches_storage_class = ["REGIONAL"]
      num_newer_versions    = 10
    }
  }]
  ```

  Each `lifecycle_rule` object in the list accepts the following attributes:

  - [**`action`**](#attr-lifecycle_rules-action): *(**Required** `list(action)`)*<a name="attr-lifecycle_rules-action"></a>

    The Lifecycle Rule's action configuration.

    Each `action` object in the list accepts the following attributes:

    - [**`type`**](#attr-lifecycle_rules-action-type): *(Optional `string`)*<a name="attr-lifecycle_rules-action-type"></a>

      The type of the action of this Lifecycle Rule. Supported values include: `Delete` and `SetStorageClass`.

    - [**`storage_class`**](#attr-lifecycle_rules-action-storage_class): *(Optional `string`)*<a name="attr-lifecycle_rules-action-storage_class"></a>

      The target Storage Class of objects affected by this Lifecycle Rule. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.

  - [**`condition`**](#attr-lifecycle_rules-condition): *(**Required** `list(condition)`)*<a name="attr-lifecycle_rules-condition"></a>

    The Lifecycle Rule's action configuration.

    Each `condition` object in the list accepts the following attributes:

    - [**`age`**](#attr-lifecycle_rules-condition-age): *(Optional `number`)*<a name="attr-lifecycle_rules-condition-age"></a>

      Minimum age of an object in days to satisfy this condition.

    - [**`created_before`**](#attr-lifecycle_rules-condition-created_before): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-created_before"></a>

      A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.

    - [**`with_state`**](#attr-lifecycle_rules-condition-with_state): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-with_state"></a>

      Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: `LIVE`, `ARCHIVED`, `ANY`.

    - [**`matches_storage_class`**](#attr-lifecycle_rules-condition-matches_storage_class): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-matches_storage_class"></a>

      Storage Class of objects to satisfy this condition. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`, `DURABLE_REDUCED_AVAILABILITY`.

    - [**`num_newer_versions`**](#attr-lifecycle_rules-condition-num_newer_versions): *(Optional `number`)*<a name="attr-lifecycle_rules-condition-num_newer_versions"></a>

      Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.

    - [**`custom_time_before`**](#attr-lifecycle_rules-condition-custom_time_before): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-custom_time_before"></a>

      A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.

    - [**`days_since_custom_time`**](#attr-lifecycle_rules-condition-days_since_custom_time): *(Optional `number`)*<a name="attr-lifecycle_rules-condition-days_since_custom_time"></a>

      Days since the date set in the `customTime` metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the `customTime`.

    - [**`days_since_noncurrent_time`**](#attr-lifecycle_rules-condition-days_since_noncurrent_time): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-days_since_noncurrent_time"></a>

      Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.

    - [**`noncurrent_time_before`**](#attr-lifecycle_rules-condition-noncurrent_time_before): *(Optional `string`)*<a name="attr-lifecycle_rules-condition-noncurrent_time_before"></a>

      Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.

- [**`versioning_enabled`**](#var-versioning_enabled): *(Optional `bool`)*<a name="var-versioning_enabled"></a>

  Whether versioning should be enabled.

  Default is `false`.

- [**`website`**](#var-website): *(Optional `object(website)`)*<a name="var-website"></a>

  Configuration if the bucket acts as a website.

  Example:

  ```hcl
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  ```

  The `website` object accepts the following attributes:

  - [**`main_page_suffix`**](#attr-website-main_page_suffix): *(Optional `string`)*<a name="attr-website-main_page_suffix"></a>

    Behaves as the bucket's directory index where missing objects are treated as potential directories.

  - [**`not_found_page`**](#attr-website-not_found_page): *(Optional `string`)*<a name="attr-website-not_found_page"></a>

    The custom object to return when a requested resource is not found.

- [**`cors`**](#var-cors): *(Optional `list(cors)`)*<a name="var-cors"></a>

  The bucket's Cross-Origin Resource Sharing (CORS) configuration.

  Example:

  ```hcl
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  ```

  Each `cors` object in the list accepts the following attributes:

  - [**`origin`**](#attr-cors-origin): *(Optional `set(string)`)*<a name="attr-cors-origin"></a>

    The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".

  - [**`method`**](#attr-cors-method): *(Optional `set(string)`)*<a name="attr-cors-method"></a>

    The list of HTTP methods on which to include CORS response headers, (`GET`, `OPTIONS`, `POST`, etc) Note: `"*"` is permitted in the list of methods, and means `any method`.

  - [**`response_header`**](#attr-cors-response_header): *(Optional `set(string)`)*<a name="attr-cors-response_header"></a>

    The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.

  - [**`max_age_seconds`**](#attr-cors-max_age_seconds): *(Optional `set(string)`)*<a name="attr-cors-max_age_seconds"></a>

    The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.

- [**`encryption_default_kms_key_name`**](#var-encryption_default_kms_key_name): *(Optional `string`)*<a name="var-encryption_default_kms_key_name"></a>

  The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified. You must pay attention to whether the crypto key is available in the location that this bucket is created in.

- [**`logging`**](#var-logging): *(Optional `object(logging)`)*<a name="var-logging"></a>

  The bucket's Access & Storage Logs configuration.

  Example:

  ```hcl
  logging {
    log_bucket        = "example-log-bucket"
    log_object_prefix = "gcs-log"
  }
  ```

  The `logging` object accepts the following attributes:

  - [**`log_bucket`**](#attr-logging-log_bucket): *(**Required** `string`)*<a name="attr-logging-log_bucket"></a>

    The bucket that will receive log objects.

  - [**`log_object_prefix`**](#attr-logging-log_object_prefix): *(Optional `string`)*<a name="attr-logging-log_object_prefix"></a>

    The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name.

- [**`retention_policy`**](#var-retention_policy): *(Optional `object(retention_policy)`)*<a name="var-retention_policy"></a>

  Configuration of the bucket's data retention policy for how long objects in the bucket should be retained.

  Example:

  ```hcl
  retention_policy {
    is_locked        = false
    retention_period = 200000
  }
  ```

  The `retention_policy` object accepts the following attributes:

  - [**`is_locked`**](#attr-retention_policy-is_locked): *(Optional `bool`)*<a name="attr-retention_policy-is_locked"></a>

    If set to `true`, the bucket will be locked and permanently restrict edits to the bucket's retention policy. Caution: Locking a bucket is an irreversible action

    Default is `false`.

  - [**`retention_period`**](#attr-retention_policy-retention_period): *(**Required** `number`)*<a name="attr-retention_policy-retention_period"></a>

    The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than `2,147,483,647` second.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  A map of key/value label pairs to assign to the bucket.

- [**`requester_pays`**](#var-requester_pays): *(Optional `bool`)*<a name="var-requester_pays"></a>

  Enables Requester Pays on a storage bucket.

  Default is `false`.

- [**`uniform_bucket_level_access`**](#var-uniform_bucket_level_access): *(Optional `bool`)*<a name="var-uniform_bucket_level_access"></a>

  Enables Uniform bucket-level access access to a bucket.

  Default is `true`.

- [**`object_creators`**](#var-object_creators): *(Optional `set(string)`)*<a name="var-object_creators"></a>

  A set of identities that will be able to create objects inside the bucket.

  Default is `[]`.

- [**`object_viewers`**](#var-object_viewers): *(Optional `set(string)`)*<a name="var-object_viewers"></a>

  A set of identities that will be able to view objects inside the bucket.

  Default is `[]`.

- [**`legacy_readers`**](#var-legacy_readers): *(Optional `set(string)`)*<a name="var-legacy_readers"></a>

  A set of identities that get the legacy bucket and object reader role assigned.

  Default is `[]`.

- [**`legacy_writers`**](#var-legacy_writers): *(Optional `set(string)`)*<a name="var-legacy_writers"></a>

  A set of identities that get the legacy bucket and object writer role assigned.

  Default is `[]`.

- [**`object_admins`**](#var-object_admins): *(Optional `set(string)`)*<a name="var-object_admins"></a>

  A set of identities that will be able to administrate objects inside the bucket.

  Default is `[]`.

### Extended Resource Configuration

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access.

  Example:

  ```hcl
  iam = [{
    role          = "roles/storage.admin"
    members       = ["user:member@example.com"]
    authoritative = false
  }]
  ```

  Each `iam` object in the list accepts the following attributes:

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

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

    Default is `[]`.

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- [**`policy_bindings`**](#var-policy_bindings): *(Optional `list(policy_binding)`)*<a name="var-policy_bindings"></a>

  A list of IAM policy bindings.

  Example:

  ```hcl
  policy_bindings = [{
    role      = "roles/storage.admin"
    members   = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]
  ```

  Each `policy_binding` object in the list accepts the following attributes:

  - [**`role`**](#attr-policy_bindings-role): *(**Required** `string`)*<a name="attr-policy_bindings-role"></a>

    The role that should be applied.

  - [**`members`**](#attr-policy_bindings-members): *(Optional `set(string)`)*<a name="attr-policy_bindings-members"></a>

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - [**`condition`**](#attr-policy_bindings-condition): *(Optional `object(condition)`)*<a name="attr-policy_bindings-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    The `condition` object accepts the following attributes:

    - [**`expression`**](#attr-policy_bindings-condition-expression): *(**Required** `string`)*<a name="attr-policy_bindings-condition-expression"></a>

      Textual representation of an expression in Common Expression Language syntax.

    - [**`title`**](#attr-policy_bindings-condition-title): *(**Required** `string`)*<a name="attr-policy_bindings-condition-title"></a>

      A title for the expression, i.e. a short string describing its purpose.

    - [**`description`**](#attr-policy_bindings-condition-description): *(Optional `string`)*<a name="attr-policy_bindings-condition-description"></a>

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`bucket`**](#output-bucket): *(`object(bucket)`)*<a name="output-bucket"></a>

  All attributes of the created `google_storage_bucket` resource.

- [**`iam`**](#output-iam): *(`list(iam)`)*<a name="output-iam"></a>

  The `iam` resource objects that define the access to the GCS bucket.

## External Documentation

### Google Documentation

- https://cloud.google.com/storage

### Terraform Google Provider Documentation:

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-storage-bucket
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-storage-bucket/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-storage-bucket.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-storage-bucket/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-storage-bucket/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-storage-bucket/issues
[license]: https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-storage-bucket/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-storage-bucket/blob/main/CONTRIBUTING.md
