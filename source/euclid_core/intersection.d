module euclid_core.intersection;


/*
 * Topology of the intersection set of two closed straight segments.
 */
enum SegmentIntersectionKind : ubyte
{
    none,
    point,
    overlap
}


@safe unittest
{
    assert(
        SegmentIntersectionKind.none ==
        SegmentIntersectionKind.init
    );

    assert(
        cast(ubyte) SegmentIntersectionKind.none ==
        0
    );

    assert(
        cast(ubyte) SegmentIntersectionKind.point ==
        1
    );

    assert(
        cast(ubyte) SegmentIntersectionKind.overlap ==
        2
    );
}
