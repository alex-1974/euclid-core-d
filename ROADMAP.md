# Roadmap

## Current objective

Prepare `euclid-core-d` as the independently versioned shared-contract
dependency for `geo-d` and `geo3-d`.

The package is intentionally small. Expansion is consumer-driven and must be
justified by a concrete common declaration-identity requirement.

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
- [ ] add and run repository CI;
- [x] verify a repository-local external consumer of the shared modules;
- [ ] verify `geo-d` against the release candidate;
- [ ] verify `geo3-d` against the release candidate;
- [ ] verify simultaneous `geo` / `geo3` use with one resolved Core instance;
- [ ] verify the seven shared declaration identities across both siblings;
- [ ] make the package available to DUB consumers;
- [ ] tag `v0.1.0`.

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

A new declaration may enter `euclid-core-d` only when:

1. it is dimension-neutral;
2. both `geo-d` and `geo3-d` have concrete need for the contract;
3. common D declaration identity is required for correct coexistence; and
4. the extraction preserves the independence of the dimensional libraries.

Convenience, implementation reuse, or aesthetic symmetry alone are not
sufficient.
