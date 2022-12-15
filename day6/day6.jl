fn = "example.txt"
# fn = "input.txt"

println()
r = readlines(fn)[1]

function firstunique(r, n)
    for i in n:length(r)
        if allunique(r[i-n+1:i])
            return i
        end
    end
end

@show firstunique(r, 4)
@show firstunique(r, 14)
