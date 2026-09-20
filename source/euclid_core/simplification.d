module euclid_core.simplification;


/*
 * Maximum iterative Douglas-Peucker workspace for pointCount stored points.
 */
size_t douglasPeuckerWorkspaceSize(
    size_t pointCount
)
    pure nothrow @safe @nogc
{
    return pointCount > 2
        ? pointCount - 2
        : 0;
}


@safe unittest
{
    static assert(
        douglasPeuckerWorkspaceSize(0) ==
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
}
