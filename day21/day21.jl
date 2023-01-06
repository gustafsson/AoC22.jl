fn = "example.txt"
# fn = "input.txt"

println()
R = readlines(fn)

S = split.(R, ": ")
rows = Dict(first.(S) .=> last.(S))

function evaltree(rows, x)
    y = rows[x]
    isempty(y) && return nothing
    v = tryparse(Int, y)
    isnothing(v) || return v
    @show x, y
    a,op,b = split(y)
    opf = Dict("+" => (+), "-" => (-), "*" => (*), "/" => (/))[op]
    A = evaltree(rows,a)
    B = evaltree(rows,b)
    if isnothing(A) || isnothing(B)
        nothing
    else
        opf(A, B)
    end
end
evaltree(rows, "root")

function backtree(rows, x, parent)
    y = rows[x]
    if isempty(y)
        return parent
    end

    v = tryparse(Int, y)
    isnothing(v) || return v

    a,op,b = split(y)
    A = evaltree(rows, a)
    B = evaltree(rows, b)

    if isnothing(B)
        B = if op == "+"
            parent - A
        elseif op == "-"
            A - parent
        elseif op == "*"
            parent / A
        elseif op == "/"
            A / parent
        end
        backtree(rows, b, B)

    elseif isnothing(A)
        A = if op == "+"
            parent - B
        elseif op == "-"
            parent + B
        elseif op == "*"
            parent / B
        elseif op == "/"
            parent * B
        end
        backtree(rows, a, A)
    else
        @assert false
    end
end

a,op,b = split(rows["root"])
rows["humn"] = ""
@asser isnothing(evaltree(rows, a))
root = evaltree(rows, b)
backtree(rows, a, root) |> Int
