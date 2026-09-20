module euclid_core.scalar;


/*
 * Shared public scalar domain for the Euclidean geometry library family.
 */
enum bool isGeoScalar(T) =
       is(T == int)
    || is(T == long)
    || is(T == float)
    || is(T == double)
    || is(T == real);


/*
 * Shared metric computation scalar.
 */
template MetricScalar(T)
if (isGeoScalar!T)
{
    static if (is(T == real))
        alias MetricScalar = real;
    else
        alias MetricScalar = double;
}


/*
 * Shared constructed-intersection scalar policy.
 *
 * real remains deliberately unsupported.
 */
template IntersectionScalar(T)
if (
       is(T == int)
    || is(T == long)
    || is(T == float)
    || is(T == double)
)
{
    alias IntersectionScalar = double;
}


@safe unittest
{
    static assert(isGeoScalar!int);
    static assert(isGeoScalar!long);
    static assert(isGeoScalar!float);
    static assert(isGeoScalar!double);
    static assert(isGeoScalar!real);

    static assert(is(MetricScalar!int == double));
    static assert(is(MetricScalar!double == double));
    static assert(is(MetricScalar!real == real));

    static assert(is(IntersectionScalar!int == double));
    static assert(is(IntersectionScalar!double == double));

    static assert(
        !__traits(
            compiles,
            IntersectionScalar!real
        )
    );
}
