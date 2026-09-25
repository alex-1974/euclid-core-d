# Changelog

All notable changes to `euclid-core-d` are documented here.

The project follows Semantic Versioning for published releases.

## [Unreleased]

No unreleased changes.

## [0.1.2] - 2026-09-25

Patch release adding a shared zero-preserving power-of-two scaling primitive
for the dimensional Euclidean siblings.

### Added

- Added internal `euclid_core.internal.metric.metricScalbn`.
- The helper preserves `+0.0` and `-0.0` exactly before delegating all
  non-zero values to Phobos/runtime `scalbn`.
- Added runtime and CTFE regression coverage for signed zero, ordinary finite
  values, infinities, NaN, and `float` / `double` / `real`.

### Fixed

- Avoided the LDC runtime `ldexp` defect that can turn zero into a non-zero
  value for sufficiently large positive exponents.

### Validation

The implementation passed unit tests, the repository-local external consumer,
and release builds on:

- DMD 2.111.0
- DMD 2.112.1
- DMD 2.113.0
- LDC 1.41.0
- LDC 1.42.0
- LDC 1.43.0

The implementation was merged by PR #8 at:

```text
71730dd706110aacf80907e2c41c0c85db483f0b
```

Downstream adoption remains owned by the respective sibling projects.

## [0.1.1] - 2026-09-25

Patch release adding the shared Phobos 2.111 metric compatibility primitive
required by both dimensional sibling libraries.

### Added

- Added internal `euclid_core.internal.metric.metricHypot` for the Phobos
  2.111 two-argument `hypot` tiny-operand correctness defect.
- Added ADR 0001 documenting admission of shared dimension-neutral internal
  implementation primitives when both dimensional siblings require identical
  numerical semantics.

### Changed

- Scoped the compatibility workaround to frontend/Phobos 2.111 with
  `static if (__VERSION__ == 2111)`; frontend 2.112 and later delegate
  directly to Phobos.
- Expanded CI to the controlled DMD 2.111/2.112/2.113 and LDC
  1.41/1.42/1.43 compiler matrix.
- Clarified Core scope to include narrowly scoped internal numerical
  infrastructure in addition to shared declaration-identity contracts.

### Validation

The implementation candidate passed unit tests, the repository-local external
consumer, and release builds on:

- DMD 2.111.0
- DMD 2.112.1
- DMD 2.113.0
- LDC 1.41.0
- LDC 1.42.0
- LDC 1.43.0

The implementation was merged by PR #5 at:

```text
c9fd4b2f5eca46a4d0170b0de915b8e1481380a9
```

Downstream adoption remains owned by the respective sibling projects.

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
