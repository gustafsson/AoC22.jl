using AoC22

fn = "example.txt"
# fn = "example_smaller.txt"
# fn = "input.txt"
part2 = true

CI = CartesianIndex
println()
R = readmatrix(fn) .== '#'
P = findall(R)

function suggestmove(p, i, P)
    c = sum((p + CI(dy,dx) ∈ P
        for dy in -1:1, dx in -1:1))
    if c == 1
        return p
    end

    D = [
        CI(-1,0),
        CI(1,0),
        CI(0,-1),
        CI(0,1),
        ]

    for j in 1:4
        d = D[mod1(i+j, 4)]
        alt = d[1] != 0 ? CI.(0,-1:1) : CI.(-1:1,0)
        if !any(∈(P), (p + d,) .+ alt)
            return p + d
        end
    end

    p
end

function spreadout1(P, iteration)
    dP = Set(P)
    N = suggestmove.(P, iteration, (dP,))
    hasdup(n) = 1 < sum(==(n), N)
    D = hasdup.(N)
    N[D] = P[D]
    N
end

function bbox(P)
    extrema(getindex.(P, 1)),
    extrema(getindex.(P, 2))
end

function showP(P)
    (y1,y2),(x1,x2) = bbox(P)
    M = falses(1+y2-y1, 1+x2-x1)
    for p in P
        M[p - CI(y1-1,x1-1)] = true
    end
    printcharmatrix(M)
end

i = 0
for _ in 0:(part2 ? 10000 : 9)
    # println(i)
    # showP(P)
    N = spreadout1(P, i)
    if P == N
        break
    else
        P = N
    end
    i += 1
end

(y1,y2),(x1,x2) = bbox(P)
if part2
    @show part2 = i+1
else
    @show part1 = (1+x2-x1)*(1+y2-y1) - length(P)
end
