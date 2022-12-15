fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

ints(t) = parse.(Int, split(t, r"\D"))

function row(r)
    a,b,c,d = ints(r)
    a:b, c:d
end
P = row.(R)

function part1((ab, cd))
    i = ab ∩ cd
    i == ab || i == cd
end
@show P .|> part1 |> sum

function part2((ab, cd))
    i = ab ∩ cd
    !isempty(i)
end
@show P .|> part2 |> sum
