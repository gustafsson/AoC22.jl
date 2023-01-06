using ProgressMeter

fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)
sequence = R[end]
@assert R[end-1] == ""
import Base: Matrix
Matrix(lines::Vector{String}) = [j ≤ length(r) ? r[j] : ' ' for r in lines, j in 1:maximum(length.(lines))]
M = Matrix(R[1:end-2])

function movenext(x, y, dir)
    x0 = x
    y0 = y
    while true
        dx = real(dir)
        dy = -imag(dir)
        y2 = mod1(y + dy, size(M,1))
        x2 = mod1(x + dx, size(M,2))
        t = M[y2, x2]
        if t == ' '
            x += dx
            y += dy
            continue
        end
        if t == '#'
            return x0, y0
        end
        @assert t == '.'
        return x2, y2
    end
end

x = findfirst('.', R[1])
y = 1
dir = 1 + 0im
sᵢ = 1
trace = []
while true
    n = findnext(r"\d*", sequence, sᵢ)
    if !isnothing(n) && !isempty(n) && first(n) == sᵢ
        for _ in 1:parse(Int, sequence[n])
            x,y = movenext(x, y, dir)
            push!(trace, (x,y))
        end
        sᵢ = last(n) + 1
        continue
    end
    if sᵢ > length(sequence)
        break
    end
    if sequence[sᵢ] == 'R'
        dir *= -1im
    elseif sequence[sᵢ] == 'L'
        dir *= 1im
    else
        @assert false
    end
    sᵢ += 1
end
function password(x,y,dir)
    fs = Dict(1 => 0, -1im => 1, -1 => 2, 1im => 3)
    1000y + 4x + fs[dir]
end

password(x,y,dir)


check(c::Bool) = Dict('.' => false, '#' => true)[c]
checkb(b) = try check.(b) catch nothing end
N = fn == "example.txt" ? 4 : 50
B = Any[M[y:y+N-1, x:x+N-1] for y in 1:N:size(M,1), x in 1:N:size(M,2)]
B = checkb.(B)

rotL(nothing) = nothing
rotL(b::BitMatrix) = reverse(permutedims(b), dims=1)
rotR(b::BitMatrix) = reverse(permutedims(b), dims=2)

display(.!isnothing.(B)) # C0 is designed from this, inputs may vary
if fn == "example.txt"
    C0 = [B[2,3], rotL(B[3,4]), B[3,3], B[2,2], B[1,3], B[2,1]]
else
    C0 = [B[2,2], rotR(B[1,3]), B[3,2], rotR(B[3,1]), B[1,2], rotR(B[4,1])]
end
shiftL(C::Vector{BitMatrix}) =
    [C[2], C[6], rotL(C[3]), C[1], rotR(C[5]), C[4]]
shiftR(C::Vector{BitMatrix}) = shiftL(shiftL(shiftL(C)))
shiftU(C::Vector{BitMatrix}) =
    [C[3], rotR(C[2]), rotR(rotR(C[6])), rotL(C[4]), C[1], rotR(rotR(C[5]))]
shiftD(C::Vector{BitMatrix}) = shiftU(shiftU(shiftU(C)))

Br = cat(B, rotL.(B), rotL.(rotL.(B)), rotL.(rotL.(rotL.(B))), dims=3)

function movenext2(C, x, y, dir)
    tC, tx, ty = nextpos(C, x, y, dir)
    if tC[1][ty, tx]
        return C, x, y
    else
        return tC, tx, ty
    end
end
function nextpos(C, x, y, dir)
    dx = real(dir)
    dy = -imag(dir)
    if 1 ≤ x + dx ≤ N && 1 ≤ y + dy ≤ N
        return C, x+dx, y+dy
    end
    if dx == 1
        return shiftL(C), 1, y
    elseif dx == -1
        return shiftR(C), N, y
    elseif dy == 1
        return shiftU(C), x, 1
    elseif dy == -1
        return shiftD(C), x, N
    end
end

C = shiftD(C0)
if fn=="example.txt"
    @assert C[1] == B[1,3]
end

x = 1
y = 1
dir = 1 + 0im
sᵢ = 1
trace = []
push!(trace, (findfirst((C[1],) .== Br), x, y, dir))
while true
    n = findnext(r"\d*", sequence, sᵢ)
    if !isnothing(n) && !isempty(n) && first(n) == sᵢ
        for _ in 1:parse(Int, sequence[n])
            C,x,y = movenext2(C, x, y, dir)
            push!(trace, (findfirst((C[1],) .== Br), x, y, dir))
        end
        sᵢ = last(n) + 1
        continue
    end
    if sᵢ > length(sequence)
        break
    end
    if sequence[sᵢ] == 'R'
        dir *= -1im
    elseif sequence[sᵢ] == 'L'
        dir *= 1im
    else
        @assert false
    end
    push!(trace, (findfirst((C[1],) .== Br), x, y, dir))
    sᵢ += 1
end

function mapcoord((Bᵢ, x, y, dir))
    xy = (2x-N-1) - 1im*(2y-N-1)
    for _ in 2:Bᵢ[3]
        xy *= -1im
        dir *= -1im
    end
    gx = (N + 1 + real(xy))÷2 + (Bᵢ[2] - 1) * N
    gy = (N + 1 - imag(xy))÷2 + (Bᵢ[1] - 1) * N
    gx, gy, dir
end

function showtrace(steps = length(trace))
    MT = copy(M)
    arrow = Dict(1 => '>', -1im => 'v', -1 => '<', 1im => '^')
    for (gx,gy,gd) in mapcoord.(trace[1:steps])
        MT[gy, gx] = arrow[gd]
    end
    display(MT)
end
showtrace(48)
length(trace)
Bᵢ = findfirst((C[1],) .== Br)

gx,gy,gd = mapcoord(last(trace))
password(gx,gy,gd)
