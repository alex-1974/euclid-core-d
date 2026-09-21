# Changelog

All notable changes to `euclid-core-d` are documented here.

The project follows Semantic Versioning for published releases.

## [Unreleased]

### Changed

- Promoted the initial local architecture probe into an independently versioned
  shared-contract package for `geo-d` and `geo3-d`.
- Defined the package scope as declaration-identity support rather than a third
  consumer-facing geometry API.
- Added release, contribution, security, licensing, and CI project metadata.

## [0.1.0] - Unreleased

Initial public development release.

### Added

- Shared scalar-domain contract `isGeoScalar`.
- Shared metric result policy `MetricScalar`.
- Shared constructed-intersection scalar policy `IntersectionScalar`.
- Shared segment-intersection classification `SegmentIntersectionKind`.
- Shared ring-validation issue vocabulary `RingValidationIssue`.
- Shared ring-validation result representation `RingValidationResult`.
- Shared Douglas-Peucker workspace sizing helper
  `douglasPeuckerWorkspaceSize`.

### Scope

This release contains only dimension-neutral contracts required by both
`geo-d` and `geo3-d` to preserve common D declaration identity.
