fn = "example.txt"
# fn = "example2.txt"
# fn = "input.txt"
part2 = false

println()
R = readlines(fn)

dir = Dict('R' => 1 + 0im, 'U' => 1im, 'L' => -1 + 0im, 'D' => -1im)
readrow(r) = dir[r[1]], parse(Int, r[3:end])
D = readrow.(R)

function move(H, T, nH)
    d = nH - T
    if -1 <= imag(d) <=1 && -1 <= real(d) <=1
        T # stay
    elseif imag(d) != 0 && real(d) != 0
        T + Complex(real(d)/abs(real(d)), imag(d)/abs(imag(d)))
    elseif imag(d) != 0
        T + Complex(0, imag(d)/abs(imag(d)))
    else
        T += real(d)/abs(real(d))
    end
end

Tn = part2 ? 10 : 2
T = fill(0 + 0im, Tn)
V = Set{Complex{Int}}()

for (d, n) in D#[1:2]
    #@show d, n
    for i in 1:n
        pt = T[1]
        nt = pt + d
        T[1] = nt
        for j in 2:length(T)
            nt = move(pt, T[j], nt)
            pt = T[j]
            T[j] = nt
        end
        #@show last(T)
        push!(V, last(T))
        #@show H, T
    end
end
# T
@show length(V)

function visualize(V)
    imin,imax = extrema([imag.(V); imag.(T)])
    rmin,rmax = extrema([real.(V); real.(T)])
    Z = fill(' ', imax-imin+1, rmax-rmin+1)
    for v in V
        Z[1+imag(v)-imin, 1+real(v)-rmin] = '#'
    end
    for (i,t) in enumerate(T)
        Z[1+imag(t)-imin, 1+real(t)-rmin] = string(i-1)[1]
    end

    join(join.(eachrow(Z)), '\n')
end

if startswith(fn, "example.")
    println(visualize(V))
end
