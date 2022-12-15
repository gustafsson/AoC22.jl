"""
costfunction
Queue
Steps
Distance
Matrix
"""
function A⭐step!(f, Q, S, D, X)
    sort!(Q, rev=true)
    d, p = pop!(Q)

    z = 1im
    # no diagonals
    for j in 1:4
        z *= 1im
        Δ = CartesianIndex(real(z), imag(z))

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

export A⭐
"""
    cost(a, b) = abs2(b - a)
    start = CartesianIndex(5, 5)
    X = 2randn(10, 10)
    #cumsum!(X, X, dims=1)
    #cumsum!(X, X, dims=2)
    X = round.(Int, X)
    display(X)
    S, D = A⭐(cost, X, start)
    display(S)
    display(D)
"""
function A⭐(f, X, start)
    unvisited = 10length(X)
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
