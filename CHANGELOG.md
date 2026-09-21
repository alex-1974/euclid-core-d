# Changelog

All notable changes to `euclid-core-d` are documented here.

The project follows Semantic Versioning for published releases.

## [Unreleased]

No unreleased changes.

## [0.1.0] - 2026-09-21

Initial public development release.

### Changed

- Promoted the initial local architecture probe into an independently versioned
  shared-contract package for `geo-d` and `geo3-d`.
- Defined the package scope as declaration-identity support rather than a third
  consumer-facing geometry API.
- Added release, contribution, security, licensing, and CI project metadata.
- Added a repository-local external consumer test for the seven shared
  contracts.

### Added

- Shared scalar-domain contract `isGeoScalar`.
- Shared metric result policy `MetricScalar`.
- Shared constructed-intersection scalar policy `IntersectionScalar`.
- Shared segment-intersection classification `SegmentIntersectionKind`.
- Shared ring-validation issue vocabulary `RingValidationIssue`.
- Shared ring-validation result representation `RingValidationResult`.
- Shared Douglas-Peucker workspace sizing helper
  `douglasPeuckerWorkspaceSize`.

### Validation

The release candidate was verified against:

- `geo-d` at `e19aa1accc16f9ec74d31f0e2c071b53ac74c6d4`;
- `geo3-d` at `78debd9922a306d39949b90c38f1ce24d282859b`;
- `euclid-core-d` at `b1f03e5a11ee6fb35def3b68eb94d3286815b796`.

The cross-repository family probes passed with DMD and LDC, resolved exactly
one Core source instance, and verified common declaration identity for all
seven shared contracts.

The validated Core candidate was
`b1f03e5a11ee6fb35def3b68eb94d3286815b796`. The subsequent release-finalization
change is documentation-only and does not alter the library source or public
contracts.

### Scope

This release contains only dimension-neutral contracts required by both
`geo-d` and `geo3-d` to preserve common D declaration identity.
