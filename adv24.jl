import Printf

function operate(op, a, b)
    op == "AND" && return a & b
    op == "OR"  && return a | b
    return xor(a, b)
end

function getbit(wire)
    haskey(wires, wire) && return wires[wire]
    for (a, op, b, w) in data
        w == wire && return operate(op, getbit(a), getbit(b))
    end
end

wire(c, i) = @Printf.sprintf "%c%02d" c i

function getnumber(c)
    i = 0
    p1 = 0
    while true
        x = getbit(wire(c, i))
        x == nothing && break
        p1 += (1 << i) * x
        i += 1
    end
    p1
end

println(getnumber('z'))

"Given the operation and an argument, returns the result."
function findresult(op, a)
    for rule in data
        rule[2] == op && (rule[1] == a || rule[3] == a) && return rule[4]
    end
end

# The pattern is always the same:
#
# x.. XOR y.. -> AAA
# x.. AND y.. -> BBB
# CCC XOR AAA -> z..  [CCC is the previous carry]
# CCC AND AAA -> DDD
# BBB  OR DDD -> EEE  [new carry]
#
# Also, swaps are always local in one such pattern.

# The following swaps are handled:
# - z.. with anything
# - AAA with BBB
# Other cases may be possible for different data.
function swaps(k)
    wz = wire('z', k)
    a = findresult("XOR", wire('x', k))
    b = findresult("AND", wire('x', k))
    z = findresult("XOR", a)
    d = findresult("AND", a)
    e = findresult("OR", b)
    if z != wz
        a == wz && return [a, z]
        b == wz && return [b, z]
        d == wz && return [d, z]
        e == wz && return [e, z]
        # `z` must be nothing, so the problem is with `a`
        e == nothing && return [a, b]
        @error "Some other case..."
    end
    []
end

function allswaps()
    solution = []
    for i in 1:44
        append!(solution, swaps(i))
    end
    sort(solution)
end

println(join(allswaps(), ","))
