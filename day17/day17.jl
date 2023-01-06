using Base.Iterators

fn = "example.txt"
# fn = "input.txt"

println()
windrow = readlines(fn)[1]
rightwindsequence = [c .== '>' for c in windrow]

rocks = [
    [1 1 1 1],

    [0 1 0
     1 1 1
     0 1 0],

    [1 1 1
     0 0 1
     0 0 1],

    [1;1;1;1;;],

    [1 1
     1 1],
    ]

rocks = permutedims.(BitMatrix.(rocks))

# each matrix col is one tetris row
height(W) = findlast(isone, W)[2]
findstart(W, r) = 3, height(W) + 4
function invalidpos(W, r, (x, y))
    if x <= 0 || x + size(r,1) - 1 > size(W, 1)
        return true
    end
    any(view(W, x:x + size(r,1)-1, y:y + size(r,2)-1) .& r)
end

function rockstep(W, r, (x, y), dx)
    if !invalidpos(W, r, (x + dx, y))
        x += dx
    end
    stopped = invalidpos(W,r,(x,y-1))
    if !stopped
        y -= 1
    end
    return x, y, stopped
end

function tetris!(W, rocks, rightwindsequence)
    H = Int[]
    seq_i = 0
    for r in rocks
        x, y = findstart(W, r)
        if y + size(r, 2) > size(W, 2)
            break
        end
        while true
            seq_i = mod1(seq_i += 1, length(rightwindsequence))
            dx = rightwindsequence[seq_i] ? 1 : -1
            x, y, stopped = rockstep(W, r, (x, y), dx)
            if stopped
                W[x:x + size(r,1)-1, y:y + size(r,2)-1] .|= r
                break
            end
        end
        push!(H, height(W))
    end
    H
end

wall = falses(7, 15_000)
wall[:,1] .= true # base line
@elapsed H = tetris!(wall, cycle(rocks), rightwindsequence)
H .-= 1 # discard base line
part1 = H[2022]
@show part1

# part 2
rockN = 1000000000000
#rockN = 2022

chunk(r) = UInt8(r.chunks[1])
B = chunk.(BitVector.(eachcol(wall)))
pattern = B[end-2000:end-100]
p1,_ = findlast(pattern, B)
p2,_ = findprev(pattern, B, p1-1)
p3,_ = findprev(pattern, B, p2-1)
period_height = p1-p2
period_height = p2-p3
r1,r2,r3 = searchsortedfirst.([H], (p1, p2, p3))
period_rocks = r1-r2
period_rocks = r2-r3

# Find tested_H congruent with target_H modulo period_height
target_rock_periods, target_rock_id = fldmod(rockN, period_rocks)
tested_rock_periods, tested_rock_id = fldmod(length(H), period_rocks)
tested_H_mod = H[length(H) - tested_rock_id + target_rock_id - period_rocks] + period_height

target_H = tested_H_mod + period_height*(target_rock_periods - tested_rock_periods)
part2 = target_H
@show part2
