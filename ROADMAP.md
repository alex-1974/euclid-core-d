# Roadmap

## Current objective

Prepare `euclid-core-d` as the independently versioned shared Core dependency
for `geo-d` and `geo3-d`.

The package is intentionally small. Expansion is consumer-driven and must be
justified either by a concrete common declaration-identity requirement or by
a dimension-neutral internal primitive that both siblings require for the same
correct numerical semantics.

## v0.1.2 — zero-preserving metric scaling

Release goal: make the validated shared `metricScalbn` implementation
available as a versioned Core dependency before downstream 2D/3D adoption.

Release preparation:

- [x] merge the validated `metricScalbn` implementation to `main`;
- [x] validate the controlled six-compiler matrix;
- [x] prepare the `v0.1.2` changelog and release runbook;
- [ ] merge the release-metadata PR;
- [ ] create annotated tag `v0.1.2` on the resulting `main` commit;
- [ ] push the tag to GitHub;
- [ ] verify registry resolution of `euclid-core-d@0.1.2`;
- [ ] hand off `metricHypot` + `metricScalbn` adoption to `geo-d` and
  `geo3-d`.

Existing release tags must not be moved.

## v0.1.1 — Phobos 2.111 metric compatibility

Release goal: make the validated shared `metricHypot` implementation available
as a versioned Core dependency without performing downstream code changes from
this repository.

Release preparation:

- [x] merge the validated `metricHypot` implementation and ADR to `main`;
- [x] validate the controlled six-compiler matrix;
- [x] prepare the `v0.1.1` changelog and release runbook;
- [x] merge the release-metadata PR;
- [x] create annotated tag `v0.1.1` on the resulting `main` commit;
- [x] push the tag to GitHub;
- [x] register or refresh `euclid-core-d` in the public DUB registry;
- [x] verify registry resolution of `euclid-core-d@0.1.1`;
- [x] open versioned adoption issues in `geo-d` and `geo3-d`.

The existing `v0.1.0` tag must not be moved.

## v0.1.0 — Initial public development release

The initial public release established the independently versioned Core package.

Completed:

- [x] establish the repository as an independent Git repository;
- [x] publish the repository independently on GitHub;
- [x] keep the shared surface free of dimension-bearing geometry;
- [x] verify unit tests with DMD 2.111.0;
- [x] verify unit tests with LDC based on frontend 2.111.0;
- [x] verify release builds with DMD and LDC;
- [x] document independent Semantic Versioning;
- [x] document the narrow shared-contract scope;
- [x] add and run repository CI;
- [x] verify a repository-local external consumer of the shared modules;
- [x] verify `geo-d` against the release candidate;
- [x] verify `geo3-d` against the release candidate;
- [x] verify simultaneous `geo` / `geo3` use with one resolved Core instance;
- [x] verify the seven shared declaration identities across both siblings;
- [x] tag `v0.1.0`.

Public DUB-registry publication was completed with `v0.1.1`.

## Release-candidate evidence

The original cross-repository `v0.1.0` release-candidate verification used
these exact revisions:

- `geo-d`: `e19aa1accc16f9ec74d31f0e2c071b53ac74c6d4`
- `geo3-d`: `78debd9922a306d39949b90c38f1ce24d282859b`
- `euclid-core-d`: `b1f03e5a11ee6fb35def3b68eb94d3286815b796`

The verified family consumer established that:

- both dimensional sibling libraries build and test against the same Core
  release candidate with DMD and LDC;
- simultaneous `import geo; import geo3;` succeeds;
- DUB resolves one `euclid-core-d` source instance for the family consumer;
- all seven admitted shared contracts have one common D declaration identity;
- dimension-specific overload families such as `distance` coexist correctly;
- both sibling repositories can be consumed directly from Git at their exact
  verified revisions.

## Toward v1.0.0

`v1.0.0` will establish the first stable compatibility baseline of the shared
contracts and internal Core infrastructure.

Before that freeze:

- the independently published package must have been exercised by both
  dimensional siblings;
- cross-repository coexistence must be durable and reproducible;
- release packaging must no longer depend on the workspace directory layout;
- the admitted contracts and their observable semantics must be audited;
- shared internal primitives must remain narrowly justified and internal;
- there must be no speculative dimension-neutral API added merely for reuse or
  symmetry.

No additional geometry functionality is required merely to reach `v1.0.0`.

## Future expansion

A new public contract may enter `euclid-core-d` only when:

1. it is dimension-neutral;
2. both `geo-d` and `geo3-d` have concrete need for the contract;
3. common D declaration identity is required for correct coexistence; and
4. the extraction preserves the independence of the dimensional libraries.

A dimension-neutral internal implementation primitive may enter Core when
both siblings concretely require identical semantics and centralization gives
a correctness, numerical-consistency, or maintenance benefit. Such a primitive
must remain internal infrastructure and must not become a generic
N-dimensional geometry abstraction.

Convenience, implementation reuse, or aesthetic symmetry alone are not
sufficient.
