# Releasing euclid-core-d

This document defines the release procedure for the independently versioned
Core package. Downstream code changes in `geo-d` or `geo3-d` are not part of
this procedure.

## v0.1.1 release candidate

Purpose:

- publish the shared `euclid_core.internal.metric.metricHypot` compatibility
  primitive;
- preserve the existing `v0.1.0` tag unchanged;
- make Core consumable as a normal versioned DUB dependency.

The implementation was merged to `main` by PR #5 at:

```text
c9fd4b2f5eca46a4d0170b0de915b8e1481380a9
```

The release tag must point to the final `main` commit after the release
metadata PR is merged, not directly to the implementation merge commit above.

## 1. Merge the release metadata

Merge the `release/v0.1.1` PR only after its CI matrix is green.

Then update the local checkout:

```bash
git switch main
git pull --ff-only origin main
git status --short --branch
```

Record the release commit:

```bash
RELEASE_COMMIT="$(git rev-parse HEAD)"
printf '%s\n' "$RELEASE_COMMIT"
```

## 2. Final local verification

The repository CI is authoritative, but the release workstation may repeat the
controlled matrix before tagging.

At minimum verify the package recipe and default build:

```bash
dub describe
dub test --compiler=dmd --force
dub build --build=release --compiler=dmd --force
```

For the controlled workspace matrix, use the versioned compiler wrappers
already established under `~/.local/bin`:

```text
dmd-2.111.0
dmd-2.112.1
dmd-2.113.0
ldc-1.41.0
ldc-1.42.0
ldc-1.43.0
```

## 3. Create the annotated release tag

Do not move or replace `v0.1.0`.

Create `v0.1.1` on the exact release commit:

```bash
git tag -a v0.1.1 "$RELEASE_COMMIT" -m "euclid-core-d v0.1.1"
git show --no-patch --decorate v0.1.1
git rev-parse v0.1.1^{commit}
test "$(git rev-parse v0.1.1^{commit})" = "$RELEASE_COMMIT"
```

Push only after the verification succeeds:

```bash
git push origin v0.1.1
```

## 4. Register or refresh the DUB package

The public DUB registry derives numbered package releases from SemVer Git tags.
Repository registration is a one-time operation; after registration, a new
`v0.1.1` tag is sufficient for the registry to discover the version.

First check whether the package is already registered:

```bash
dub search euclid-core-d
```

If it is not registered, use the DUB registry web interface to register:

```text
package: euclid-core-d
repository: https://github.com/alex-1974/euclid-core-d
```

An optional automation CLI is `dub-publish`; it is not required by DUB
itself. If already installed and authenticated, the equivalent registration is:

```bash
dub-publish register \
  --package euclid-core-d \
  --url https://github.com/alex-1974/euclid-core-d
```

Once registered, the registry normally discovers pushed SemVer tags
automatically. If `dub-publish` is configured, an explicit metadata refresh
may be requested with:

```bash
dub-publish update -n euclid-core-d
```

Never place registry credentials in the repository, command history, release
notes, or CI logs.

## 5. Verify registry publication

The release is complete only when DUB resolves the numbered release from the
public registry.

Clear stale package metadata if necessary and fetch the exact release:

```bash
dub clean-caches
dub fetch euclid-core-d@0.1.1 --cache=local
```

Then perform a clean consumer smoke test in a temporary directory:

```bash
tmp="$(mktemp -d)"
cd "$tmp"
dub init euclid-core-smoke --type=executable --format=sdl
cd euclid-core-smoke
dub add euclid-core-d@0.1.1

cat > source/app.d <<'EOF'
import euclid_core.internal.metric : metricHypot;

void main()
{
    assert(metricHypot(3.0, 4.0) == 5.0);
}
EOF

dub run --compiler=dmd
```

The package is ready for downstream adoption only after this resolves
`euclid-core-d 0.1.1` from the registry rather than a local path override.

## 6. Downstream handoff

After registry verification, notify the existing project-owned issues:

- `geo-d` issue #24;
- `geo3-d` issue #25.

Those projects own their respective dependency update, call-site replacement,
regression tests, and release decisions. No such code changes belong in this
repository.

## Release completion criteria

`v0.1.1` is complete when:

- the release-metadata PR is merged;
- CI is green on the controlled six-compiler matrix;
- annotated tag `v0.1.1` points to the intended `main` commit;
- the tag is pushed to GitHub;
- the DUB registry exposes version `0.1.1`;
- a clean external consumer resolves and runs against the registry package.
