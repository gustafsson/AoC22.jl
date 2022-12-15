using Scanf

fn = "input/day4.txt"
# fn = "input/day4_example.txt"

lines = readlines(fn)

p(t, f) =
function p(t)
    _,a,b,c,d = @scanf t "%d-%d,%d-%d" 0 0 0 0
    a:b, c:d
end

function part1(t)
    ab,cd = p(t)
    i = ab ∩ cd
    i == ab || i == cd
end

println()
for l in first(lines, 5)
    try
        println(l, "\t", p(l), "\t", part1(l))
    catch ex
        @show l
        @show ex
        rethrow()
    end
end

@show lines .|> part1 |> sum

function part2(t)
    _ = p(t)
end

# @show lines .|> part2 # |> sum
