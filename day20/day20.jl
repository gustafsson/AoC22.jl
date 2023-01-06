fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

X = parse.(Int, R)
X .*= 811589153

function shiftpos!(M, i, n)
    v = popat!(M, i)
    j = mod1(i+n, length(M))
    if j == 1
        push!(M, v)
    else
        insert!(M, j, v)
    end
end

P = collect(1:length(X))
fn == "example.txt" && display((' ', X[P]))
for _ in 1:10
    for i in 1:length(P)
        f = findfirst(==(i), P)
        v = X[P[f]]
        shiftpos!(P, f, v)
        fn == "example.txt" && display((v, X[P]))
    end
end
fn == "example.txt" && display((' ', X[P]))

z = findfirst(iszero, X[P])
# 654 is too low
X[P][mod1.(z .+ [1000,2000,3000], end)] |> sum
