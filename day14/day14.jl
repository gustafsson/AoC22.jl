fn = "example.txt"
# fn = "input.txt"
part2 = true

println()
R = readlines(fn)

el(e) = parse.(Int, split(e, ","))
row(r) = el.(split(r, " -> "))
P = row.(R)

maxy(p) = maximum(last, p)
stopy = maximum(maxy, P)

W = zeros(Int, stopy+3, 1000)
if part2
    W[end,:] .= true
end
for p in P
    for i in 1:length(p)-1
        x0,y0 = p[i]
        x1,y1 = p[i+1]
        for x in min(x0,x1):max(x0,x1)
            for y in min(y0,y1):max(y0,y1)
                W[y+1,x] = true
            end
        end
    end
end

function printcharmatrix(C::Matrix{Char})
    println()
    C |> eachrow .|> join .|> println
end

function printcharmatrix(M::Matrix, mapping::Pair{Any,Char}...)
    d = Dict{Any,Char}(false => '.', true => '#', 2 => 'o')
    for (k,v) in mapping
        d[k] = v
    end
    C = getindex.((d,), M)
    printcharmatrix(C)
end

printcharmatrix(W[:,488:512])

function drop()
    x = 500
    if W[1, x] == 2
        return false
    end
    for y in 1:size(W, 1)-1
        for dx = [0,-1,1,2]
            if dx == 2
                W[y, x] = 2
                return true
            end

            if W[y+1, x + dx] == 0
                x += dx
                break
            end
        end
    end
    if part2
        throw("Borken")
    else
        return false
    end
end

c = 0
printcharmatrix(W[:,488:512])
while drop()
    c += 1
    # display(W[:,494:505] .* 1)
end
printcharmatrix(W[:,488:512])
@show c
