fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

key = ['a':'z'; 'A':'Z']
prio(c) = findfirst(==(c), key)

function part1(r)
    a = r[1 : end÷2]
    b = r[end÷2 + 1 : end]
    first(a ∩ b)
end
@show R .|> part1 .|> prio |> sum


part2(g) = first(∩(g...))
G = reshape(R, 3, :)
@show eachcol(G) .|> part2 .|> prio |> sum
