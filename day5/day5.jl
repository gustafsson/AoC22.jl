fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

R1, R2 = split(R, "")
pop!(R1)

function parsestack(R1)
    stackline(r) = collect(r[2:4:end])
    L = stackline.(R1)
    X = hcat(L...) |> permutedims
    F = filter.(!=(' '), eachcol(X))
    reverse!.(F)
end
PS = parsestack(R1)
display(PS)

parsemove(r) = parse.(Int, split(r)[[2, 4, 6]])
M = parsemove.(R2)

function move!(S, (n,i,j), f = reverse)
    A = S[i]
    B = S[j]
    append!(B, f(last(A, n)))
    resize!(A, length(A) - n)
    S
end

S = copy.(PS)
move!.((S,), M)
@show join(last.(S))

S = copy.(PS)
move!.((S,), M, identity)
@show join(last.(S))
