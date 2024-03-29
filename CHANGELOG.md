# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0]

### Changed

- BREAKING CHANGE: Allow `iam.condition` to create the same terraform id index as an unset `iam.condition`.
  This is breaking indexing and will recreate the resource unless `iam._key` is set to the previous value.

## [0.1.0]

### Added

- Add support for variable `computed_members_map`
- Add support for `iam.condition`
- Add support for `iam.roles`

### Removed

- BREAKING CHANGE: Remove support for Terraform before v1.0
- BREAKING CHANGE: Remove support for Terraform Google Provider before v4.0
- BREAKING CHANEG: Remove output `module_enabled`

## [0.0.6]

### Breaking

- Removed support for Terraform `< 1.1.2`

### Fixed

- Fix a bug that is based on terraform type system issue

## [0.0.5]

### Added

- Add unit tests

### Fixed

- Fix attributes in nested `terraform-google-storage-bucket-iam` module to not fail when `module_enabled = false`

## [0.0.4]

### Added

- Support for provider 4.x

## [0.0.3]

### Added

- Add support for IAM via mineiros-io/storage-bucket-iam/google module

## [0.0.2]

### Added

- Add missing outputs.tf

## [0.0.1]

### Added

- Initial Implementation

[unreleased]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.6...v0.1.0
[0.0.6]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-google-storage-bucket/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-storage-bucket/releases/tag/v0.0.1
