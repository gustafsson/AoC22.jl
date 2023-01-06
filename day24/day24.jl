using AoC22

# fn = "example_simple.txt"
# fn = "example.txt"
fn = "input.txt"

R = readmatrix(fn)[2:end-1,2:end-1]
blizzard(c) = Dict(
    '>' => CI(0,1),
    '<' => CI(0,-1),
    '^' => CI(-1,0),
    'v' => CI(1,0),
    '.' => nothing,
    )[c]
Bdir = blizzard.(R)
nz = .!isnothing.(Bdir)
B = findall(nz)
Bdir = Bdir[nz]

steps = 0
function blizzardstep!(B, Bdir, sz)
    global steps += 1
    B .= mod1.(B .+ Bdir, (sz,))
end

function expedition!(P, B, Bdir, sz)
    union!(P, Set(P .+ [CI(0,1) CI(0,-1) CI(1,0) CI(-1,0)]))
    filter!(P) do p
        all(1 .≤ Tuple(p) .≤ sz)
    end
    blizzardstep!(B, Bdir, sz)
    setdiff!(P, B)
end

function waitclear(start)
    blizzardstep!(B, Bdir, size(R))
    while start ∈ B
        blizzardstep!(B, Bdir, size(R))
    end
end

function travel(start, stop)
    P = Set([start])
    for _ in 1:10000
        expedition!(P, B, Bdir, size(R))
        if isempty(P)
            return true
        end
        if stop ∈ P
            return false
        end
    end
end

waitclear(CI(1,1))
while travel(CI(1,1), CI(size(R))) end
blizzardstep!(B, Bdir, size(R))

@show part1 = steps

waitclear(CI(size(R)))
while travel(CI(size(R)), CI(1,1)) end
blizzardstep!(B, Bdir, size(R))

waitclear(CI(1,1))
while travel(CI(1,1), CI(size(R))) end
blizzardstep!(B, Bdir, size(R))

@show part2 = steps
