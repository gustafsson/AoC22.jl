fn = "example.txt"
# fn = "input.txt"
part2 = true

println()
R = readlines(fn)
M = split(R, "")

function parsemonkey(m)
    items = ints(m[2])
    opoffs = length("  Operation: new = old ")
    op = m[3][opoffs+1]
    if op != '*' && op != '+'
        throw(m[3][opoffs+1:end])
    end
    operand = m[3][opoffs+3:end]
    operand = operand == "old" ? :old : parse(Int, operand)
    testoffs = length("  Test: divisible by ")
    divisible = ints(m[4])[1]
    yes = ints(m[5])[1]
    no = ints(m[6])[1]
    (;items, op, operand, divisible, yes, no)
end

P = parsemonkey.(M)
G = prod(m.divisible for m in P)

function domonk(m, itms)
    for itm in itms
        worry = itm
        operand = m.operand == :old ? worry : m.operand
        if m.op == '*'
            worry *= operand
        else
            worry += operand
        end

        if part2
            worry %= G
        else
            worry = div(worry, 3)
        end

        target = worry % m.divisible == 0 ? m.yes : m.no
        #@show worry, target
        push!(I[target+1], worry)
    end
    empty!(itms)
end

I = [p.items for p in P]
counter = zeros(Int, length(P))
for _ in 1:(part2 ? 10000 : 20)
    for i in 1:length(P)
        counter[i] += length(I[i])
        domonk(P[i], I[i])
    end
end

#@show counter
maxmonk = sort(counter, rev=true)
@show part2, maxmonk[1] * maxmonk[2]
