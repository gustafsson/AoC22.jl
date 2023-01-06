import Base: mod1

mod1(ci::CartesianIndex{N}, sz::NTuple{N,Int}) where N =
    CartesianIndex(mod1.(Tuple(ci), sz))
