fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

P = eval.(Meta.parse.(R))
G = split(P, nothing)

function mycmp(a, b)
    n = min(length(a), length(b))
    c = mycmp.(first(a, n), first(b, n))
    filter!((!) ∘ iszero, c)
    if isempty(c)
        length(a) - length(b)
    else
        first(c)
    end
end
mycmp(a::Int, b::Int) = a - b
mycmp((a, b)) = mycmp(a, b)
C = mycmp.(G)
@show sum(findall(C .< 0))

P2 = filter((!) ∘ isnothing, P)
push!(P2, [[2]])
push!(P2, [[6]])
sort!(P2, lt = (a,b) -> mycmp(a,b) < 0)
@show findall(P2 .== ([[2]],)) .*  findall(P2 .== ([[6]],))
