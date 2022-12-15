fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

ints(t) = parse.(Int, split(t, r"[^\-\d]", keepempty=false))
P = ints.(R)

function rowinterval((x,y,bx,by), y2)
    m = abs(bx-x) + abs(by-y) - abs(y - y2)
    x - m:x + m
end

# part1 brute force
function impossibles(P, testrow)
    S = Set{Int}()
    for p in P
        i = rowinterval(p, testrow)
        union!(S, i)
    end
    for (x,y,bx,by) in P
        if by == testrow
            delete!(S, bx)
        end
    end
    S
end
testrow = fn == "example.txt" ? 10 : 2000000
@show length(impossibles(P, testrow))

# part 2
function firstempty(P, n)
    x = 0
    I = rowinterval.(P, n)
    sort!(I, by = first)
    for i in I
        if x < first(i)
            return x
        end
        x = max(x, last(i)+1)
    end
    return x
end

testrows = fn == "example.txt" ? 20 : 4000000
F = [firstempty(P, n) for n in 1:testrows]
dby = findfirst(<(testrows), F)
dbx = F[dby]
tuning(x,y) = 4000000x + y
@show tuning(dbx, dby)

# debug
function rowtostring(P, testy, minx, maxx)
    J = fill('.', maxx - minx)
    for x in impossibles(P, testy)
        if minx <= x <= maxx
            J[x - minx] = '#'
        end
    end
    for (x,y,bx,by) in P
        if y == testy
            J[x - minx] = 'S'
        end
        if by == testy
            J[bx - minx] = 'B'
        end
    end
    join(J)
end

function printarea(P, xrange, yrange)
    println()
    for y in yrange
        println(rowtostring(P, y, extrema(xrange)...))
    end
end

if fn == "example.txt"
    printarea(P, -9:28, -10:26)
end
