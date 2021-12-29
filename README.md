[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-storage-bucket

A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
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

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.

  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`name`**: **_(Required `string`)_**

  Name of the bucket.

- **`force_destroy`**: _(Optional `bool`)_

  When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run.

  Default is `false`.

- **`location`**: _(Optional `string`)_

  The GCS location.

  Default is `US`.

- **`project`**: _(Optional `string`)_

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- **`storage_class`**: _(Optional `string`)_

  The Storage Class of the new bucket. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.

  Default is `STANDARD`.

- **`lifecycle_rules`**: _(Optional `list(lifecycle_rules)`)_

  A set of identities that will be able to create objects inside the bucket.

  Example

  ```hcl
  lifecycle_rules = [{
    action = [{
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }]
    condition = [{
      age                   = 60
      created_before        = "2018-08-20"
      with_state            = "live"
      matches_storage_class = ["REGIONAL"]
      num_newer_versions    = 10
    }]
  }]
  ```

  Each `lifecycle_rule` object can have the following fields:

  - **`action`**: **_(Required `list(action)`)_**

    The Lifecycle Rule's action configuration.

    Each `action` object can have the following fields:

    - **`type`**: _(Optional `string`)_

      The type of the action of this Lifecycle Rule. Supported values include: `Delete` and `SetStorageClass`.

    - **`storage_class`**: _(Required if action type is `SetStorageClass` `string`)_

      The target Storage Class of objects affected by this Lifecycle Rule. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.

  - **`condition`**: **_(Required `list(condition)`)_**

    The Lifecycle Rule's action configuration.

    Each `condition` object can have the following fields:

    - **`age`**: _(Optional `number`)_

      Minimum age of an object in days to satisfy this condition.

    - **`created_before`**: _(Optional `string`)_

      A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.

    - **`with_state`**: _(Optional `string`)_

      Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: `LIVE`, `ARCHIVED`, `ANY`.

    - **`matches_storage_class`**: _(Optional `string`)_

      Storage Class of objects to satisfy this condition. Supported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`, `DURABLE_REDUCED_AVAILABILITY`.

    - **`num_newer_versions`**: _(Optional `number`)_

      Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.

    - **`custom_time_before`**: _(Optional `string`)_

      A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.

    - **`days_since_custom_time`**: _(Optional `number`)_

      Days since the date set in the `customTime` metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the `customTime`.

    - **`days_since_noncurrent_time`**: _(Optional `string`)_

      Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.

    - **`noncurrent_time_before`**: _(Optional `string`)_

      Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.

- **`versioning_enabled`**: _(Optional `bool`)_

  Whether versioning should be enabled.

  Default is `false`.

- **`website`**: _(Optional `set(string)`)_

  Configuration if the bucket acts as a website.

  Example

  ```hcl
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  ```

  Each `website` object can have the following fields:

  - **`main_page_suffix`**: _(Optional `string`)_

    Behaves as the bucket's directory index where missing objects are treated as potential directories.

  - **`not_found_page`**: _(Optional `string`)_

    The custom object to return when a requested resource is not found.

- **`cors`**: _(Optional `list(cors)`)_

  The bucket's Cross-Origin Resource Sharing (CORS) configuration.

  Example

  ```hcl
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  ```
  
  Each `cors` object can have the following fields:

  - **`origin`**: _(Optional `set(string)`)_

    The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".

  - **`method`**: _(Optional `set(string)`)_

    The list of HTTP methods on which to include CORS response headers, (`GET`, `OPTIONS`, `POST`, etc) Note: `"*"` is permitted in the list of methods, and means `any method`.

  - **`response_header`**: _(Optional `set(string)`)_

    The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.

  - **`max_age_seconds`**: _(Optional `set(string)`)_

    The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.

- **`encryption_default_kms_key_name`**: _(Optional `bool`)_

  The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified. You must pay attention to whether the crypto key is available in the location that this bucket is created in.

- **`logging`**: _(Optional `list(cors)`)_

  The bucket's Access & Storage Logs configuration.

  Example

  ```hcl
  logging {
    log_bucket        = "example-log-bucket"
    log_object_prefix = "gcs-log"
  }
  ```

  Each `logging` object can have the following fields:

  - **`log_bucket`**: **_(Required `string`)_**

    The bucket that will receive log objects.

  - **`log_object_prefix`**: _(Optional `string`)_

    The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name.

- **`retention_policy`**: _(Optional `set(string)`)_

  Configuration of the bucket's data retention policy for how long objects in the bucket should be retained.

  Example

  ```hcl
  retention_policy {
    is_locked        = false
    retention_period = 200000
  }
  ```

  Each `retention_policy` object can have the following fields:

  - **`is_locked`**: _(Optional `bool`)_

    If set to `true`, the bucket will be locked and permanently restrict edits to the bucket's retention policy. Caution: Locking a bucket is an irreversible action

    Default is `false`

  - **`retention_period`**: **_(Required `number`)_**

    The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than `2,147,483,647` second.

- **`labels`**: _(Optional `map(string)`)_

  A map of key/value label pairs to assign to the bucket.

- **`requester_pays`**: _(Optional `bool`)_

  Enables Requester Pays on a storage bucket.

  Default is `false`.

- **`uniform_bucket_level_access`**: _(Optional `bool`)_

  Enables Uniform bucket-level access access to a bucket.

  Default is `true`.

- **`object_creators`**: _(Optional `set(string)`)_

  A set of identities that will be able to create objects inside the bucket.

  Default is `[]`.

- **`object_viewers`**: _(Optional `set(string)`)_

  A set of identities that will be able to view objects inside the bucket.

  Default is `[]`.

- **`legacy_readers`**: _(Optional `set(string)`)_

  A set of identities that get the legacy bucket and object reader role assigned.

  Default is `[]`.

- **`legacy_writers`**: _(Optional `set(string)`)_

  A set of identities that get the legacy bucket and object writer role assigned.

  Default is `[]`.

- **`object_admins`**: _(Optional `set(string)`)_

  A set of identities that will be able to administrate objects inside the bucket.

  Default is `[]`.

#### Extended Resource Configuration

- **`iam`**: _(Optional `list(iam)`)_

  A list of IAM access.

  Example

  ```hcl
  iam = [{
    role          = "roles/storage.admin"
    members       = ["user:member@example.com"]
    authoritative = false
  }]
  ```

  Each `iam` object accepts the following fields:

  - **`members`**: _(Optional `set(string)`)_

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

  - **`role`**: _(Optional `string`)_

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - **`authoritative`**: _(Optional `bool`)_

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- **`policy_bindings`**: _(Optional `list(policy_bindings)`)_

  A list of IAM policy bindings.

  Example

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

  Each `policy_bindings` object accepts the following fields:

  - **`role`**: **_(Required `string`)_**

    The role that should be applied.

  - **`members`**: _(Optional `set(string)`)_

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - **`condition`**: _(Optional `object(condition)`)_

    An IAM Condition for a given binding.

    Example

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    A `condition` object accepts the following fields:

    - **`expression`**: **_(Required `string`)_**

      Textual representation of an expression in Common Expression Language syntax.

    - **`title`**: **_(Required `string`)_**

      A title for the expression, i.e. a short string describing its purpose.

    - **`description`**: _(Optional `string`)_

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`bucket`**

  All attributes of the created `google_storage_bucket` resource.

- **`iam`**

  The `iam` resource objects that define the access to the GCS bucket.

<!-- all outputs in outputs.tf-->

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

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]

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
