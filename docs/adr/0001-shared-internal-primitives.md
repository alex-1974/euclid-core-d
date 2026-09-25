# ADR 0001: Admit shared dimension-neutral internal implementation primitives

- Status: Accepted
- Date: 2026-09-25

## Context

`euclid-core-d` was created to hold dimension-neutral public contracts that
must have one D declaration identity when `geo-d` and `geo3-d` are used
together.

While implementing metric primitives in `geo-d`, the supported minimum
frontend/Phobos line 2.111 exposed a correctness defect in two-argument
`std.math.algebraic.hypot`: for sufficiently tiny operands, Phobos scales
before its negligible-component early return and can return the scaled larger
operand without restoring the scale.

The defect is dimension-neutral. Both `geo-d` and `geo3-d` use `hypot`
for metric code and both support frontend 2.111. Duplicating the workaround in
both siblings would create two copies of a numerical compatibility rule that
must remain identical.

## Decision

`euclid-core-d` may own a dimension-neutral internal implementation primitive
when all of the following hold:

1. both dimensional siblings have a concrete need for it;
2. both require the same observable numerical semantics;
3. centralization provides a concrete correctness, numerical-consistency, or
   maintenance benefit; and
4. the primitive does not introduce a generic N-dimensional geometry model or
   become consumer-facing geometry API.

This is a separate admission path from shared public contracts, whose common D
declaration identity remains their defining reason for living in Core.

The first admitted internal primitive is
`euclid_core.internal.metric.metricHypot`.

For frontend 2.111, `metricHypot` intercepts the affected negligible-component
case using an underflow-safe magnitude-ratio comparison before delegating to
Phobos. The workaround is guarded by `static if (__VERSION__ == 2111)`.

From frontend 2.112 onward, `metricHypot` delegates directly to Phobos. Core
therefore does not permanently fork or freeze Phobos `hypot` semantics and
automatically inherits later Phobos numerical improvements.

The helper remains under `euclid_core.internal` and must not be re-exported as
application-level API by `geo-d` or `geo3-d`.

## Consequences

- The Phobos 2.111 workaround has one implementation and one regression suite.
- `geo-d` and `geo3-d` receive identical compatibility behavior.
- Newer Phobos versions remain authoritative.
- Core scope is slightly broader than declaration identity, but remains narrow
  and consumer-driven.
- Code reuse alone is still insufficient reason to move an implementation into
  Core.

## Validation

The compatibility helper is covered by the exact smallest-positive-binary64
subnormal regression and ordinary finite, zero, infinity, NaN, sign/symmetry,
float, double, real, and CTFE cases.

The controlled CI matrix passes unit tests, the external consumer, and release
builds on:

- DMD 2.111.0
- DMD 2.112.1
- DMD 2.113.0
- LDC 1.41.0
- LDC 1.42.0
- LDC 1.43.0
