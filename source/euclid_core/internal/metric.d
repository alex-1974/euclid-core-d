module euclid_core.internal.metric;

import std.math.algebraic : hypot;
import std.math.exponential : scalbn;
import std.traits : isFloatingPoint;

/**
 * Internal metric helper shared by geo-d and geo3-d.
 *
 * On frontend/Phobos 2.111 this works around the known two-argument hypot
 * defect for tiny operands. Starting with Phobos 2.112, metricHypot delegates
 * directly so later Phobos numerical fixes remain authoritative.
 *
 * This module is implementation infrastructure. It is not part of the
 * application-level geometry API and must not be re-exported by geo or geo3.
 */
T metricHypot(T)(const T x, const T y) @safe pure nothrow @nogc
if (isFloatingPoint!T)
{
    static if (__VERSION__ == 2111)
    {
        import core.math : fabs;
        import std.math.traits : isNaN;

        T u = fabs(x);
        T v = fabs(y);

        if (!(u >= v))
        {
            v = u;
            u = fabs(y);

            if (u == T.infinity)
                return u;
            if (v == T.infinity)
                return v;
            if (u.isNaN || v.isNaN)
                return T.nan;
        }

        /*
         * Phobos 2.111 performs its negligible-component test only after
         * scaling tiny operands. Returning the scaled u from that test loses
         * the inverse scale.
         *
         * Use the equivalent ratio form here instead of u * epsilon > v.
         * For the smallest subnormal, u * epsilon itself underflows to zero;
         * v / u remains representable (and is exactly zero for an
         * axis-aligned magnitude), so the 2.111 defect is intercepted before
         * entering Phobos.
         */
        if (u != 0 && v / u < T.epsilon)
            return u;
    }

    return hypot(x, y);
}

/**
 * Zero-preserving power-of-two scaling shared by geo-d and geo3-d.
 *
 * LDC's runtime ldexp implementation currently treats an exponent-field
 * value of zero as a subnormal input without first excluding signed zero.
 * For sufficiently large positive exponents, that can turn +/-0 into a
 * non-zero value. Zero scaled by any finite integer power of two is exactly
 * zero, so intercept it before delegating all non-zero values to scalbn.
 *
 * Returning value rather than T(0) preserves the sign bit of -0.
 *
 * This module is implementation infrastructure. metricScalbn is not part of
 * the application-level geometry API and must not be re-exported by geo or
 * geo3.
 */
T metricScalbn(T)(const T value, const int exponent) @safe pure nothrow @nogc
if (isFloatingPoint!T)
{
    if (value == T(0))
        return value;

    return scalbn(value, exponent);
}

@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical, isNaN;

    enum double smallest = 0x1p-1074;

    // Exact regression for the Phobos 2.111 scaling/early-return defect.
    assert(isIdentical(metricHypot(smallest, 0.0), smallest));
    assert(isIdentical(metricHypot(0.0, smallest), smallest));
    assert(isIdentical(metricHypot(-smallest, 0.0), smallest));
    assert(isIdentical(metricHypot(smallest, -0.0), smallest));

    assert(isIdentical(metricHypot(0.0, 0.0), 0.0));
    assert(metricHypot(3.0, 4.0) == 5.0);
    assert(metricHypot(double.infinity, 1.0) == double.infinity);
    assert(metricHypot(1.0, double.infinity) == double.infinity);
    assert(metricHypot(double.infinity, double.nan) == double.infinity);
    assert(metricHypot(double.nan, double.infinity) == double.infinity);
    assert(metricHypot(double.nan, 1.0).isNaN);
    assert(metricHypot(1.0, double.nan).isNaN);
    assert(metricHypot(double.nan, double.nan).isNaN);

    enum double u = 1.0;
    enum double below = double.epsilon / 2.0;
    enum double boundary = double.epsilon;
    assert(isIdentical(metricHypot(u, below), u));
    assert(metricHypot(u, boundary) >= u);

    // sqrt(2) * smallest lies below the halfway point to the next binary64
    // subnormal, so correct round-to-nearest remains exactly smallest.
    const double pair = metricHypot(smallest, smallest);
    assert(isIdentical(pair, smallest));
}

@safe pure nothrow @nogc unittest
{
    enum float smallest = float.min_normal * float.epsilon;
    assert(metricHypot(smallest, 0.0f) == smallest);
    assert(metricHypot(0.0f, smallest) == smallest);

    enum float u = 1.0f;
    enum float below = float.epsilon / 2.0f;
    enum float boundary = float.epsilon;
    assert(metricHypot(u, below) == u);
    assert(metricHypot(u, boundary) >= u);
}

@safe pure nothrow @nogc unittest
{
    enum real smallest = real.min_normal * real.epsilon;
    assert(metricHypot(smallest, 0.0L) == smallest);
    assert(metricHypot(0.0L, smallest) == smallest);
}

@safe pure nothrow @nogc unittest
{
    enum double h = metricHypot(3.0, 4.0);
    static assert(h == 5.0);

    enum double smallest = 0x1p-1074;
    enum double tinyAxis = metricHypot(smallest, 0.0);
    static assert(tinyAxis == smallest);
}


@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical, isNaN;

    double positiveZero = 0.0;
    double negativeZero = -0.0;

    // Exact runtime regression for the LDC zero-input ldexp defect.
    assert(isIdentical(metricScalbn(positiveZero, 1074), 0.0));
    assert(isIdentical(metricScalbn(negativeZero, 1074), -0.0));

    // Zero is exact for scaling in either exponent direction.
    assert(isIdentical(metricScalbn(positiveZero, -1074), 0.0));
    assert(isIdentical(metricScalbn(negativeZero, -1074), -0.0));

    // Non-zero finite values continue to use the native scalbn semantics.
    assert(metricScalbn(1.5, 10) == scalbn(1.5, 10));
    assert(metricScalbn(-1.5, -10) == scalbn(-1.5, -10));

    enum double smallest = 0x1p-1074;
    assert(metricScalbn(smallest, 1074) == scalbn(smallest, 1074));
    assert(metricScalbn(smallest, 1074) == 1.0);

    // Special non-zero values are delegated unchanged.
    assert(
        metricScalbn(double.infinity, 37) ==
        scalbn(double.infinity, 37)
    );
    assert(
        metricScalbn(-double.infinity, -37) ==
        scalbn(-double.infinity, -37)
    );
    assert(metricScalbn(double.nan, 42).isNaN);
}

@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical;

    float positiveZero = 0.0f;
    float negativeZero = -0.0f;

    assert(isIdentical(metricScalbn(positiveZero, 149), 0.0f));
    assert(isIdentical(metricScalbn(negativeZero, 149), -0.0f));
    assert(isIdentical(metricScalbn(positiveZero, -149), 0.0f));
    assert(isIdentical(metricScalbn(negativeZero, -149), -0.0f));

    assert(metricScalbn(1.5f, 10) == scalbn(1.5f, 10));
}

@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical;

    real positiveZero = 0.0L;
    real negativeZero = -0.0L;

    assert(isIdentical(metricScalbn(positiveZero, 1074), 0.0L));
    assert(isIdentical(metricScalbn(negativeZero, 1074), -0.0L));
    assert(isIdentical(metricScalbn(positiveZero, -1074), 0.0L));
    assert(isIdentical(metricScalbn(negativeZero, -1074), -0.0L));

    assert(metricScalbn(1.5L, 10) == scalbn(1.5L, 10));
}

@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical;

    enum double positiveZero = metricScalbn(0.0, 1074);
    enum double negativeZero = metricScalbn(-0.0, 1074);
    enum double scaled = metricScalbn(1.5, 4);

    static assert(isIdentical(positiveZero, 0.0));
    static assert(isIdentical(negativeZero, -0.0));
    static assert(scaled == 24.0);
}
