module euclid_core.internal.metric;

import std.math.algebraic : hypot;
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

    const double pair = metricHypot(smallest, smallest);
    assert(pair > smallest);
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
