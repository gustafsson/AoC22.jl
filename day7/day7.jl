fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

path = []
pathsize = Dict()

pathstr(path) = join(path, " ")

for r in R
    w = split(r)

    if w[2] == "cd"
        if w[3] == ".."
            pop!(path)
        else
            push!(path, w[3])
            get!(pathsize, pathstr(path), 0)
        end
        continue
    end

    sz = tryparse(Int, w[1])
    if !isnothing(sz)
        pathsize[pathstr(path)] += sz
    end
end
# display(pathsize)

subdirs(path) = filter(pathsize) do (key, size)
    startswith(key, path)
end
totalsize(path) = subdirs(path) |> values |> sum

S = totalsize.(keys(pathsize))
@show sum(S[S .<= 100_000])


total_disk_space = 70_000_000
needed_space = 30_000_000
used_disk_space = maximum(S)
unused_disk_space = total_disk_space - used_disk_space
missing_space = needed_space - unused_disk_space
@show minimum(S[S .> missing_space])
