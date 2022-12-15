fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

row(r) = r[1] - 'A', r[3] - 'X'
P = row.(R)

outcome(a, b) = [3, 6, 0][1 + mod(b - a, 3)]
score((a, b)) = 1 + b + outcome(a, b)
@show score.(P) |> sum

select(a, o) = mod(a + (o - 1), 3)
function part2((a, o))
    b = select(a, o)
    score((a, b))
end
@show part2.(P) |> sum
