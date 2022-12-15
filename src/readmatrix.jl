export readmatrix
readmatrix(fn::String) = fn |> readlines |> Matrix

import Base: Matrix
Matrix(lines::Vector{String}) = [r[j] for r in lines, j in 1:maximum(length.(lines))]
