export positiveints
export ints

positiveints(t) = parse.(Int, split(t, r"\D", keepempty=false))
ints(t) = parse.(Int, split(t, r"[^\-\d]", keepempty=false))
