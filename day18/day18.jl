fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

ints(t) = parse.(Int, split(t, ","))

#R = ["1,1,1", "2,1,1"]
P = Set(Tuple.(ints.(R)))

function countsurfaces(P)
    sum(P) do (a,b,c)
        n = ((a+1,b,c)∈P) +
            ((a-1,b,c)∈P) +
            ((a,b+1,c)∈P) +
            ((a,b-1,c)∈P) +
            ((a,b,c+1)∈P) +
            ((a,b,c-1)∈P)
        6 - n
    end
end
part1 = countsurfaces(P)
@show part1


# reuse A⭐ from day12

function A⭐step!(f, Q, S, D, X)
    sort!(Q, rev=true)
    d, p = pop!(Q)

    # no diagonals
    for j in [-1,1]
        for d in 1:3
            z = [0,0,0]
            z[d] = j
            Δ = CartesianIndex(z[1], z[2], z[3])

            n = p + Δ
            checkbounds(Bool, X, n) || continue

            c = f(X[p], X[n])
            isnothing(c) && continue
            d = c + D[p]
            d >= D[n] && continue
            D[n] = d
            S[n] = S[p] + 1

            push!(Q, (d, n))
        end
    end
end

function A⭐(f, X, start; unvisited = 10length(X))
    S = fill(unvisited, size(X))
    D = fill(unvisited, size(X))
    S[start] = 0
    D[start] = 0

    Q = [(0, start)]

    while !isempty(Q)
        A⭐step!(f, Q, S, D, X)
        # display(D)
    end

    S, D
end

Smax = maximum(maximum, P)
Smin = minimum(minimum, P)
p0 = CartesianIndex(2-Smin, 2-Smin, 2-Smin)
X = zeros(3+Smax-Smin,3+Smax-Smin,3+Smax-Smin)
for p in P
    X[CartesianIndex(1,1,1) + CartesianIndex(p)] = 1
end

_,D = A⭐(X, CartesianIndex(1,1,1)) do a,b
    b
end

allpos = Set{CartesianIndex{3}}()
for (i,d) in pairs(D)
    !iszero(d) && push!(allpos, i)
end
P2 = Set((p[1], p[2], p[3]) for p in allpos)
part2 = countsurfaces(P2)
@show part2
