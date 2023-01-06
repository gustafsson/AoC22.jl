export printcharmatrix
printcharmatrix(C::Matrix{Char}) = C |> eachrow .|> join .|> println

function printcharmatrix(M::AbstractMatrix, mapping::Pair{Any,Char}...)
    d = Dict{Any,Char}(false => '.', true => '#', 2 => 'o')
    for (k,v) in mapping
        d[k] = v
    end
    C = getindex.((d,), M)
    printcharmatrix(C)
end
