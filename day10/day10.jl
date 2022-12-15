# fn = "example.txt"
fn = "example2.txt"
# fn = "input.txt"

println()
R = readlines(fn)

readrow(r) = r == "noop" ? [0] : [0, parse(Int, r[5:end])]
A = [1; readrow.(R)...]
C = cumsum(A)
M = 20:40:length(C)
sum(M .* C[M])

buffer = fill('.', 240)
for i in 1:240
    sprite = C[i]
    col = mod(i - 1, 40)
    lit = abs(sprite - col) <= 1
    if lit
        buffer[i] = '#'
    end
end

for i in 1:40:201
    println(join(buffer[i:i+39]))
end
