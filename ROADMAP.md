# Roadmap

## Current objective

Prepare `euclid-core-d` as the independently versioned shared-contract
dependency for `geo-d` and `geo3-d`.

The package is intentionally small. Expansion is consumer-driven and must be
justified either by a concrete common declaration-identity requirement or by
a dimension-neutral internal primitive that both siblings require for the same
correct numerical semantics.

## v0.1.0 — Initial public development release

Before tagging `v0.1.0`:

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
- [ ] tag `v0.1.0`;
- [ ] make the package available to DUB consumers.

## Release-candidate evidence

The cross-repository release-candidate verification used these exact revisions:

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

The validated Core candidate was
`b1f03e5a11ee6fb35def3b68eb94d3286815b796`. Release-finalization changes after
that verification are documentation-only and do not alter the library source
or public contracts.

The remaining release-packaging transition is from the temporary local
`path=` dependencies in the sibling manifests to a normal versioned
`euclid-core-d` dependency after `v0.1.0` is published through DUB.

## Toward v1.0.0

`v1.0.0` will establish the first stable compatibility baseline of the shared
contracts.

Before that freeze:

- the independent package must have been exercised by both dimensional
  siblings;
- cross-repository coexistence must be durable and reproducible;
- release packaging must no longer depend on the workspace directory layout;
- the seven admitted contracts and their observable semantics must be audited;
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
