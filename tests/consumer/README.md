# External consumer test

This directory is a separate DUB package that depends on the repository root
through a local path dependency.

Its purpose is to verify the supported `euclid-core-d` contracts from outside
the library package.

The test imports only the public modules:

```d
import euclid_core.scalar;
import euclid_core.intersection;
import euclid_core.ring_validation;
import euclid_core.simplification;
```

It exercises exactly the seven shared contracts currently admitted to the
package:

- `isGeoScalar`
- `MetricScalar`
- `IntersectionScalar`
- `SegmentIntersectionKind`
- `RingValidationIssue`
- `RingValidationResult`
- `douglasPeuckerWorkspaceSize`

This repository-local path dependency is test infrastructure. Published
consumers must resolve `euclid-core-d` as an independently versioned package.
