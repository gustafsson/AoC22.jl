fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

P = tryparse.(Int, R)
G = split(P, nothing)
@show maximum(sum, G)

S = sum.(G)
sort!(S)
@show sum(last(S, 3))
