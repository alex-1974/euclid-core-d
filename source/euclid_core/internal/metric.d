module euclid_core.internal.metric;

import std.math.algebraic : hypot;
import std.math.traits : isNaN;
import std.traits : isFloatingPoint;

/**
 * Internal metric helper shared by geo-d and geo3-d.
 *
 * Provides the corrected Phobos 2.112 ordering for the negligible-component
 * case before delegating to std.math.algebraic.hypot. This preserves tiny
 * axis-aligned magnitudes on the supported Phobos 2.111 floor, where hypot
 * otherwise scales the operands before returning the larger one.
 *
 * This module is implementation infrastructure. It is not part of the
 * application-level geometry API and must not be re-exported by geo or geo3.
 */
T metricHypot(T)(const T x, const T y) @safe pure nothrow @nogc
if (isFloatingPoint!T)
{
    import core.math : fabs;

    T u = fabs(x);
    T v = fabs(y);

    // Match corrected Phobos operand ordering and special-value semantics.
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

    // Phobos 2.111 performs this test after tiny-value scaling. Moving it
    // before the delegated hypot call backports the corrected 2.112 ordering.
    if (u * T.epsilon > v)
        return u;

    return hypot(x, y);
}

@safe pure nothrow @nogc unittest
{
    import std.math.traits : isIdentical, isNaN;

    enum double smallest = 0x1p-1074;

    assert(isIdentical(metricHypot(smallest, 0.0), smallest));
    assert(isIdentical(metricHypot(0.0, smallest), smallest));
    assert(isIdentical(metricHypot(-smallest, 0.0), smallest));
    assert(isIdentical(metricHypot(smallest, -0.0), smallest));

    assert(metricHypot(0.0, 0.0) == 0.0);
    assert(metricHypot(3.0, 4.0) == 5.0);
    assert(metricHypot(double.infinity, 1.0) == double.infinity);
    assert(metricHypot(1.0, double.infinity) == double.infinity);
    assert(metricHypot(double.infinity, double.nan) == double.infinity);
    assert(metricHypot(double.nan, double.infinity) == double.infinity);
    assert(metricHypot(double.nan, 1.0).isNaN);
    assert(metricHypot(1.0, double.nan).isNaN);
    assert(metricHypot(double.nan, double.nan).isNaN);

    // Do not collapse two comparable subnormals to the larger operand.
    const double pair = metricHypot(smallest, smallest);
    assert(pair >= smallest);
}

@safe pure nothrow @nogc unittest
{
    // Exercise the same compatibility path for binary32.
    enum float smallest = float.min_normal * float.epsilon;
    assert(metricHypot(smallest, 0.0f) == smallest);
    assert(metricHypot(0.0f, smallest) == smallest);
}

@safe pure nothrow @nogc unittest
{
    // CTFE must remain available to consumers.
    enum double h = metricHypot(3.0, 4.0);
    static assert(h == 5.0);
}
