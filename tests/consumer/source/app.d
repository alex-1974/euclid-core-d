/**
 * External consumer verification for euclid-core-d.
 *
 * This source is compiled as a separate DUB package and uses only the public
 * shared-contract modules.
 */
module app;

import euclid_core.intersection :
    SegmentIntersectionKind;

import euclid_core.ring_validation :
    RingValidationIssue,
    RingValidationResult;

import euclid_core.scalar :
    IntersectionScalar,
    MetricScalar,
    isGeoScalar;

import euclid_core.simplification :
    douglasPeuckerWorkspaceSize;


/*
 * Scalar-domain contract.
 */
static assert(isGeoScalar!int);
static assert(isGeoScalar!long);
static assert(isGeoScalar!float);
static assert(isGeoScalar!double);
static assert(isGeoScalar!real);

static assert(!isGeoScalar!byte);
static assert(!isGeoScalar!uint);
static assert(!isGeoScalar!(const int));

static assert(is(MetricScalar!int == double));
static assert(is(MetricScalar!long == double));
static assert(is(MetricScalar!float == double));
static assert(is(MetricScalar!double == double));
static assert(is(MetricScalar!real == real));

static assert(is(IntersectionScalar!int == double));
static assert(is(IntersectionScalar!long == double));
static assert(is(IntersectionScalar!float == double));
static assert(is(IntersectionScalar!double == double));

static assert(
    !__traits(
        compiles,
        IntersectionScalar!real
    )
);


/*
 * Shared nominal contracts and their observable initial state.
 */
static assert(
    SegmentIntersectionKind.init ==
    SegmentIntersectionKind.none
);

static assert(
    cast(ubyte) SegmentIntersectionKind.none ==
    0
);

static assert(
    cast(ubyte) SegmentIntersectionKind.point ==
    1
);

static assert(
    cast(ubyte) SegmentIntersectionKind.overlap ==
    2
);

static assert(
    RingValidationIssue.init ==
    RingValidationIssue.none
);

static assert(
    RingValidationResult.init.issue ==
    RingValidationIssue.none
);

static assert(
    RingValidationResult.init.primaryIndex ==
    size_t.max
);

static assert(
    RingValidationResult.init.secondaryIndex ==
    size_t.max
);

static assert(
    RingValidationResult.init.valid
);


/*
 * Shared helper contract.
 */
static assert(
    douglasPeuckerWorkspaceSize(0) ==
    0
);

static assert(
    douglasPeuckerWorkspaceSize(1) ==
    0
);

static assert(
    douglasPeuckerWorkspaceSize(2) ==
    0
);

static assert(
    douglasPeuckerWorkspaceSize(3) ==
    1
);

static assert(
    douglasPeuckerWorkspaceSize(10) ==
    8
);


@safe void main()
{
    SegmentIntersectionKind kind =
        SegmentIntersectionKind.point;

    assert(
        kind ==
        SegmentIntersectionKind.point
    );

    RingValidationResult result;

    assert(result.valid);

    result.issue =
        RingValidationIssue.selfIntersection;

    assert(!result.valid);

    assert(
        douglasPeuckerWorkspaceSize(5) ==
        3
    );
}
