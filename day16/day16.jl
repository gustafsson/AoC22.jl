fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

function parserow(r)
    flowrate = parse(Int, match(r"\d+", r).match)
    valve, connections... = [m.match for m in eachmatch(r"\b[A-Z]{2}\b", r)]
    valve, flowrate, connections
end
P = parserow.(R)

#display.(P)
V0 = getindex.(P, 1)
valvemap = Dict(v => i for (i,v) in enumerate(V0))
valvetoint0(v) = valvemap[v]
flow0 = getindex.(P, 2)
connecting_valves = [valvetoint0.(connections) for connections in getindex.(P, 3)]

# find shortest distance from each valve to all other valves
# depth-first is fine
function dist!(r, d, at)
    if r[at] ≤ d
        return
    end
    r[at] = d
    d += 1
    for n in connecting_valves[at]
        dist!(r, d, n)
    end
end
function dist(at, n = length(valvemap))
    r = fill(n+1, n)
    dist!(r, 0, at)
    @assert maximum(r) < n+1
    r
end

# skip valves with 0 flow
nz = sort(unique([valvetoint0("AA"); findall(flow0 .!= 0)]))
D = [dist(i)[nz] for i in nz]
flow = flow0[nz]
V = V0[nz]
valvetoint(v) = findfirst(V .== v)

@assert hcat(D...) == permutedims(hcat(D...))

# Part 1
function permutesearch(P, t, p1, D, F, maxtime)
    s2max = 0
    s1 = (maxtime + 1 - t) * F[p1]
    d = D[p1]
    for i in 1:length(P)
        p = P[i]
        t2 = t + 1 + d[p]
        if t2 > maxtime
            continue
        end
        deleteat!(P, i)
        s2 = permutesearch(setdiff(P, p), t2, p, D, F, maxtime)
        insert!(P, i, p)
        if s2 > s2max
            s2max = s2
        end
    end
    s1 + s2max
end

P = setdiff(1:length(V), valvetoint("AA"))
part1 = permutesearch(P, 1, valvetoint("AA"), D, flow, maxtime)
@show part1 # example 1651

# Part 2
function permutesearch2(P, (t₁,t₂), (p₁,p₂), D, F, maxtime)
    d₁ = D[p₁]
    d₂ = D[p₂]
    smax = 0
    for i in 1:length(P)
        p = P[i]
        t₁′ = t₁ + 1 + d₁[p]
        t₂′ = t₂ + 1 + d₂[p]

        t′ = min(t₁′, t₂′)
        if t′ >= maxtime
            continue
        end
        s = (maxtime + 1 - t′) * F[p]

        if t₁′ < t₂′ # who will reach valve 'p' first?
            # me
            t₂′ = t₂
            p₁′ = p
            p₂′ = p₂
        else
            # the elephant (wins a tie)
            t₁′ = t₁
            p₁′ = p₁
            p₂′ = p
        end

        deleteat!(P, i)
        sn = permutesearch2(P, (t₁′, t₂′), (p₁′, p₂′), D, F, maxtime)
        insert!(P, i, p)

        if s + sn > smax
            smax = s + sn
        end
    end
    smax
end

P = setdiff(1:length(V), valvetoint("AA"))
part2 = permutesearch2(P, (1,1), (valvetoint("AA"), valvetoint("AA")), D, flow, 26)
@show part2 # example 1707
