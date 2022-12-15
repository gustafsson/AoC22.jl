fn = "example.txt"
# fn = "input.txt"
part2 = true

println()
r = readlines(fn)[1]

n = part2 ? 14 : 4
@show findfirst(1:length(r)) do i
    i ≥ n && allunique(r[i-n+1:i])
end
