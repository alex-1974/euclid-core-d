# euclid-core-d

`euclid-core-d` is the independently versioned shared Core package used by
the `geo-d` and `geo3-d` Euclidean geometry libraries.

It exists for two narrow reasons: some dimension-neutral public contracts must
have one D declaration identity when `geo` and `geo3` are used in the same
program, and some dimension-neutral internal implementation primitives must
provide identical numerical semantics to both dimensional siblings.

It is not a third general-purpose geometry library. Normal geometry consumers
should use `geo-d` for 2D geometry or `geo3-d` for 3D geometry.

## Scope

The package currently owns these shared public contracts:

- `isGeoScalar`
- `MetricScalar`
- `IntersectionScalar`
- `SegmentIntersectionKind`
- `RingValidationIssue`
- `RingValidationResult`
- `douglasPeuckerWorkspaceSize`

Their implementation modules are:

```text
euclid_core.scalar
euclid_core.intersection
euclid_core.ring_validation
euclid_core.simplification
```

The package may also own narrowly scoped internal implementation primitives
when both dimensional siblings require the same dimension-neutral numerical
semantics. These live below `euclid_core.internal` and are not consumer-facing
API. The first such primitive is `euclid_core.internal.metric.metricHypot`, a
Phobos 2.111 compatibility shim that delegates directly to Phobos from
frontend 2.112 onward.

Dimension-bearing geometry types and algorithms do not belong here.

In particular, `euclid-core-d` does not define points, vectors, segments,
bounds, polylines, rings, polygons, coordinate systems, projections, geodesy,
raster processing, or spatial indexing.

## Architecture

The dependency direction is:

```text
             euclid-core-d
                /     \
               v       v
            geo-d    geo3-d
```

`geo-d` and `geo3-d` are independent sibling packages. Neither depends on the
other.

A shared public contract is admitted to `euclid-core-d` only when all of these
conditions hold:

1. the contract is dimension-neutral;
2. both dimensional siblings genuinely require it;
3. correct simultaneous use requires one common D declaration identity; and
4. moving it here does not introduce a generic N-dimensional geometry model.

An internal implementation primitive may also be admitted when it is
dimension-neutral, both siblings have a concrete need for the same semantics,
and centralizing it provides a correctness, numerical-consistency, or
maintenance benefit without creating generic N-dimensional geometry.

Code reuse, convenience, or aesthetic API symmetry alone is not sufficient.

## Versioning

`euclid-core-d` is versioned independently from both dimensional sibling
libraries and follows Semantic Versioning for published releases.

The initial `0.x` release line is the integration and stabilization period for
the extracted shared contracts.

A `1.0.0` release will mark the first stable shared-contract compatibility
baseline after the independent `geo-d` and `geo3-d` packages have been
validated together against the published Core package.

Matching version numbers across the three repositories are neither required
nor implied.

## Development

Minimum supported D frontend:

```text
2.111.0
```

Run the unit tests with DMD:

```bash
dub test --compiler=dmd --force
```

and with LDC:

```bash
dub test --compiler=ldc2 --force
```

Release builds can be checked with:

```bash
dub build --build=release --compiler=dmd --force
dub build --build=release --compiler=ldc2 --force
```

## Status

The current release target is `v0.1.0`.

The package is publicly hosted because `geo-d` and `geo3-d` require an
independently versioned dependency. Its primary consumers remain those two
libraries rather than direct application code.
