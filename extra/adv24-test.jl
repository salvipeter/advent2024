# Additional functions for finding errors:

function setnumber(c, n)
    i = 0
    while true
        wire = @Printf.sprintf "%c%02d" c i
        !haskey(wires, wire) && break
        wires[wire] = n & 1
        n >>= 1
        i += 1
    end
end

# test 8 cases (carry 0/1, input 0/1 0/1):
function testbit(k)
    errors = []
    for i in 0:7
        x = ((i >> 1) & 1) << k
        y = ((i >> 2) & 1) << k
        if i & 1 == 1
            x += 1 << (k - 1)
            y += 1 << (k - 1)
        end
        setnumber('x', x)
        setnumber('y', y)
        if getnumber('z') & (1 << k) != (x + y) & (1 << k)
            push!(errors, i)
        end
    end
    errors
end

function test()
    for k in 1:44
        if testbit(k) != []
            println("Error at bit: $k (type $(testbit(k)))")
        end
    end
end
