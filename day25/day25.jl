using Test

# fn = "example_simple.txt"
# fn = "example.txt"
fn = "input.txt"

R = readlines(fn)

T = Dict('2' => 2, '1' => 1, '0' => 0', '-' => -1, '=' => -2)
revT = Dict(values(Dsnafu2int) .=> keys(T))
snafudigit2int(r) = T[r]
int2snafudigit(r) = revT[r]

parserevrow(r) = sum(snafudigit2int(r[i]) * 5^(i-1) for i in 1:length(r))
parserow(r) = parserevrow(reverse(r))
@test parserow("2=-01") == 976
@test parserow("1121-1110-1=0") == 314159265

function reversesnafu(x::Int)
    v = [0; parse.(Int, collect(string(x, base=5)))]

    for i in length(v):-1:2
        if v[i] > 2
            v[i-1] += 1
            v[i] -= 5
        end
    end

    if v[1] == 0
        v = v[2:end]
    end
    join(int2snafudigit.(v))
end
@test reversesnafu(4890) == "2=-1=0"

X = parserow.(R)
@show reversesnafu(sum(X))
