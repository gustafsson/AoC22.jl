fn = "example.txt"
# fn = "input.txt"
part2 = true

println()
R = readlines(fn)

M = [r[j] for r in R, j in 1:length(first(R))]
S = findfirst(M .== 'S')
E = findfirst(M .== 'E')

X = M .- 'a'
X[S] = 0
X[E] = 'z' - 'a'

if part2
    S = E
    E = nothing
    X = maximum(X) .- X
end

function A⭐step!(Q, D, X)
    sort!(Q, rev=true)
    d, p = pop!(Q)

    for j in 1:4
        z = 1im ^ j
        Δ = CartesianIndex(real(z), imag(z))

        n = p + Δ
        checkbounds(Bool, X, n) || continue

        1 < X[n] - X[p] && continue

        d = D[p] + 1
        d >= D[n] && continue
        D[n] = d

        push!(Q, (d, n))
    end
end

function A⭐(X, start)
    unvisited = 10length(X)
    D = fill(unvisited, size(X))
    D[start] = 0

    Q = [(0, start)]

    while !isempty(Q)
        A⭐step!(Q, D, X)
        # display(D)
    end

    D
end

D = A⭐(X, S)

if part2
    @show minimum(D[X .== maximum(X)])
else
    @show D[E]
end
