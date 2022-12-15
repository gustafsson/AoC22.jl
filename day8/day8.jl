fn = "example.txt"
# fn = "input.txt"

import Base: Matrix
Matrix(lines::Vector{String}) = [r[j] for r in lines, j in 1:maximum(length.(lines))]

println()
M = readlines(fn) |> Matrix
M = parse.(Int, M)

top = accumulate(max, M, dims=1)
left = accumulate(max, M, dims=2)
bottom = accumulate(max, M[end:-1:1,:], dims=1)[end:-1:1,:]
right = accumulate(max, M[:,end:-1:1], dims=2)[:,end:-1:1]

ok = falses(size(M))
ok[1,:] .= true
ok[end,:] .= true
ok[:,1] .= true
ok[:,end] .= true
ok[2:end,:] .|= M[2:end,:] .> top[1:end-1,:]
ok[:, 2:end] .|= M[:,2:end] .> left[:,1:end-1]
ok[1:end-1,:] .|= M[1:end-1,:] .> bottom[2:end,:]
ok[:, 1:end-1] .|= M[:, 1:end-1] .> right[:,2:end,:]
@show sum(ok)

function scenicscore(M, p)
    t = M[p]
    above = reverse!(M[1:p[1]-1, p[2]])
    below = M[p[1]+1:end, p[2]]
    left = reverse!(M[p[1], 1:p[2]-1])
    right = M[p[1], p[2]+1:end]
    s = 1

    for x in [above, below, left, right]
        if isempty(x)
            return 0
        end

        f = findfirst(x .>= t)
        if isnothing(f)
            s *= length(x)
        else
            s *= f
        end
    end
    s
end

@show findmax([scenicscore(M, CartesianIndex(a,b)) for a in 1:size(M,1), b in 1:size(M,2)])
