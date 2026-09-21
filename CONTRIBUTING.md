# Contributing

`euclid-core-d` is intentionally narrower than a normal utility library.

Before proposing a new public declaration, establish that:

1. the contract is dimension-neutral;
2. both `geo-d` and `geo3-d` have a concrete consumer for it;
3. simultaneous use requires one common D declaration identity; and
4. the declaration does not introduce generic N-dimensional geometry.

Code reuse, convenience, or naming symmetry alone do not justify expanding the
package.

Changes to existing public contracts must consider the independently versioned
`geo-d` and `geo3-d` consumers.

Before submitting a change, run:

```bash
dub test --compiler=dmd --force
dub test --compiler=ldc2 --force
dub build --build=release --compiler=dmd --force
dub build --build=release --compiler=ldc2 --force
```

Keep commits focused and do not mix unrelated geometry functionality into the
shared-contract package.
