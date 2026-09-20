module euclid_core.ring_validation;


/*
 * Validation issue detected in a dimension-independent cyclic polygonal
 * chain representation.
 */
enum RingValidationIssue : ubyte
{
    none,
    tooFewVertices,
    nonFiniteCoordinate,
    zeroLengthEdge,
    selfIntersection,
    selfOverlap
}


/*
 * Shared diagnostic representation for ring validation.
 */
struct RingValidationResult
{
    RingValidationIssue issue =
        RingValidationIssue.none;

    size_t primaryIndex =
        size_t.max;

    size_t secondaryIndex =
        size_t.max;


    @property bool valid() const
        pure nothrow @safe @nogc
    {
        return issue ==
            RingValidationIssue.none;
    }
}


@safe unittest
{
    const result =
        RingValidationResult.init;

    assert(result.valid);

    assert(
        result.issue ==
        RingValidationIssue.none
    );

    assert(
        result.primaryIndex ==
        size_t.max
    );

    assert(
        result.secondaryIndex ==
        size_t.max
    );
}
